//
//  BackGroundImage.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/29.
//

import UIKit

@frozen enum SeSACBackgoundImage: Int, CaseIterable {
    case background1
    case background2
    case background3
    case background4
    case background5
    case background6
    case background7
    case background8
    case background9
}

extension SeSACBackgoundImage {
    var image: UIImage {
        return UIImage(named: "sesac_background_\(rawValue + 1)")!
    }
}

