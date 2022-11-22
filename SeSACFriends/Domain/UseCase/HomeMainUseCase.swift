//
//  HomeMainUseCase.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/16.
//

import Foundation
import MapKit
import CoreLocation

import RxSwift
import RxCocoa


protocol HomeMainUseCase: UseCase {
    
    var homeStatusOut: BehaviorSubject<HomeStatus> { get }
    var locationAuthError: PublishSubject<LocationAuthError> { get }
    var mapAnnotationInfo: PublishSubject<[MapAnnotionUserDTO]> { get }
    var searchWordResult: PublishSubject<MapSearchWordDTO> { get }

}

final class HomeMainUseCaseImpi: HomeMainUseCase, CheckAndRefreshIDToken {
    
    private var homeStatus: HomeStatus = .searching
    // TODO: 의존성 추가
    private var respository: HomeRepository = HomeRespositoryImpi()
    private var locationService: LocationService = LocationServiceImpi()
    private var lat: CLLocationDegrees?
    private var long: CLLocationDegrees?
    private let coodinatorTarget = PublishSubject<CLLocationCoordinate2D>()
    private let dispoaseBag = DisposeBag()
    private var timerDisposable: Disposable?
    private var isTimerGo = true
    private var isTimerDisposed: Bool?
    private var defaultLocation: (lat: CLLocationDegrees, long: CLLocationDegrees) = (37.517821, 126.886284)
    
    let homeStatusOut = BehaviorSubject<HomeStatus>(value: .searching)
    let locationAuthError = PublishSubject<LocationAuthError>()
    let mapAnnotationInfo = PublishSubject<[MapAnnotionUserDTO]>()
    let searchWordResult = PublishSubject<MapSearchWordDTO>()
    
    deinit {
        timerDisposable?.dispose()
        print("🐙🐙🐙🐙🐙🐙🐙 UseCase deinit \(self) 🐙🐙🐙🐙🐙🐙🐙🐙🐙🐙")
    }
    
}

extension HomeMainUseCaseImpi {
    
    /// 네트워크 통신 결과 따라서 모드 변경하는 코드
    func setHomeMode() {
        
    }
    
    func getSearchWord() {
        let temp = respository.fetchMainMapSearchWord(lat: lat ?? defaultLocation.lat, long: long ?? defaultLocation.long)
        
        temp.subscribe { [weak self] mapSearchWordDTO in
            self?.searchWordResult.onNext(mapSearchWordDTO)
        } onFailure: { [weak self] error in
            
            let error = error as? APIError
            
            self?.checkRefreshToken(errorCode: error?.rawValue ?? 500) {
                self?.getSearchWord()
            }
            
        }
        .disposed(by: dispoaseBag)
        
    }
    
    func mapCenterCoordinate(center: CLLocationCoordinate2D) {
        isTimerGo = true
        self.lat = center.latitude
        self.long = center.longitude
        coodinatorTarget.onNext(center)
        startNetworkLoactionRequest()
    }
    
    func requestLocation() {
        locationService.observeUpdateLocationAuthorization()
            .subscribe { [weak self] auth in
                guard let locationAuth = auth.element else { return }
                self?.checkLocationAuth(authStatus: locationAuth)
            }
            .dispose()
    }
    
    func currentLocationOut() -> Observable<Result<[CLLocation], Error>> {
        return locationService.observeCurrentLocation()
    }
    
    func stopResquest() {
        isTimerGo = false
    }
    
    func restartRequest()  {
        // 마지막 위치에서 지도 다시 시작!!
        // 마지막 위치가 없으면 -> 내 위치에서 시작(위치 요청)
        isTimerGo = true
        if isTimerDisposed ?? true {
            self.isTimerDisposed = false
            guard let lat, let long else {
                requestLocation()
                return
            }
            startNetworkLoactionRequest() // 여기서 재구독
            mapCenterCoordinate(center:CLLocationCoordinate2D(latitude: lat, longitude: long)
            )

        }
    }
    
}

private extension HomeMainUseCaseImpi {
    
    func checkLocationAuth(authStatus: CLAuthorizationStatus) {
        switch authStatus {
        case .notDetermined:
            locationService.requestAuthorization()
            requestLocation()
        case .denied, .restricted:
            locationAuthError.onNext(.authNotAllowed)
        case .authorizedWhenInUse:
            locationService.requestCurrentLocation()
        default:
            print("Default")
        }
    }
    
    func setCurrentLocation() {
        locationService.requestCurrentLocation()
    }
    
    func startNetworkLoactionRequest() {
        
        timerDisposable = coodinatorTarget
            .flatMapLatest { coordinate in
                return Observable<Int>.timer(.seconds(0), period: .milliseconds(10000), scheduler: MainScheduler.instance)
                    .map { [unowned self] _ -> CLLocationCoordinate2D in
                        return CLLocationCoordinate2D(latitude: CLLocationDegrees(self.lat ?? self.defaultLocation.lat), longitude: CLLocationDegrees(self.long ?? self.defaultLocation.long))
                    }
            }
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .share()
            .take(until: { [unowned self] _ in
                !self.isTimerGo
            })
            .debug()
            .subscribe(onNext: { [unowned self] coordination in
                self.timerDisposable?.dispose()
                self.isTimerDisposed = false
                self.respository.fetchMainMapAnnotation(lat: coordination.latitude, long: coordination.longitude)
                    .subscribe { annotationInfo in
                        self.mapAnnotationInfo.onNext(annotationInfo)
                    } onFailure: { error in
                        if let apiArror = error as? APIError {
                            self.checkRefreshToken(errorCode: apiArror.rawValue) {
                                self.startNetworkLoactionRequest()
                            }
                        }
                    }
                    .disposed(by: dispoaseBag)
            }, onDisposed: { [weak self] in
                self?.isTimerDisposed = true
            })
        
    }
    
}

@frozen enum HomeStatus {
    case searching
    case matchWaiting
    case matched
}

extension HomeStatus {
    var buttonImage: ImageInfo {
        switch self {
        case .searching:
            return Images.searchlarge
        case .matchWaiting:
            return Images.antenna
        case .matched:
            return Images.message
        }
    }
}

@frozen enum LocationAuthError: String {
    case authNotAllowed = "위치서비스가 꺼져 있어서 위치 권한 요청을 못합니다."
    case locationServiceOFF
}
