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
    
    lazy var iconButton: UIButton = {
        let button = UIButton()
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: Images.closeSmall.imageSize), forImageIn: .normal)
        button.setImage(Images.closeSmall.image, for: .normal)
        return button
    }()
    
    private override init(frame: CGRect) {
        buttonSize = .h48
        buttonMode = .inactive
        super.init(frame: frame)
    }
    
    private init (frame: CGRect, buttonMode: MainButtonMode, buttonSize: MainButtonSize, hasIcon: Bool) {
        self.buttonSize = buttonSize
        self.buttonMode = buttonMode
        super.init(frame: frame)
        
        constraints()
        setButtonIcon(hasIcon: hasIcon)
    }
    
    convenience init(buttonMode: MainButtonMode, buttonSize: MainButtonSize) {
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension MainButton {
    func constraints() {
        layer.masksToBounds = true
        layer.cornerRadius = 8
        titleLabel?.font = Fonts.body3R14.0
        
        self.snp.makeConstraints { make in
            make.height.equalTo(buttonSize.rawValue)
        }
    }

    func buttonConfigure(mainbuttonConfig: MainButtonConfig) {
        self.backgroundColor = mainbuttonConfig.background
        layer.borderColor = mainbuttonConfig.borderColor
        layer.borderWidth = mainbuttonConfig.borderWidth
        setTitleColor(mainbuttonConfig.titleColor, for: .normal)
    }
    
    func setButtonIcon(hasIcon: Bool) {
        
        if hasIcon {
            self.addSubview(iconButton)
            
            guard let titleLabel = self.titleLabel else { return }
            
            iconButton.snp.makeConstraints { make in
                make.centerY.equalTo(self)
                make.left.equalTo(titleLabel.snp.right).offset(4)
                make.height.width.equalTo(16)
            }
            
        }
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

