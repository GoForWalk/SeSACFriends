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
    
    
}

final class HomeMainUseCaseImpi: HomeMainUseCase, CheckAndRefreshIDToken {
    
    private var homeStatus: HomeStatus = .searching
    // TODO: 의존성 추가
    private var respository: HomeRepository = HomeRespositoryImpi()
    private var locationService: LocationService = LocationServiceImpi()
    private var lat: CLLocationDegrees = 0
    private var long: CLLocationDegrees = 0
    private let coodinatorTarget = PublishSubject<CLLocationCoordinate2D>()
    private let dispoaseBag = DisposeBag()
    private var timerDisposable: Disposable?
    
    let homeStatusOut = BehaviorSubject<HomeStatus>(value: .searching)
    let locationAuthError = PublishSubject<LocationAuthError>()
    let mapAnnotationInfo = PublishSubject<[MapAnnotionUserDTO]>()
    
    deinit {
        timerDisposable?.dispose()
        print("🐙🐙🐙🐙🐙🐙🐙 UseCase deinit \(self) 🐙🐙🐙🐙🐙🐙🐙🐙🐙🐙")
    }
    
}

extension HomeMainUseCaseImpi {
    
    func setHomeMode() {
        
    }
    
    func mapCenterCoordinate(center: CLLocationCoordinate2D) {
        
        self.lat = center.latitude
        self.long = center.longitude
        coodinatorTarget.onNext(center)
            
        
        
        timerDisposable = coodinatorTarget
//            .debug()
            .flatMapLatest { coordinate in
                return Observable<Int>.timer(.seconds(0), period: .milliseconds(10000), scheduler: MainScheduler.instance)
                    .map { [weak self] _ -> CLLocationCoordinate2D in
                        guard let self else { return CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0) }

                        return CLLocationCoordinate2D(latitude: CLLocationDegrees(self.lat), longitude: CLLocationDegrees(self.long))
                    }
            }
//            .debug()
            .subscribe { [weak self] coordinate in
                guard let strongSelf = self, let element = coordinate.element else { return }
                strongSelf.timerDisposable?.dispose()
                strongSelf.respository.fetchMainMapAnnotation(lat: element.latitude, long: element.longitude)
//                    .debug()
                    .subscribe { [weak self] annotationInfo in
                        self?.mapAnnotationInfo.onNext(annotationInfo)
                    }
                    .disposed(by: strongSelf.dispoaseBag)
            }
        
//        respository.fetchMainMapAnnotation(lat: lat, long: long)
    }
    
    private func setCurrentLocation() {
        locationService.requestCurrentLocation()
    }
        
    func requestLocationAuth() {
                    
        locationService.observeUpdateLocationAuthorization()
            .subscribe { [weak self] auth in
                guard let locationAuth = auth.element else { return }
                switch locationAuth {
                case .notDetermined:
                    self?.locationService.requestAuthorization()
                case .denied, .restricted:
                    self?.locationAuthError.onNext(.authNotAllowed)
                case .authorizedWhenInUse:
                    self?.locationService.requestCurrentLocation()
                default:
                    print("Default")
                }
            }
            .dispose()
    }
    
    func currentLocationOut() -> Observable<Result<[CLLocation], Error>> {
        return locationService.observeCurrentLocation()
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
