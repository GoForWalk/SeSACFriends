//
//  MessageAuthView.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/08.
//

import UIKit

import SnapKit

final class MessageAuthView: BaseView {
    
    let authButton: MainButton = {
        let button = MainButton(frame: .zero, buttonMode: .disable, buttonSize: .h48, hasIcon: false)
        button.setTitle("인증하고 시작하기", for: .normal)
        return button
    }()

    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.setLineHeight(fontInfo: Fonts.display1R20)
        label.text = "인증번호가 문자로 전송되었어요."
        return label
    }()
    
    let resendButton: MainButton = {
        let button = MainButton(frame: .zero, buttonMode: .fill, buttonSize: .h40, hasIcon: false)
        button.setTitle("재전송", for: .normal)
        return button
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.green
        label.setLineHeight(fontInfo: Fonts.title3M14)
        label.text = "05:00"
        return label
    }()
    
    let textField: InputTextField = {
        let textField = InputTextField()
        textField.keyboardType = .numberPad
        textField.placeholder = "인증번호 입력"
        return textField
    }()

    override func configure() {
        super.configure()
        [authButton, label, resendButton, textField].forEach {
            addSubview($0)
        }
        
        textField.addSubview(timeLabel)
    }
    
    override func setConstraints() {
        
        authButton.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
        }
        
        resendButton.snp.makeConstraints { make in
            make.width.equalTo(72)
            make.right.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(authButton.snp.top).offset(-48)
        }
        
        textField.snp.makeConstraints { make in
            make.centerY.equalTo(resendButton)
            make.left.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(48)
            make.right.equalTo(resendButton.snp.left).offset(8)
        }
        
        label.snp.makeConstraints { make in
            make.bottom.equalTo(textField.snp.top).offset(-40)
            make.horizontalEdges.equalTo(self).inset(16)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
            make.width.equalTo(40)
        }
        
    }

}
