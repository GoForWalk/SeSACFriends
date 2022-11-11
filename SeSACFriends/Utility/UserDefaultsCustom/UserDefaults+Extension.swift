//
//  UserDefaults+Extension.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/10.
//

import Foundation

extension UserDefaults {
    
    @CustomUserDefault(key: UserDefaultConstant.idToken, defaultValue: nil)
    static var idToken: String?
    
    @CustomUserDefault(key: UserDefaultConstant.fcmToken, defaultValue: nil)
    static var fcmToken: String?
    
    
    static var phoneNum: String?
}
