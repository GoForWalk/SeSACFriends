//
//  ProfileCardView.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/14.
//

import UIKit

import SnapKit

final class ProfileCardView: BaseView {
        
    var widthRatio: CGFloat {
        (UIScreen.main.bounds.width - 32) / 343.0
    }
    
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.background1
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    let charactorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.sesacFace1.image
        return imageView
    }()
    
    let profileView: ProfileCardRollableView = {
        let view = ProfileCardRollableView()
        
        return view
    }()
        
    override func configure() {
        
        [profileView, backgroundImageView, charactorImageView].forEach {
            self.addSubview($0)
        }
        
    }
    
    override func setConstraints() {
                
        backgroundImageView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self)
            make.top.equalTo(self)
            make.bottom.equalTo(profileView.snp.top)
            make.height.equalTo(194 * widthRatio)
        }
        
        charactorImageView.snp.makeConstraints { make in
            make.width.height.equalTo(184 * widthRatio)
            make.top.equalTo(backgroundImageView).inset(19 * widthRatio)
            make.leading.equalTo(backgroundImageView).inset(75 * widthRatio)
        }
        
        profileView.snp.makeConstraints { make in
            make.top.equalTo(backgroundImageView.snp.bottom)
            make.horizontalEdges.equalTo(self)
            make.bottom.equalTo(self)
        }
    }
    
    
}
