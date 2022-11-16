//
//  InfoTableViewCell.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/14.
//

import UIKit

import SnapKit

final class ProfileInfoTableCell: BaseTableViewCell {
    
    let profileImage: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
        imageView.layer.borderWidth = 1
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = Colors.gray2.cgColor
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let profileLabel: UILabel = {
        let label = UILabel()
        label.setLineHeight(fontInfo: Fonts.title1M16)
        return label
    }()
    
    let crossButton: UIImageView = {
        let imageView = UIImageView()
        imageView.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: Images.moreArrow.imageSize)
        imageView.image = Images.moreArrow.image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func configure() {
        super.configure()
        selectionStyle = .none
        [profileImage, profileLabel, crossButton].forEach {
            contentView.addSubview($0)
        }
        
    }
    
    override func setConstraints() {
                
        profileImage.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.width.height.equalTo(48)
            make.leading.equalTo(contentView).inset(16)
        }
        
        profileLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(profileImage.snp.trailing).offset(12)
        }
        
        crossButton.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.width.height.equalTo(16)
            make.trailing.equalTo(contentView).inset(16)
        }
        
    }
    
    func configureCell(name: String, image: UIImage) {
        profileImage.image = image
        profileLabel.text = name
    }
    
}

