//
//  TagCollectionViewCell.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/21.
//

import UIKit

import SnapKit

final class TagCollectionViewCell: BaseCollectionViewCell {
    
    lazy var textButton: MainButton = {
        let button = MainButton(frame: .zero, buttonMode: .outline, buttonSize: .h32, hasIcon: true)
        return button
    }()
    
    override func configure() {
        super.configure()
        contentView.addSubview(textButton)
    }
    
    override func setConstraints() {
        textButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.horizontalEdges.lessThanOrEqualTo(UIScreen.main.bounds.width - 32)
        }
    }
    
    func configureButton(buttonTitle: String, sectionType: ButtonSectionStyle) {
        
        let config = sectionType.buttonConfig
        textButton.setTitle(buttonTitle, for: .normal)
        textButton.tintColor = config.buttonColor
        textButton.layer.borderColor = config.buttonBoaderColor
        textButton.iconButton.isHidden = config.buttonMark
        textButton.titleEdgeInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
    }
    
}

@frozen enum ButtonSectionStyle: Int, CaseIterable {
    case recommand
    case nearUser
    case myTag
}

extension ButtonSectionStyle {
    var buttonConfig: TagButtonConfig {
        switch self {
        case .recommand:
            return TagButtonConfig(
                buttonColor: Colors.error,
                buttonBoaderColor: Colors.error.cgColor,
                buttonMark: true)
            
        case .nearUser:
            return TagButtonConfig(
                buttonColor: Colors.black,
                buttonBoaderColor: Colors.gray4.cgColor,
                buttonMark: true)

        case .myTag:
            return TagButtonConfig(
                buttonColor: Colors.green,
                buttonBoaderColor: Colors.green.cgColor,
                buttonMark: false)
        }
    }
}

struct TagButtonConfig {
    let buttonColor: UIColor
    let buttonBoaderColor: CGColor
    let buttonMark: Bool
}
