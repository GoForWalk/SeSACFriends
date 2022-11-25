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
    var searchWordResult: BehaviorSubject<[CustomData]> { get }
    var myTagOutput: PublishSubject<Result<[CustomData], Error>> { get }
    var postStudySearch: PublishSubject<QueueSuccessType> { get }
    
    func addTagFromNearByTags(index: Int)
    func formattingTag(myTag: String)
    func removeMyTag(index: Int)
    func postStudyList()
    func getSearchWord()
    func setHomeMode()
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
    private var defaultLocation: (lat: CLLocationDegrees, long: CLLocationDegrees) = (37.517819364682694, 126.88647317074734)
    private var myTags = [String]()
    private var nearByTags = [CustomData]()
    
    let homeStatusOut = BehaviorSubject<HomeStatus>(value: .searching)
    let locationAuthError = PublishSubject<LocationAuthError>()
    let mapAnnotationInfo = PublishSubject<[MapAnnotionUserDTO]>()
    let searchWordResult = BehaviorSubject<[CustomData]>(value: [])
    let myTagOutput = PublishSubject<Result<[CustomData], Error>>()
    let postStudySearch = PublishSubject<QueueSuccessType>()
    
    deinit {
        timerDisposable?.dispose()
        print("🐙🐙🐙🐙🐙🐙🐙 UseCase deinit \(self) 🐙🐙🐙🐙🐙🐙🐙🐙🐙🐙")
    }
    
}

extension HomeMainUseCaseImpi {
    
    /// 네트워크 통신 결과 따라서 모드 변경하는 코드
    func setHomeMode() {
        respository.fetchMyQueueStatus()
            .subscribe(with: self) { uc, homeStatus in
                uc.homeStatusOut.onNext(homeStatus)
            } onFailure: { uc, error in
                let apiError = error as? APIError
                uc.checkRefreshToken(errorCode: apiError?.rawValue ?? 500) {
                    uc.setHomeMode()
                }
            }
            .disposed(by: dispoaseBag)
    }
    
    /// postStudyListButtonTapped
    func postStudyList() {
        
        if myTags.isEmpty {
            myTags.append("anything")
        }
        
        let temp = respository.postQueueStudy(lat: lat ?? defaultLocation.lat, long: long ?? defaultLocation.long, studyList: myTags.description)
        
        temp.subscribe(with: self, onSuccess: { uc, queueSuccessType in
            uc.postStudySearch.onNext(queueSuccessType)
        }, onFailure: { uc, error in
            let apiError = error as? APIError
            uc.checkRefreshToken(errorCode: apiError?.rawValue ?? 500) {
                uc.postStudyList()
            }
        })
        .disposed(by: dispoaseBag)
    }
    

    func formattingTag(myTag: String) {
        
        var temp = myTag.components(separatedBy: " ")
                
        temp.forEach { [weak self] word in
            if word.count > 8 {
                self?.myTagOutput.onNext(.failure(TagValidation.validationError))
                temp = temp.filter({ word in
                    word.count < 9
                })
                return
            }
        }
        
        myTags.append(contentsOf: temp)
        myTags = unique(source: myTags)
        
        if myTags.count >= 9 {
            myTagOutput.onNext(.failure(TagValidation.moreThanMaxTagNum))
            return
        }
        
        let result = myTags.map { word in
            return CustomData(text: word, buttonStyle: .myTag)
        }
        myTagOutput.onNext(.success(result))
    }
    
    func addTagFromNearByTags(index: Int) {
        let tagTitle = nearByTags[index].text
        formattingTag(myTag: tagTitle)
    }
    
    func removeMyTag(index: Int) {
        myTags.remove(at: index)
        let temp = myTags.map { word in
            return CustomData(text: word, buttonStyle: .myTag)
        }
        myTagOutput.onNext(.success(temp) )
    }
    
    /// 네트워크 통신으로 태그를 받아오는 과정
    func getSearchWord() {
        let temp = respository.fetchMainMapSearchWord(lat: lat ?? defaultLocation.lat, long: long ?? defaultLocation.long)
        
        temp.subscribe { [weak self] mapSearchWordDTO in
            
            var result = [CustomData]()
            result.append(contentsOf: mapSearchWordDTO.recommandWord.map({ word in
                CustomData(text: word, buttonStyle: .recommand)
            }))
            result.append(contentsOf: mapSearchWordDTO.nearByWord.map({ word in
                CustomData(text: word, buttonStyle: .nearUser)
            }))
            
            self?.nearByTags = result
            print("📱📱📱📱 \(#function) searchWordResult에 dataSource 추가")
            self?.searchWordResult.onNext(result)
            
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
    
    func unique<S : Sequence, T : Hashable>(source: S) -> [T] where S.Iterator.Element == T {
        var buffer = [T]()
        var added = Set<T>()
        for elem in source {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
    
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
            .debug()
            .share()
            .flatMapLatest { coordinate in
                return Observable<Int>.timer(.seconds(0), period: .milliseconds(10000), scheduler: MainScheduler.instance)
                    .map { [unowned self] _ -> CLLocationCoordinate2D in
                        return CLLocationCoordinate2D(latitude: CLLocationDegrees(self.lat ?? self.defaultLocation.lat), longitude: CLLocationDegrees(self.long ?? self.defaultLocation.long))
                    }
            }
            .take(until: { [unowned self] _ in
                !self.isTimerGo
            })
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
    /// statusCode = 201
    case searching
    /// statusCode = 200 ,matched = 0
    case matchWaiting
    /// statusCode = 200 ,matched = 1
    case matched(nick: String, uid: String)
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

@frozen enum TagValidation: String, Error {
    case validationError = "최소 한 자 이상, 최대 8글자까지 작성 가능합니다."
    case moreThanMaxTagNum = "스터디를 더 이상 추가할 수 없습니다."
}
