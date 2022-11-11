//
//  NickInputViewModel.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/11.
//

import Foundation

import RxSwift
import RxCocoa

final class NickInputViewModel: ViewModelType {
    
    let useCase: SignUpUseCase
    
    init(useCase: SignUpUseCase){
        self.useCase = useCase
    }
    
    struct Input {
        let nickTextInput: ControlProperty<String?>
    }
    
    struct Output {
        let nickValidation = BehaviorRelay(value: false)
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        self.configureInput(input: input, disposeBag: disposeBag)
        return createOutput(input: input, disposeBag: disposeBag)
    }
    
}

private extension NickInputViewModel {
    
    func configureInput(input: Input, disposeBag: DisposeBag) {
        input.nickTextInput.orEmpty
            .withUnretained(self)
            .bind {
                $0.useCase.checkNickValidate(str: $1)
            }
            .disposed(by: disposeBag)
        
    }
    
    func createOutput(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        useCase.nickValidation
            .bind(to: output.nickValidation)
            .disposed(by: disposeBag)
        
        return output
    }
    
}
