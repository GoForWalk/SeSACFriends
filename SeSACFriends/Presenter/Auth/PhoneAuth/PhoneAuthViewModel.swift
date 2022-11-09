//
//  PhoneAuth.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/08.
//

import Foundation

import RxSwift
import RxCocoa

final class PhoneAuthViewModel: ViewModelType {
        
    private let authUseCase: AuthUseCase = AuthUseCaseImpi()
    private var tempCount = 0

//    init(authUseCase: AuthUseCase) {
//        self.authUseCase = authUseCase
//    }
    
    struct Input {
        let phoneNum: ControlProperty<String?>
        let sendMessageButton: ControlEvent<Void>
    }
    
    struct Output {
        let phoneNumValidated = BehaviorRelay(value: false)
        let phoneNumText = BehaviorRelay<String>(value: "")
        let messageAuthFlow = BehaviorRelay<Bool>(value: false)
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        self.configureInput(input: input, disposeBag: disposeBag)
        return createOuput(input: input, disposeBag: disposeBag)
    }
    
}

private extension PhoneAuthViewModel {
    
    func configureInput(input: Input, disposeBag: DisposeBag) {
        input.phoneNum.orEmpty
            .map { [weak self] str in
                self?.displayText(str: str) ?? ""
            }
            .withUnretained(self)
            .bind {
                $0.authUseCase.validatePhone($1)
            }
            .disposed(by: disposeBag)
        
        input.sendMessageButton
            .bind { [weak self] in
                self?.authUseCase.sendMessage()
            }
            .disposed(by: disposeBag)
    }
    
    func createOuput(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        authUseCase.phoneNumText
            .withUnretained(self)
            .map {
                $0.displayText(str: $1)
            }
            .bind(to: output.phoneNumText)
            .disposed(by: disposeBag)
        
        authUseCase.validation
            .bind(to: output.phoneNumValidated)
            .disposed(by: disposeBag)
        
        authUseCase.messageApproved
            .bind(to: output.messageAuthFlow)
            .disposed(by: disposeBag)
        
        return output
    }
    
    private func displayText(str: String) -> String {
        var result = str.replacingOccurrences(of: "-", with: "")
        print(tempCount)
        guard tempCount < result.count else {
            tempCount -= 1
            return str }
        
        tempCount = result.count
        
        switch result.count {
        case 3...5:
            result.insert("-", at: String.Index(utf16Offset: 3, in: result))
        case 6...10:
            result.insert("-", at: String.Index(utf16Offset: 3, in: result))
            result.insert("-", at: String.Index(utf16Offset: 7, in: result))
        case 11:
            result.insert("-", at: String.Index(utf16Offset: 3, in: result))
            result.insert("-", at: String.Index(utf16Offset: 8, in: result))
        default:
            print("ㅇㅅㅇ")
        }
        
        return result
    }
    
}
