//
//  TextView+Extension.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/15.
//

import UIKit

extension UITextView {
    func setLineHeight(fontInfo: FontsInfo) {
        
        let style = NSMutableParagraphStyle()
        let lineHeight = fontInfo.0.pointSize * fontInfo.1
        
        style.minimumLineHeight = lineHeight
        style.maximumLineHeight = lineHeight
        
        self.attributedText = NSAttributedString(string: text ?? "", attributes: [
            .paragraphStyle: style,
            .baselineOffset: (lineHeight - fontInfo.0.pointSize) / 4 // text 중앙정렬
                
        ])
        
        self.font = fontInfo.0
    }

}
