//
//  MyChatTableViewCell.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/12/01.
//

import UIKit

import SnapKit

final class MyChatTableViewCell: BaseTableViewCell {
    
    let messageLabel: BasePaddingLabel = {
        let label = BasePaddingLabel(padding: UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16))
        label.textColor = Colors.black
        label.setLineHeight(fontInfo: Fonts.body3R14)
        label.numberOfLines = 0
        label.layer.cornerRadius = 8
        label.backgroundColor = Colors.whiteGreen
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
            make.trailing.equalToSuperview()
            make.verticalEdges.equalToSuperview()
            make.leading.greaterThanOrEqualTo(contentView.snp.leading).multipliedBy(0.75)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(messageLabel.snp.bottom)
            make.trailing.equalTo(messageLabel.snp.leading).offset(4)
            
        }
    }
    
    func setMessageText(text: String, time: String?) {
        guard let time else { return }
        timeLabel.text = time
        messageLabel.text = text
    }
    
}
