//
//  CardTitleTableViewCell.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/15.
//

import UIKit

import SnapKit

final class CardTitleTableCell: BaseTableViewCell {
    
    lazy var titleMannerButton: MainButton = {
        let button = MainButton(frame: .zero, buttonMode: .inactive, buttonSize: .h32, hasIcon: false)
        button.setTitle("좋은 매너", for: .normal)
        button.isEnabled = false
        return button
    }()
    
    lazy var titleRightTimeButton: MainButton = {
        let button = MainButton(frame: .zero, buttonMode: .inactive, buttonSize: .h32, hasIcon: false)
        button.setTitle("정확한 시간 약속", for: .normal)
        button.isEnabled = false
        return button
    }()
    
    lazy var titleQuickResponseButton: MainButton = {
        let button = MainButton(frame: .zero, buttonMode: .inactive, buttonSize: .h32, hasIcon: false)
        button.setTitle("빠른 응답", for: .normal)
        button.isEnabled = false
        return button
    }()
    
    lazy var titleKindButton: MainButton = {
        let button = MainButton(frame: .zero, buttonMode: .inactive, buttonSize: .h32, hasIcon: false)
        button.setTitle("친절한 성격", for: .normal)
        button.isEnabled = false
        return button
    }()
    
    lazy var titleSkilfulButton: MainButton = {
        let button = MainButton(frame: .zero, buttonMode: .inactive, buttonSize: .h32, hasIcon: false)
        button.setTitle("능숙한 실력", for: .normal)
        button.isEnabled = false
        return button
    }()
    
    lazy var titleGoodTimeButton: MainButton = {
        let button = MainButton(frame: .zero, buttonMode: .inactive, buttonSize: .h32, hasIcon: false)
        button.setTitle("유익한 시간", for: .normal)
        button.isEnabled = false
        return button
    }()
        
    lazy var reviewMoreButton: UIButton = {
        let button = UIButton()
        button.setImage(Images.moreArrow.image, for: .normal)
        return button
    }()
    
    override func configure() {
        super.configure()
        contentView.addSubViews(views: titleKindButton, titleMannerButton, titleSkilfulButton, titleGoodTimeButton, titleRightTimeButton, titleQuickResponseButton)
    }
    
    override func setConstraints() {
        
        contentView.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width - 32)
        }
        
        titleMannerButton.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(16)
            make.top.equalTo(contentView)
        }
        
        titleRightTimeButton.snp.makeConstraints { make in
            make.trailing.equalTo(contentView).inset(16)
            make.top.equalTo(contentView)
            make.leading.equalTo(titleMannerButton.snp.trailing).offset(8)
            make.width.equalTo(titleMannerButton)
        }
        
        titleQuickResponseButton.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(16)
            make.top.equalTo(titleMannerButton.snp.bottom).offset(8)
            make.width.equalTo(titleMannerButton)

        }
        
        
        titleKindButton.snp.makeConstraints { make in
            make.trailing.equalTo(contentView).inset(16)
            make.top.equalTo(titleRightTimeButton.snp.bottom).offset(8)
            make.leading.equalTo(titleQuickResponseButton.snp.trailing).offset(8)
            make.width.equalTo(titleMannerButton)

        }
        
        
        titleSkilfulButton.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(16)
            make.top.equalTo(titleQuickResponseButton.snp.bottom).offset(8)
            make.width.equalTo(titleMannerButton)
            make.bottom.equalTo(contentView)
        }
        
        
        titleGoodTimeButton.snp.makeConstraints { make in
            make.trailing.equalTo(contentView).inset(16)
            make.top.equalTo(titleKindButton.snp.bottom).offset(8)
            make.leading.equalTo(titleSkilfulButton.snp.trailing).offset(8)
            make.width.equalTo(titleMannerButton)
            make.bottom.equalTo(contentView)
        }
    }
    
    func getButtonList() -> [MainButton] {
        return [titleMannerButton, titleRightTimeButton, titleQuickResponseButton, titleKindButton, titleSkilfulButton, titleGoodTimeButton]
    }
}
