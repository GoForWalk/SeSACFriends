//
//  StudyAcceptStatusCodeType.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/12/01.
//

import Foundation

@frozen enum StudyAcceptStatusCodeType: Int {
    /// 수락 성공 - 채팅화면으로 이동
    case success = 200
    /// 상대방이 이미 다른 사용자와 매칭된 상태
    case otherAlreadyMatched = 201
    /// 상대방이 새싹 찾기를 중단한 상태
    case stopRequesting = 202
    /// 내가 이미 다른 사용자와 매칭된 상태
    case myMatchingDone = 203
}
