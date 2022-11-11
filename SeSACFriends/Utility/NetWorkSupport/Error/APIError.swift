//
//  UserGetError.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/10.
//

import Foundation

enum APIError: Int, Error {
    
    case joinedUser = 201
    case bannedNickname = 202
    case firebaseTokenError = 401
    case notUser = 406
    case serverError = 500
    case clientError = 501
    
}

extension APIError {
    
    var errorDescription: String {
        switch self {
        case .joinedUser:
            return "이미 가입한 아이디입니다."
        case .bannedNickname:
            return "사용 금지된 닉네임 입니다."
        case .firebaseTokenError:
            return "firebase Token Error"
        case .notUser:
            return "가입된 유저가 압니다."
        case .serverError:
            return "Server Error"
        case .clientError:
            return "client Error"
        }
    }
    
}
