//
//  StudyRequestSuccessStatusCodeType.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/12/01.
//

import Foundation

@frozen enum StudyRequestSuccessStatusCodeType: Int {
    /// "스터디 요청을 보냈습니다." 토스트 띄우기
    case success = 200
    /// 상대방이 나에게 이미 스터디를 요청할 상황
    case alreadyRequested = 201
    /// 상대방이 새싹 찾기를 중단한 경우
    ///  "상대방이 스터디 찾기를 그만두었습니다." 토스트 띄우기
    case stopRequesting = 202
}

