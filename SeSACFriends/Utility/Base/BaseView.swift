//
//  BaseView.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/07.
//

import UIKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        backgroundColor = Colors.white
    }
    
    func constraints() {
        
    }
    
}
