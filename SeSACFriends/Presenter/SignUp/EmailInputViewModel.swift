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
        let emailValidation = BehaviorRelay(value: false)
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        self.configureInput(input: input, disposeBag: disposeBag)
        return createOutput(input: input, disposeBag: disposeBag)
    }
    
}

private extension EmailInputViewModel {
    
    func configureInput(input: Input, disposeBag: DisposeBag) {
        input.emailTextInput.orEmpty
            .withUnretained(self)
            .bind { $0.useCase.checkEmailValidate(str: $1) }
            .disposed(by: disposeBag)
    }
    
    func createOutput(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        useCase.emailValidateion
            .bind(to: output.emailValidation)
            .disposed(by: disposeBag)
        
        return output
    }
    
}

