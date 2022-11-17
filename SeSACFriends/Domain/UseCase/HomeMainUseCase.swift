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
    
    let homeStatusOut = BehaviorSubject<HomeStatus>(value: .searching)
    let locationAuthError = PublishSubject<LocationAuthError>()
    
    deinit {
        print("🐙🐙🐙🐙🐙🐙🐙 UseCase deinit \(self) 🐙🐙🐙🐙🐙🐙🐙🐙🐙🐙")
    }
    
}

extension HomeMainUseCaseImpi {
    
    func setHomeMode() {
        
    }
    
    func mapCenterCoordinate(center: CLLocationCoordinate2D) {
        self.lat = center.latitude
        self.long = center.longitude
    }
    
    func getUserLocation() -> Single<[MapAnnotionUserDTO]> {
        respository.fetchMainMapAnnotation(lat: lat, long: long)
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
