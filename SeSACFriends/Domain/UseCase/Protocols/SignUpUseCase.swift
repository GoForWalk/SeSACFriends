//
//  SignUpUseCase.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/11.
//

import Foundation
import RxSwift

protocol AuthUseCase {
    var validation: BehaviorSubject<Bool> { get }
    var phoneNumText: BehaviorSubject<String> { get }
    var messageApproved: BehaviorSubject<Bool> { get }
    var messageValidation: BehaviorSubject<Bool> { get }
    var apiconnect: PublishSubject<Int> { get }

    func sendMessage(isResend: Bool)
    func validatePhone(_ string: String)
    func validateMessage(str: String)
    func messageAuthDone()
}
