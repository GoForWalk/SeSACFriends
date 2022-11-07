//
//  InputTextField.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/07.
//

import UIKit
import TextFieldEffects

final class InputTextField: HoshiTextField {
    
    override var isEnabled: Bool {
        didSet {
            switch isEnabled {
            case true: abled()
            case false: disabled()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func focusAndActive() {
        textColor = Colors.black
    }

}

private extension InputTextField {
    
    func configure() {
        borderActiveColor = Colors.focus
        borderInactiveColor = Colors.gray3
        backgroundColor = Colors.white
        textColor = Colors.gray7
        placeholder = "내용을 입력"
        font = Fonts.title4R14.0
    }
    
    private func disabled() {
        placeholderColor = Colors.gray7
        backgroundColor = Colors.gray3
    }
    
    private func abled() {
        backgroundColor = Colors.white
    }
        
}
