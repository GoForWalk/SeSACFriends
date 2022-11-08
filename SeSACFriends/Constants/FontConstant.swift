//
//  FontConstant.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/07.
//

import UIKit

// 폰트,
typealias FontsInfo = (font: UIFont, fontSize: CGFloat)

@frozen enum Fonts {
    
    private static let notoSansKR_Regular: String = "NotoSansKR-Regular"
    private static let notoSansKR_Medium: String = "NotoSansKR-Medium"

    static let display1R20: FontsInfo = (UIFont(name: notoSansKR_Regular, size: 20)!, 1.6)
    
    // Title
    static let title1M16: FontsInfo = (UIFont(name: notoSansKR_Medium, size: 16)!, 1.6)
    static let title2R16: FontsInfo = (UIFont(name: notoSansKR_Regular, size: 16)!, 1.6)
    static let title3M14: FontsInfo = (UIFont(name: notoSansKR_Medium, size: 14)!, 1.6)
    static let title4R14: FontsInfo = (UIFont(name: notoSansKR_Regular, size: 14)!, 1.6)
    static let title5M12: FontsInfo = (UIFont(name: notoSansKR_Medium, size: 12)!, 1.5)
    static let title6R12: FontsInfo = (UIFont(name: notoSansKR_Regular, size: 12)!, 1.5)
    
    // Body
    static let body1M16: FontsInfo = (UIFont(name: notoSansKR_Medium, size: 16)!, 1.85)
    static let body2R16: FontsInfo = (UIFont(name: notoSansKR_Regular, size: 16)!, 1.85)
    static let body3R14: FontsInfo = (UIFont(name: notoSansKR_Regular, size: 14)!, 1.7)
    static let body4R12: FontsInfo = (UIFont(name: notoSansKR_Regular, size: 12)!, 1.8)
    
    static let captionR10: FontsInfo = (UIFont(name: notoSansKR_Regular, size: 10)!, 1.6)
}

