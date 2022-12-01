//
//  ChatDTO.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/12/01.
//

import Foundation

struct ChatDTO {
    let id, to, from, chat: String
    var createdAt: Date
    
    var stringCreatedAt: String? {
        return createdAt.dateToString(format: DateFormat.format)
    }
}
