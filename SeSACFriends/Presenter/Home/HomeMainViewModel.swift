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
        let mapCenterLocation: Binder<CLLocationCoordinate2D>
    }
    
    struct Output {
        let buttonStatus = PublishSubject<HomeStatus>()
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        self.configureInput(input: input, disposeBag: disposeBag)
        return createOutput(input: input, disposeBag: disposeBag)
    }
    
}

private extension HomeMainViewModel {
        
    func configureInput(input: Input, disposeBag: DisposeBag) {
        
    }
    
    func createOutput(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        useCase.homeStatusOut
            .bind(to: output.buttonStatus)
            .disposed(by: disposeBag)
        
        return output
    }
    
}
