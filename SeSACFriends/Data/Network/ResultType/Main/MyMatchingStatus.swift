//
//  MyMatchingStatus.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/12/01.
//

import Foundation

@frozen enum MyMatchingStatus: Int {
    /// 매칭 상태 확인 성공 -> MyQueueState 보내기
    case matchingSuccess = 200
    /// 새싹스터디 찾기를 요청하지 않는 일반상태
    case normalStatus = 201
}
