//
//  MainEndpoint.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/12/01.
//

import Foundation

@frozen enum MainEndpoint {
    
    case search
    case queue
    case myQueueState
    case studyRequest
    case studyAccept
}

extension MainEndpoint {
    
    var url: String {
        let baseURL = SFURL.baseURL
        switch self {
        case .search:
            return "\(baseURL)/queue/search"
        case .queue:
            return "\(baseURL)/queue"
        case .myQueueState:
            return "\(baseURL)/queue/myQueueState"
        case .studyRequest:
            return "\(baseURL)/queue/studyrequest"
        case .studyAccept:
            return "\(baseURL)/queue/studyaccept"
        }
    }
}
