//
//  SignUpUseCase.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/11.
//

import Foundation

import RxSwift
import RxCocoa

protocol SignUpUseCase {
    
    var nickValidation: BehaviorSubject<Bool> { get }
    var birthValidation: BehaviorSubject<Bool> { get }
    var emailValidateion: BehaviorSubject<Bool> { get }
    
    func checkNickValidate(str: String)
    func checkBirthValidate(date: Date)
    func checkEmailValidate(str: String)
}

final class SignInUseCaseImpi: SignUpUseCase {
    
    // MARK: - Output
    let nickValidation = BehaviorSubject(value: false)
    let birthValidation = BehaviorSubject(value: false)
    let emailValidateion = BehaviorSubject(value: false)
    
    // MARK: - Stored Properties
    private var nickName: String?
    private var birth: Date?
    private var email: String?
    
    deinit {
        print("🐙🐙🐙🐙🐙🐙🐙 UseCase deinit \(self) 🐙🐙🐙🐙🐙🐙🐙🐙🐙🐙")
    }
}

// MARK: - Input
extension SignInUseCaseImpi {

    func checkNickValidate(str: String) {
        if str.count > 0 && str.count >= 10 {
            nickValidation.onNext(true)
            nickName = str
        } else {
            nickValidation.onNext(false)
            nickName = nil
        }
    }
    
    func checkBirthValidate(date: Date) {
        let now = Date()
        let calendar = Calendar.current
        
        let ageComponent = calendar.dateComponents([.year], from: date, to: now)
        guard let age = ageComponent.year else { return }
        
        if age > 17 {
            birthValidation.onNext(true)
            self.birth = date
        } else {
            birthValidation.onNext(false)
        }
    }
    
    func checkEmailValidate(str: String) {
        if validateEmailRegEx(str) {
            emailValidateion.onNext(true)
            self.email = str
        } else {
            emailValidateion.onNext(false)
        }
    }
}

private extension SignInUseCaseImpi {
    
    func validateEmailRegEx(_ string: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return string.range(of: emailRegEx, options: .regularExpression) != nil
    }

}
