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
        label.setLineHeight(fontInfo: Fonts.display1R20)
        label.textColor = Colors.black
        label.text = "성별을 선택해 주세요"
        return label
    }()
    
    let sublabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.setLineHeight(fontInfo: Fonts.title2R16)
        label.textColor = Colors.gray7
        label.text = "새싹 찾기 기능을 이용하기 위해서 필요해요!"
        return label
    }()

    lazy var genderPickCollectionView: UICollectionView = {
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
        [label, sublabel, genderPickCollectionView, authButton].forEach {
            addSubview($0)
        }
    }
    
    override func setConstraints() {
        authButton.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
        }
        
        genderPickCollectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self)
            make.bottom.equalTo(authButton.snp.top).offset(-32)
            make.height.equalTo(166)
        }
        
        sublabel.snp.makeConstraints { make in
            make.bottom.equalTo(genderPickCollectionView.snp.top).offset(-32)
            make.horizontalEdges.equalTo(self).inset(16)
        }
        
        label.snp.makeConstraints { make in
            make.bottom.equalTo(sublabel.snp.top).offset(-8)
            make.horizontalEdges.equalTo(self).inset(16)
        }
        
    }
    
}

