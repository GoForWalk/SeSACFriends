//
//  HomeMainViewModel.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/16.
//

import Foundation
import MapKit
import CoreLocation

import RxCocoa
import RxSwift

final class HomeMainViewModel: ViewModelType {
    
    // TODO: 나중에 의존성 주입으로 처리
    var useCase = HomeMainUseCaseImpi()
    
    struct Input {
        let mapCenterLocation: PublishRelay<CLLocationCoordinate2D>
        let setLocationButtonTapped: ControlEvent<Void>
        let viewWillAppear: ControlEvent<Void>
        let viewDidDisappear: ControlEvent<Void>
    }
    
    struct Output {
        let buttonStatus = BehaviorSubject<HomeStatus>(value: .searching)
        let mapCenterLocation = PublishSubject<CLLocation>()
        let authError = PublishSubject<LocationAuthError>()
        let mapAnnotation = PublishSubject<[MapAnnotionUserDTO]>()
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        self.configureInput(input: input, disposeBag: disposeBag)
        return createOutput(input: input, disposeBag: disposeBag)
    }
    
}

private extension HomeMainViewModel {
        
    func configureInput(input: Input, disposeBag: DisposeBag) {
        
        input.setLocationButtonTapped
            .bind { [weak self] in
                self?.useCase.requestLocation()
            }
            .disposed(by: disposeBag)
        
        input.mapCenterLocation
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .asObservable()
            .bind(with: self) { vm, coordinate in
                vm.useCase.mapCenterCoordinate(center: coordinate)
            }
            .disposed(by: disposeBag)
        
        input.viewDidDisappear
            .debug()
            .subscribe(with: self) { vm, _ in
                vm.useCase.stopResquest()
            }
            .disposed(by: disposeBag)
        
        input.viewWillAppear
            .debug()
            .subscribe(with: self) { vm, _ in
                vm.useCase.restartRequest()
            }
            .disposed(by: disposeBag)
        
    }//: configureInput
    
    func createOutput(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        useCase.homeStatusOut
            .bind(to: output.buttonStatus)
            .disposed(by: disposeBag)
        
        useCase.mapAnnotationInfo
            .subscribe { annotaions in
                output.mapAnnotation.onNext(annotaions)
            }
            .disposed(by: disposeBag)
        
        useCase.currentLocationOut()
            .subscribe { locationResult in
                switch locationResult.element {
                case .success(let locations):
                    output.mapCenterLocation.onNext(locations.first!)
                default:
                    print("Current Location Error")
                    return
                }
            }
            .disposed(by: disposeBag)
            
        useCase.locationAuthError
            .subscribe(output.authError)
            .disposed(by: disposeBag)
        
        return output
    }
    
}
