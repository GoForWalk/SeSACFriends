//
//  UIView+Extension.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/15.
//

import UIKit

extension UIView {
    
    func addSubViews(views: UIView...) {
        views.forEach {
            addSubview($0)
        }
    }
    
}
