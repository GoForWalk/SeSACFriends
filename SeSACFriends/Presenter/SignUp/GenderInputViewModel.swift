//
//  GenderInputViewModel.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/11.
//

import Foundation

import RxSwift
import RxCocoa

final class GenderInputViewModel: ViewModelType {
    
    let useCase: SignUpUseCase
    
    init(useCase: SignUpUseCase){
        self.useCase = useCase
    }
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        self.configureInput(input: input, disposeBag: disposeBag)
        return createOutput(input: input, disposeBag: disposeBag)
    }
    
}

private extension GenderInputViewModel {
    
    func configureInput(input: Input, disposeBag: DisposeBag) {
        
    }
    
    func createOutput(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        
        
        return output
    }
    
}

