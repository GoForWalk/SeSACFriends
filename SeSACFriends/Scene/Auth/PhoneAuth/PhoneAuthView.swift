//
//  PhoneAuthView.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/08.
//

import UIKit

import SnapKit
import TextFieldEffects

final class PhoneAuthView: BaseView {
    
    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.setLineHeight(fontInfo: Fonts.display1R20)
        label.text = "새싹 서비스 이용을 위해\n휴대폰 번호를 입력해 주세요"
        return label
    }()
    
    let textField: InputTextField = {
        let textField = InputTextField()
        textField.keyboardType = .phonePad
        textField.placeholder = "휴대폰 번호(-없이 숫자만 입력)"
        return textField
    }()
    
    let authButton: MainButton = {
        let button = MainButton(frame: .zero, buttonMode: .disable, buttonSize: .h48, hasIcon: false)
        button.setTitle("인증 문자 받기", for: .normal)
        return button
    }()
    
    override func configure() {
        super.configure()
        [label, textField, authButton].forEach {
            addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        authButton.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
        }
        
        textField.snp.makeConstraints { make in
            make.bottom.equalTo(authButton.snp.top).offset(-48)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(48)
        }
        
        label.snp.makeConstraints { make in
            make.bottom.equalTo(textField.snp.top).offset(-40)
            make.horizontalEdges.equalTo(self).inset(16)
        }
        
    }
    
}
