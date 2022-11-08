//
//  BaseCollectionViewCell.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/08.
//

import UIKit


class BaseCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        contentView.backgroundColor = Colors.white
    }
    
    func setConstraints() {
        
    }
    
}
