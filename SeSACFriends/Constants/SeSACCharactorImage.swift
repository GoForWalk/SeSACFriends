//
//  SeSACCharactorImage.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/29.
//

import UIKit

@frozen enum SeSACCharactorImage: Int, CaseIterable {
    case sesacFace1
    case sesacFace2
    case sesacFace3
    case sesacFace4
    case sesacFace5
}

extension SeSACCharactorImage {
    var image: UIImage {
        return UIImage(named: "sesac_face_\(rawValue + 1)")!
    }
}
