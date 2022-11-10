//
//  AuthUseCase.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/08.
//

import Foundation

import RxSwift
import FirebaseAuth

protocol AuthUseCase {
    var validation: BehaviorSubject<Bool> { get }
    var phoneNumText: BehaviorSubject<String> { get }
    var messageApproved: BehaviorSubject<Bool> { get }
    var messageValidation: BehaviorSubject<Bool> { get }
    
    func sendMessage(isResend: Bool)
    func validatePhone(_ string: String)
    func validateMessage(str: String)
    func messageAuthDone()
}

final class AuthUseCaseImpi: AuthUseCase {
    
    private var phoneNum: String?
    private var authVerificationID: String?
    private var messageCode: String?
    // MARK: - PHONE AUTH PROPERTYS
    let validation = BehaviorSubject<Bool>(value: false)
    let phoneNumText = BehaviorSubject<String>(value: "")
    let messageApproved = BehaviorSubject<Bool>(value: false)
    
    // MARK: - MESSAGE AUTH PROPERTYS
    let messageValidation = BehaviorSubject(value: false)
    
    deinit {
        print("🐙🐙🐙🐙🐙🐙🐙 UseCase \(self) 🐙🐙🐙🐙🐙🐙🐙🐙🐙🐙")
    }
    
    func validatePhone(_ string: String) {
        phoneNumText.onNext(string)
        let regex = "^01[0-1, 7]\\-[0-9]{3,4}\\-[0-9]{4}$"
        let result = string.range(of: regex, options: .regularExpression) != nil
        self.validation.onNext(result)
        print(result)
        if result {
            print(string)
            phoneNum = string
        }
    }
        
    func sendMessage(isResend: Bool) {
        guard let phoneNum else { return }
        print(phoneNum)
        authPhone(phoneNumber: makeSendableString(phoneNum), isResend: isResend)
    }

    func validateMessage(str: String) {
        let bool = validateMessageText(str: str)
        messageValidation.onNext(bool)
        if bool { self.messageCode = str }
    }
    
    func messageAuthDone() {
        guard let authVerificationID, let messageCode else {
            print(#function, "error")
            return }
        
        authMessage(verificationID: authVerificationID, verificationCode: messageCode)
    }
    
}

private extension AuthUseCaseImpi {
    
    func validateMessageText(str: String) -> Bool {
        return str.count == 6
    }

    func makeSendableString(_ string: String) -> String {
        var str = string
        str.removeFirst()
        
        return "+82\(str)"
    }
    
    func authPhone(phoneNumber: String, isResend: Bool) {
        Auth.auth().languageCode = "kr"
        Auth.auth().settings?.isAppVerificationDisabledForTesting = true
        
        PhoneAuthProvider.provider()
          .verifyPhoneNumber(phoneNumber, uiDelegate: nil) {[weak self] verificationID, error in
              guard let self else { return }
              if let error = error {
                print(error.localizedDescription)
                return
              }
              
              print(verificationID)
              self.authVerificationID = verificationID
              if !isResend {
                  self.messageApproved.onNext(true)
              }
          }
    }

    func authMessage(verificationID: String, verificationCode: String) {
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verificationCode
        )
        
        print(credential)
        Auth.auth().signIn(with: credential) {[weak self] authResult, error in
            if let error {
                print(#function, " authMessageError: \(error)")
                return
            }
            guard let authResult else {
                print(#function, " no authResult: 재시도 요청")
                return
            }
            
            print("authResult: \(authResult.user)")
            
            self?.getUserToken()
        }
        
    }//: authMessage
    
    func getUserToken() {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if let error = error {
                // Handle error
                print(#function, "error: \(error)")
                return
            }
            
            guard let idToken else {
                print(#function, " have in IDToken")
                return
            }
            
            print("✅✅✅ idToken: \(idToken)")
            UserDefaults.idToken = idToken
        }
    }
}
