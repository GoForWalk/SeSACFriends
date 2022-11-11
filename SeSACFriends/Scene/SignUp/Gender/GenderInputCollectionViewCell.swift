//
//  GenderInputCollectionViewCell.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/11.
//

import UIKit

import SnapKit

final class GenderCollectionViewCell: BaseCollectionViewCell {
    
    let genderImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    let genderLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.title2R16.font
        label.textColor = Colors.black
        label.textAlignment = .center
        return label
    }()
    
    override func configure() {
        clipsToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = Colors.gray3.cgColor
        self.layer.cornerRadius = 8
        
        [genderLabel, genderImageView].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        genderLabel.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(contentView.snp.bottom).inset(14)
            make.height.equalTo(26)
        }
        
        genderImageView.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.width.height.equalTo(64)
            make.top.equalTo(contentView.snp.top).inset(14)
            make.bottom.equalTo(genderLabel.snp.top).offset(2)
        }
        
    }
    
    func setCell(indexPath: Int) {
        let info = GenderInfo.allCases[indexPath]
        genderLabel.text = info.text
        genderImageView.image = info.image
        
    }
}

