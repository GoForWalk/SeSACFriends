//
//  SearchUserDTO.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/17.
//

import Foundation

struct SearchUserDTO {
    let searchingType: SearchingType
    let uid, nick: String
    let lat, long: Double
    let reputation: [Int]
    let studylist, reviews: [String]
    let gender, type, sesac, background: Int
}

/// 지도에서 새싹을 표시하는 DTO
struct MapAnnotionUserDTO {
    let lat, long: Double
    let gender, type, sesac: Int
}

/// 검색어를 받아오는 DTO
struct MapSearchWordDTO {
    let nearByWord: [String]
    let recommandWord: [String]
}

/// Card 구성하는 DTO
struct SearchCardDataDTO {
    let uid: String
    let nick: String
    let reputation: [Int]
    let studyList: [String]
    let reviews: [String]
    let sesac, background: Int
}

/// NearUser&& requestedUser Card DTO
struct SearchCardDatasDTO {
    let nearByUserCards: [SearchCardDataDTO]
    let requestUserCards: [SearchCardDataDTO]
}

enum SearchingType {
    /// 내가 요청 보내기
    case request
    /// 내가 받은 요청
    case response
}
