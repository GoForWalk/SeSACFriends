//
//  ChattingEndPoint.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/12/01.
//

import Foundation

@frozen enum ChattingEndPont {
    case postChat(otherID: String)
    case getChatList(otherID: String, lastChatDate: String)
}

extension ChattingEndPont {
    
    var url: String {
        let baseURL = SFURL.baseURL
        switch self {
        case .postChat(let otherID):
            return "\(baseURL)/chat/\(otherID)"
        case .getChatList(let otherID, let lastChatDate):
            return "\(baseURL)/chat/\(otherID)?lastchatDate=\(lastChatDate)"
        }
    }
}
