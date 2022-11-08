//
//  PhoneAuthViewController.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/08.
//

import UIKit

import RxCocoa
import RxSwift
import FirebaseAuth

class PhoneAuthViewController: BaseViewController {

    // +82 10-8989-9999  , 123123
    let phoneNumber = "+821089899999"
    let verificationID = "123123"
    
    let mainView = PhoneAuthView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authPhone()
    }
    
    private func authPhone() {
        
        Auth.auth().languageCode = "kr"
        Auth.auth().settings?.isAppVerificationDisabledForTesting = true
        PhoneAuthProvider.provider()
          .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
              if let error = error {
//                self.showMessagePrompt(error.localizedDescription)
                return
              }
              
              print(verificationID)
          }
        
    }
    
}
