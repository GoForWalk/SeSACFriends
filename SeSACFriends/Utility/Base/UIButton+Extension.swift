//
//  UIButton+Extension.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/07.
//

import UIKit

extension UIButton {
    
    func setImageSize(imageInfo: ImageInfo, state: UIControl.State) {
        self.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: imageInfo.imageSize), forImageIn: state)
        self.setImage(imageInfo.image, for: state)
    }
    
}
