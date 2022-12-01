//
//  UserAPIService.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/12/01.
//

import Foundation

protocol UserAPIService: AnyObject {
    func getUser(completionHandler: @escaping (Result<UserInfo, Error>) -> Void)
    func postUser(nick: String, birth: String, email: String, gender: Int, completionHandler: @escaping (Result<Int, Error>) -> Void)
}
