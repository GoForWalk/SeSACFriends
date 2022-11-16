//
//  ProfileCardCollectionViewCell.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/15.
//

import UIKit

final class ProfileCardCollectionViewCell: BaseCollectionViewCell {
    
    let profileCard: ProfileCardView = {
        let view = ProfileCardView()
        
        return view
    }()
    
    override func configure() {
        contentView.addSubview(profileCard)
    }
    
    override func setConstraints() {
                
        profileCard.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
            make.width.equalTo(UIScreen.main.bounds.width - 32)
        }
        
    }
    
}
