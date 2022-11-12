//
//  EmailInputView.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/11.
//

import UIKit

import SnapKit
import TextFieldEffects

final class EmailInputView: BaseView {
    
    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.setLineHeight(fontInfo: Fonts.title2R16)
        label.textColor = Colors.black
        label.text = "이메일을 입력해 주세요"
        return label
    }()
    
    let sublabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.setLineHeight(fontInfo: Fonts.title2R16)
        label.textColor = Colors.gray7
        label.text = "휴대폰 번호 변경 시 인증을 위해 사용해요"
        return label
    }()
    
    let textField: InputTextField = {
        let textField = InputTextField()
        textField.keyboardType = .emailAddress
        textField.placeholder = "SeSAC@email.com"
        textField.font = Fonts.title4R14.font
        return textField
    }()
    
    let authButton: MainButton = {
        let button = MainButton(frame: .zero, buttonMode: .disable, buttonSize: .h48, hasIcon: false)
        button.setTitle("다음", for: .normal)
        return button
    }()
    
    override func configure() {
        super.configure()
        [label, sublabel, textField, authButton].forEach {
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
        
        sublabel.snp.makeConstraints { make in
            make.bottom.equalTo(textField.snp.top).offset(-60)
            make.centerX.equalTo(self)
            make.horizontalEdges.equalTo(self).inset(16)
        }
        
        label.snp.makeConstraints { make in
            make.bottom.equalTo(sublabel.snp.top).offset(-8)
            make.horizontalEdges.equalTo(self).inset(16)
        }
        
        
    }
    
}

