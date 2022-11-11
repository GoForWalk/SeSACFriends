//
//  EmailInputViewModel.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/11.
//

import Foundation

import RxSwift
import RxCocoa

final class EmailInputViewModel: ViewModelType {
    
    let useCase: SignUpUseCase
    
    init(useCase: SignUpUseCase){
        self.useCase = useCase
    }
    
    struct Input {
        let emailTextInput: ControlProperty<String?>
    }
    
    struct Output {
        
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        self.configureInput(input: input, disposeBag: disposeBag)
        return createOutput(input: input, disposeBag: disposeBag)
    }
    
}

private extension EmailInputViewModel {
    
    func configureInput(input: Input, disposeBag: DisposeBag) {
        
    }
    
    func createOutput(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        
        
        return output
    }
    
}

