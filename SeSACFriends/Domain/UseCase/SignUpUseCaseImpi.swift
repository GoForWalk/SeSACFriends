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
    var emailValidation: BehaviorSubject<Bool> { get }
    var genderValidation: BehaviorSubject<Bool> { get }
    var signUpResult: PublishSubject<Int> { get }

    func checkNickValidate(str: String)
    func checkBirthValidate(date: Date)
    func checkEmailValidate(str: String)
    func checkGenderPick(genderInt: Int)
    func signUpStart()
}

final class SignInUseCaseImpi: SignUpUseCase {
    
    // MARK: - Output
    let nickValidation = BehaviorSubject(value: false)
    let birthValidation = BehaviorSubject(value: false)
    let emailValidation = BehaviorSubject(value: false)
    let genderValidation = BehaviorSubject(value: false)
    let signUpResult = PublishSubject<Int>()
    
    // MARK: - Stored Properties
    private var nickName: String?
    private var birth: String?
    private var email: String?
    private var gender: Int?
    private let apiService: APIService = APIServiceImpi()

    deinit {
        print("🐙🐙🐙🐙🐙🐙🐙 UseCase deinit \(self) 🐙🐙🐙🐙🐙🐙🐙🐙🐙🐙")
    }
}

// MARK: - Input
extension SignInUseCaseImpi {

    func checkNickValidate(str: String) {
        if str.count > 0 && str.count <= 10 {
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
            self.birth = changeStorableDateStr(date: date)
            print(birth)
        } else {
            birthValidation.onNext(false)
            self.birth = nil
        }
    }
    
    func checkEmailValidate(str: String) {
        if validateEmailRegEx(str) {
            emailValidation.onNext(true)
            self.email = str
        } else {
            emailValidation.onNext(false)
            self.email = nil
        }
    }
    
    func checkGenderPick(genderInt: Int) {
        if [0, 1].contains(genderInt) {
            gender = genderInt
            genderValidation.onNext(true)
        } else {
            gender = nil
            genderValidation.onNext(true)
        }
    }
    
    func signUpStart() {
        guard let nickName, let birth, let email, let gender else { return }
        
        apiService.postUser(nick: nickName, birth: birth, email: email, gender: gender) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let statusCode):
                self.signUpResult.onNext(statusCode)
            case .failure(let error as APIError):
                self.signUpResult.onNext(error.rawValue)
            default:
                return
            }
        }
    }
    
    
}

private extension SignInUseCaseImpi {
    
    func validateEmailRegEx(_ string: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return string.range(of: emailRegEx, options: .regularExpression) != nil
    }
    
    func changeStorableDateStr(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: date)
    }
}
