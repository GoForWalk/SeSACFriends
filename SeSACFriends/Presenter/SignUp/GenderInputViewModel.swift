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
        let genderTapped: ControlEvent<IndexPath>
        let signUpButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let validation = BehaviorRelay(value: false)
        let signUpResult = PublishSubject<Int>()
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        self.configureInput(input: input, disposeBag: disposeBag)
        return createOutput(input: input, disposeBag: disposeBag)
    }
    
}

private extension GenderInputViewModel {
    
    func configureInput(input: Input, disposeBag: DisposeBag) {
        input.genderTapped
            .map { GenderInfo.allCases[$0.item].rawValue }
            .withUnretained(self)
            .bind { $0.useCase.checkGenderPick(genderInt: $1) }
            .disposed(by: disposeBag)
        
        input.signUpButtonTapped
            .bind { [weak self] in
                self?.useCase.signUpStart()
            }
            .disposed(by: disposeBag)
    }
    
    func createOutput(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        useCase.genderValidation
            .bind(to: output.validation)
            .disposed(by: disposeBag)
        
        useCase.signUpResult
            .bind(to: output.signUpResult)
            .disposed(by: disposeBag)
        
        return output
    }
    
}

