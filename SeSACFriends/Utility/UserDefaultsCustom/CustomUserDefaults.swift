//
//  CustomUserDefaults.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/10.
//

import Foundation

@propertyWrapper
struct CustomUserDefault<Value> {
    
    let key: String
    let defaultValue: Value
    var container: UserDefaults = .standard
    
    var wrappedValue: Value {
        get {
            return container.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            container.set(newValue, forKey: key)
        }
    }
}
