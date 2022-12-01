//
//  QueueSuccessType.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/12/01.
//

import Foundation

//MARK: - QueueStatus 대응 코드
/// SUCCESS 이외에서는 새싹 찾기 불가 -> 스터디 입력화면 유지
@frozen enum QueueSuccessType: Int {
    case studyRequestSuccess = 200
    case over3Report = 201
    case cancelPenalty1Lv = 203
    case cancelPenalty2Lv = 204
    case cancelPenalty3Lv = 205
    
    var successDescription: String {
        switch self {
        case .studyRequestSuccess:
            return "QUEUE SUCCESS"
        case .over3Report:
            return "신고가 누적되어 이용하실 수 없습니다."
        case .cancelPenalty1Lv:
            return "스터디 취소 패널티로, 1분동안 이용하실 수 없습니다."
        case .cancelPenalty2Lv:
            return "스터디 취소 패널티로, 2분동안 이용하실 수 없습니다."
        case .cancelPenalty3Lv:
            return "스터디 취소 패널티로, 3분동안 이용하실 수 없습니다."
        }
    }
}
