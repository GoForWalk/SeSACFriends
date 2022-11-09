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
    func sendMessage()
    func validatePhone(_ string: String)
    
}

final class AuthUseCaseImpi: AuthUseCase {
    
    private var phoneNum: String?
    let validation = BehaviorSubject<Bool>(value: false)
    let phoneNumText = BehaviorSubject<String>(value: "")
    let messageApproved = BehaviorSubject<Bool>(value: false)
    
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
        
    func sendMessage() {
        guard let phoneNum else { return }
        print(phoneNum)
        authPhone(phoneNumber: makeSendableString(phoneNum))
    }

    private func makeSendableString(_ string: String) -> String {
        var str = string
        str.removeFirst()
        
        return "+82\(str)"
    }
    
    private func authPhone(phoneNumber: String) {
        Auth.auth().languageCode = "kr"
        Auth.auth().settings?.isAppVerificationDisabledForTesting = true
        
        PhoneAuthProvider.provider()
          .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] verificationID, error in
              guard let self else { return }
              if let error = error {
                print(error.localizedDescription)
                return
              }
              
              print(verificationID)
              UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
              self.messageApproved.onNext(true)
          }
        
    }

}
