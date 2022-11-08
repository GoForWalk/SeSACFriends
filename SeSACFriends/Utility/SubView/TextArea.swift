//
//  textField.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/07.
//

import UIKit
import SnapKit

final class TextArea: UITextField {
    
    private var placehoderText = "메세지를 입력하세요"
    
    private var button: UIButton = {
        let button = UIButton()
        button.setImage(Images.sendActive, for: .normal)
        button.setImage(Images.sendInactive, for: .disabled)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 20), forImageIn: .normal)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 20), forImageIn: .disabled)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        inactive()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPlaceholderText(text: String) {
        placehoderText = text
        
    }
        
    func inactive() {
        button.isHidden = true
        setPlaceholder(placeholderColor: Colors.gray7)
    }
    
    func active() {
        button.isHidden = true
        setPlaceholder(placeholderColor: Colors.black)
    }
    
    func inactiveIcon() {
        button.isHidden = false
        button.isEnabled = false
        setPlaceholder(placeholderColor: Colors.gray7)
    }
    
    func activeIcon() {
        button.isHidden = false
        button.isEnabled = true
        setPlaceholder(placeholderColor: Colors.black)
    }
    
}

private extension TextArea {
    
    func configure() {
        backgroundColor = Colors.gray1
        font = Fonts.body3R14.0
        self.addSubview(button)
        
        button.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.right.equalTo(self).inset(14)
            make.height.width.equalTo(20)
        }
    }
    
    func setPlaceholder(placeholderColor: UIColor) {
        self.attributedPlaceholder = NSAttributedString(string: placehoderText, attributes: [
            .font: Fonts.body3R14.0,
            .foregroundColor: placeholderColor
        ])
    }
    
}
