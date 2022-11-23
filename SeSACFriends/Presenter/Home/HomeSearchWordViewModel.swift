//
//  HomeSearchWordViewModel.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/21.
//

import Foundation

import RxCocoa
import RxSwift

final class HomeSearchWordViewModel: ViewModelType {
    
    let useCase: HomeMainUseCase
    
    struct Input {
        
    }
    
    struct Output {
        let nearByWord = BehaviorSubject<MapSearchWordDTO>(value: MapSearchWordDTO(nearByWord: [], recommandWord: []))
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        self.configureInput(input: input, disposeBag: disposeBag)
        return createOutput(input: input, disposeBag: disposeBag)
    }
    
    init(useCase: HomeMainUseCase) {
        self.useCase = useCase
    }
}

private extension HomeSearchWordViewModel {
        
    func configureInput(input: Input, disposeBag: DisposeBag) {
        
    }
    
    func createOutput(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        
        return output
    }
    
}
