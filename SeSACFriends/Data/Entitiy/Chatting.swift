//
//  Chatting.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/12/01.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let chatting = try? newJSONDecoder().decode(Chatting.self, from: jsonData)

import Foundation

// MARK: - Chatting
struct Chatting: Codable {
    let payload: [Payload]
}

// MARK: - Payload
struct Payload: Codable {
    let id, to, from, chat: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case to, from, chat, createdAt
    }
}
