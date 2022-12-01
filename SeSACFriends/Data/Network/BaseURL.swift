//
//  BaseURL.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/12/01.
//

import Foundation

struct SFURL {
    
    private static var foundationURL: String {
        #if DEBUG
        return "http://api.sesac.co.kr:1210"
        #else
        return ""
        #endif
    }
    
    private static let version = "/v1"
    
    static let baseURL = "\(foundationURL)\(version)"
}
