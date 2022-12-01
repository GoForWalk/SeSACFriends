//
//  ChattingRealm.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/12/01.
//

import Foundation
import RealmSwift

final class ChattingRealm: Object {
    @Persisted(primaryKey: true) var objectID: ObjectId
    @Persisted var id: String
    @Persisted var to: String
    @Persisted var from: String
    @Persisted var chat: String
    @Persisted(indexed: true) var createdAt: Date
    
    convenience init(
        id: String,
        to: String,
        from: String,
        chat: String,
        createdAt: Date
    ) {
        self.init()
        self.id = id
        self.to = to
        self.from = from
        self.chat = chat
        self.createdAt = createdAt
    }
    
}
