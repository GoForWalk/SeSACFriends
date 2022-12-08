//
//  BasePaddingLabel.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/12/08.
//

import UIKit

class BasePaddingLabel: UILabel {
    private var padding = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
    
    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        
        return contentSize
    }
    
}
