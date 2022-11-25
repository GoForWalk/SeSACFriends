//
//  MainButton.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/07.
//

import UIKit

import SnapKit

final class MainButton: UIButton {
    
    let buttonSize: MainButtonSize
    
    var buttonMode: MainButtonMode {
        didSet {
            buttonConfigure(mainbuttonConfig: buttonMode.buttonConfig)
        }
    }
    
    private override init(frame: CGRect) {
        buttonSize = .h48
        buttonMode = .inactive
        super.init(frame: frame)
    }
    
    init(frame: CGRect, buttonMode: MainButtonMode, buttonSize: MainButtonSize, hasIcon: Bool, imageColor: UIColor? = nil) {
        self.buttonSize = buttonSize
        self.buttonMode = buttonMode
        super.init(frame: frame)
        
        constraints()
        setButtonIcon(hasIcon: hasIcon, imageColor: imageColor)
        buttonConfigure(mainbuttonConfig: buttonMode.buttonConfig)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setButtonIcon(hasIcon: Bool, imageColor: UIColor?) {
        
        if hasIcon {
            let temp = Images.closeSmall.image
            setImage(temp.maskWithColor(color: imageColor ?? .black), for: .normal)
        }
    }

}

private extension MainButton {
    func constraints() {
        layer.masksToBounds = true
        layer.cornerRadius = 8
        titleLabel?.font = Fonts.body3R14.0
        semanticContentAttribute = .forceRightToLeft
        
        self.snp.makeConstraints { make in
            make.height.equalTo(buttonSize.rawValue)
        }
    }

    func buttonConfigure(mainbuttonConfig: MainButtonConfig) {
        backgroundColor = mainbuttonConfig.background
        layer.borderColor = mainbuttonConfig.borderColor
        layer.borderWidth = mainbuttonConfig.borderWidth
        setTitleColor(mainbuttonConfig.titleColor, for: .normal)
    }
    
}

@frozen enum MainButtonMode {
    
    case inactive
    case fill
    case outline
    case cancel
    case disable
    
}

extension MainButtonMode {
    
    var buttonConfig: MainButtonConfig {
        switch self {
        case .inactive:
            return MainButtonConfig(
                background: Colors.white,
                borderColor: Colors.gray4.cgColor,
                borderWidth: 1,
                titleColor: Colors.black)
        case .fill:
            return MainButtonConfig(
                background: Colors.green,
                borderColor: Colors.white.cgColor,
                borderWidth: 0,
                titleColor: Colors.white)
        case .outline:
            return MainButtonConfig(
                background: Colors.white,
                borderColor: Colors.green.cgColor,
                borderWidth: 1,
                titleColor: Colors.green)
        case .cancel:
            return MainButtonConfig(
                background: Colors.gray2,
                borderColor: Colors.white.cgColor,
                borderWidth: 0,
                titleColor: Colors.black)
        case .disable:
            return MainButtonConfig(
                background: Colors.gray6,
                borderColor: Colors.white.cgColor,
                borderWidth: 0,
                titleColor: Colors.white)
        }
    }
}

@frozen enum MainButtonSize: Int {
    
    case h48 = 48
    case h40 = 40
    case h32 = 32
}

struct MainButtonConfig {
    let background: UIColor
    let borderColor: CGColor
    let borderWidth: CGFloat
    let titleColor: UIColor
}

