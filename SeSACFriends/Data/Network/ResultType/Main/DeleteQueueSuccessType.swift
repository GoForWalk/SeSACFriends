//
//  DeleteQueueSuccessType.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/12/01.
//

import Foundation

@frozen enum DeleteQueueSuccessType: Int {
    case deleteSuccess = 200
    
    /// 이미 매칭중인 상태 -> 채팅화면으로 이동
    case matchingStatus = 201
    
    var successDescription: String {
        switch self {
        case .matchingStatus:
            return "누군가와 스터디를 함께하기로 약속했어요!"
        default:
            return "NONE DESCRIPTION"
        }
    }
}
