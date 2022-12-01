//
//  Endpoint.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/10.
//

import Foundation



enum UserEndpoint {
    
    case postUser
    case getUser
}

extension UserEndpoint {
    
    var url: String {
        let baseURL = SFURL.baseURL
        switch self {
        case .postUser:
            return "\(baseURL)/v1/user"
        case .getUser:
            return "\(baseURL)/v1/user"
        }
    }
    
}
