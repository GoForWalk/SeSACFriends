//
//  LocationService.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/17.
//

import Foundation
import CoreLocation

import RxSwift
import RxRelay

protocol LocationService {
    
    func requestCurrentLocation()
    func requestAuthorization()
    func observeUpdateLocationAuthorization() -> Observable<CLAuthorizationStatus>
    func observeCurrentLocation() -> Observable<Result<[CLLocation], Error>>
}

final class LocationServiceImpi: NSObject, LocationService {
    
    var locationManager: CLLocationManager?
    var disposeBag = DisposeBag()
    var authorizationStatus = BehaviorRelay<CLAuthorizationStatus>(value: .notDetermined)
    var currentLocation = PublishSubject<Result<[CLLocation], Error>>()
    
    override init() {
        super.init()
        self.locationManager = CLLocationManager()
        self.locationManager?.distanceFilter = CLLocationDistance(3)
        self.locationManager?.delegate = self
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestCurrentLocation() {
        locationManager?.requestLocation()
    }
    
    func requestAuthorization() {
        locationManager?.requestWhenInUseAuthorization()
    }
    
    func observeUpdateLocationAuthorization() -> Observable<CLAuthorizationStatus> {
        return authorizationStatus.asObservable()
    }
    
    func observeCurrentLocation() -> Observable<Result<[CLLocation], Error>> {
        return currentLocation.asObservable()
    }
    
}

extension LocationServiceImpi: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function, locations)
        currentLocation.onNext(.success(locations))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        currentLocation.onNext(.failure(error))
    }
    
    @available(iOS 14.0, *)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        guard let locationManager else { return }
        
        let authorizationStatus: CLAuthorizationStatus
        authorizationStatus = locationManager.authorizationStatus
        self.authorizationStatus.accept(manager.authorizationStatus)
        
    }
}

