//
//  NickInputView.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/11.
//

import UIKit

import SnapKit
import TextFieldEffects

final class NickInputView: BaseView {
    
    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.setLineHeight(fontInfo: Fonts.display1R20)
        label.text = "닉네임을 입력해주세요."
        return label
    }()
    
    let textField: InputTextField = {
        let textField = InputTextField()
        textField.keyboardType = .phonePad
        textField.placeholder = "10자 이내로 입력"
        return textField
    }()
    
    let authButton: MainButton = {
        let button = MainButton(frame: .zero, buttonMode: .disable, buttonSize: .h48, hasIcon: false)
        button.setTitle("다음", for: .normal)
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
