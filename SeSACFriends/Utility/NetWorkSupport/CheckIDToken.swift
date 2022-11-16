//
//  CheckIDToken.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/11.
//

import Foundation
import FirebaseAuth

protocol CheckAndRefreshIDToken: AnyObject where Self: UseCase{
    
}

extension CheckAndRefreshIDToken {
    
    private func refreshToken(task: @escaping () -> Void) {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            
            if let error = error {
                print(#function, "error: \(error)")
                return
            }
            
            guard let idToken else {
                print(#function, " have no IDToken")
                return
            }
            
            print("✅✅✅refresh idToken: \(idToken)")
            UserDefaults.idToken = idToken
            task()
        }
    }
    
    @discardableResult
    func checkRefreshToken(errorCode: Int, tokenErrorNumber: Int = 401, task: @escaping () -> Void) -> Int {
        if errorCode == tokenErrorNumber {
            print("😡😡😡ID Token Refresh Request")
            refreshToken(task: task)
        }
        return errorCode
        
    }
}

