//
//  CardReviewTableViewCell.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/15.
//

import UIKit

import SnapKit

final class CardReviewTableViewCell: BaseTableViewCell {
    
    lazy var reviewTextView: UITextView = {
        let textView = UITextView()
        textView.setLineHeight(fontInfo: Fonts.body3R14)
        textView.textColor = Colors.gray6
        textView.text = "첫 리뷰를 기다리는 중이에요!"
        return textView
    }()
    
    override func configure() {
        super.configure()
        contentView.addSubview(reviewTextView)
    }
    
    override func setConstraints() {
        
        reviewTextView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView).inset(16)
            make.verticalEdges.equalTo(contentView)
//            make.width.equalTo(con)
            make.height.equalTo(30)
        }
    }
    
    func setReviewText(text: String) {
        if text.isEmpty {
            reviewTextView.textColor = Colors.gray6
            reviewTextView.text = "첫 리뷰를 기다리는 중이에요!"
        } else {
            reviewTextView.textColor = Colors.black
            reviewTextView.text = text
        }
    }
    
}
