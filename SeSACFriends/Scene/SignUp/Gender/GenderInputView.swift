//
//  GenderInputView.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/11.
//

import UIKit

import SnapKit
import TextFieldEffects

final class GenderInputView: BaseView {
    
    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.setLineHeight(fontInfo: Fonts.title2R16)
        label.textColor = Colors.gray7
        label.text = "이메일을 입력해 주세요"
        return label
    }()
    
    let sublabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.setLineHeight(fontInfo: Fonts.display1R20)
        label.text = "휴대폰 번호 변경 시 인증을 위해 사용해요"
        return label
    }()

    let genderPickCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout.init())
        collectionView.isPagingEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    let authButton: MainButton = {
        let button = MainButton(frame: .zero, buttonMode: .disable, buttonSize: .h48, hasIcon: false)
        button.setTitle("다음", for: .normal)
        return button
    }()
    
    override func configure() {
        super.configure()
        [label, genderPickCollectionView, authButton].forEach {
            addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        authButton.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
        }
        
        
//        label.snp.makeConstraints { make in
//            make.bottom.equalTo(textField.snp.top).offset(-40)
//            make.horizontalEdges.equalTo(self).inset(16)
//        }
        
    }
    
}

