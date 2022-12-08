//
//  YourChatTableViewCell.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/12/02.
//

import UIKit

import SnapKit

final class YourChatTableViewCell: BaseTableViewCell {
    
    let messageLabel: BasePaddingLabel = {
        let label = BasePaddingLabel(padding: UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16))
        label.textColor = Colors.black
        label.setLineHeight(fontInfo: Fonts.body3R14)
        label.numberOfLines = 0
        label.layer.cornerRadius = 8
        label.layer.borderWidth = 1
        label.layer.borderColor = Colors.gray4.cgColor
        
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.setLineHeight(fontInfo: Fonts.title6R12)
        label.textColor = Colors.gray6
        return label
    }()
    
    override func configure() {
        super.configure()
        contentView.addSubViews(views: timeLabel, messageLabel)
    }
    
    override func setConstraints() {
        messageLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.verticalEdges.equalToSuperview()
            make.trailing.greaterThanOrEqualTo(contentView.snp.trailing).multipliedBy(0.75)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(messageLabel.snp.bottom)
            make.leading.equalTo(messageLabel.snp.trailing).offset(4)
            
        }
        
    }
    
    func setMessageText(text: String, time: String?) {
        guard let time else { return }
        timeLabel.text = time
        messageLabel.text = text
    }
    
}
