//
//  SearchUser.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/17.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let searchUser = try? newJSONDecoder().decode(SearchUser.self, from: jsonData)

import Foundation

// MARK: - SearchUser
struct SearchUser: Codable {
    let fromQueueDB, fromQueueDBRequested: [FromQueueDB]
    let fromRecommend: [String]
}

// MARK: - FromQueueDB
struct FromQueueDB: Codable {
    let uid, nick: String
    let lat, long: Double
    let reputation: [Int]
    let studylist, reviews: [String]
    let gender, type, sesac, background: Int
}
