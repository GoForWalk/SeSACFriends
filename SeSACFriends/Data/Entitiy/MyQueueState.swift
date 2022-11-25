//
//  MyQueueState.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/26.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let myQueueState = try? newJSONDecoder().decode(MyQueueState.self, from: jsonData)

import Foundation

// MARK: - MyQueueState
struct MyQueueState: Codable {
    let dodged, matched, reviewed: Int
    let matchedNick, matchedUid: String
}

struct MyQueueStateSendable {
    let myQueueState: MyQueueState?
    let statusCode: Int
}
