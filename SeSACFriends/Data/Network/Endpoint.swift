//
//  Endpoint.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/10.
//

import Foundation

enum Endpoint {
    
    case postUser
    case getUser
    case search
}

extension Endpoint {
    
    var url: String {
        let testBaseURL = "http://api.sesac.co.kr:1210"
        switch self {
        case .postUser:
            return "\(testBaseURL)/v1/user"
        case .getUser:
            return "\(testBaseURL)/v1/user"
        case .search:
            return "\(testBaseURL)/v1/queue/search"
        }
    }
    
}
