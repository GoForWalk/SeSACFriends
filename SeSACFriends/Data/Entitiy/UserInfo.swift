//
//  UserInfo.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/10.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let user = try? newJSONDecoder().decode(User.self, from: jsonData)

import Foundation

// MARK: - User
struct UserInfo: Codable {
    let id: String
    let v: Int
    let uid, phoneNumber, email, fcMtoken: String
    let nick, birth: String
    let gender: Int
    let study: String
    let comment: [String]
    let reputation: [Int]
    let sesac: Int
    let sesacCollection: [Int]
    let background: Int
    let backgroundCollection: [Int]
    let purchaseToken, transactionID, reviewedBefore: [String]
    let reportedNum: Int
    let reportedUser: [String]
    let dodgepenalty, dodgeNum, ageMin, ageMax: Int
    let searchable: Int
    let createdAt: String

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.v = try container.decode(Int.self, forKey: .v)
        self.uid = try container.decode(String.self, forKey: .uid)
        self.phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
        self.email = try container.decode(String.self, forKey: .email)
        self.fcMtoken = try container.decode(String.self, forKey: .fcMtoken)
        self.nick = try container.decode(String.self, forKey: .nick)
        self.birth = try container.decode(String.self, forKey: .birth)
        self.gender = try container.decode(Int.self, forKey: .gender)
        self.study = try container.decode(String.self, forKey: .study)
        self.comment = try container.decode([String].self, forKey: .comment)
        self.reputation = try container.decode([Int].self, forKey: .reputation)
        self.sesac = try container.decode(Int.self, forKey: .sesac)
        self.sesacCollection = try container.decode([Int].self, forKey: .sesacCollection)
        self.background = try container.decode(Int.self, forKey: .background)
        self.backgroundCollection = try container.decode([Int].self, forKey: .backgroundCollection)
        self.purchaseToken = try container.decode([String].self, forKey: .purchaseToken)
        self.transactionID = try container.decode([String].self, forKey: .transactionID)
        self.reviewedBefore = try container.decode([String].self, forKey: .reviewedBefore)
        self.reportedNum = try container.decode(Int.self, forKey: .reportedNum)
        self.reportedUser = try container.decode([String].self, forKey: .reportedUser)
        self.dodgepenalty = try container.decode(Int.self, forKey: .dodgepenalty)
        self.dodgeNum = try container.decode(Int.self, forKey: .dodgeNum)
        self.ageMin = try container.decode(Int.self, forKey: .ageMin)
        self.ageMax = try container.decode(Int.self, forKey: .ageMax)
        self.searchable = try container.decode(Int.self, forKey: .searchable)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case v = "__v"
        case uid, phoneNumber, email
        case fcMtoken = "FCMtoken"
        case nick, birth, gender, study, comment, reputation, sesac, sesacCollection, background, backgroundCollection, purchaseToken
        case transactionID = "transactionId"
        case reviewedBefore, reportedNum, reportedUser, dodgepenalty, dodgeNum, ageMin, ageMax, searchable, createdAt
    }
    
}

