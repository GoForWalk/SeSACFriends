//
//  AuthUseCase.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/11.
//

import Foundation
import RxSwift

protocol SignUpUseCase: UseCase {
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
