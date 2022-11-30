//
//  HomeMatchCardListView.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/26.
//

import UIKit

import SnapKit
import Then

final class HomeMatchCardListView: BaseView {

    lazy var collcectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()).then { collectionView in
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsSelection = true
        collectionView.keyboardDismissMode = .interactive
    }
    
    lazy var emptyTitleLabel = UILabel().then {
        $0.setLineHeight(fontInfo: Fonts.display1R20)
        $0.textAlignment = .center
        $0.textColor = Colors.black
    }
    
    lazy var emptySubTitleLabel = UILabel().then { label in
        label.setLineHeight(fontInfo: Fonts.title4R14)
        label.textAlignment = .center
        label.textColor = Colors.gray7
        label.text = "스터디를 변경하거나 조금만 더 기다려 주세요!"
    }
    
    lazy var imageView = UIImageView().then { imageView in
        imageView.image = Images.seed.image
    }
    
    lazy var studyChangebutton = MainButton(frame: .zero, buttonMode: .fill, buttonSize: .h48, hasIcon: false).then { button in
        button.setTitle("스터디 변경하기", for: .normal)
    }
    
    lazy var reloadButton = MainButton(frame: .zero, buttonMode: .outline, buttonSize: .h48, hasIcon: true).then { button in
        button.setImageSize(imageInfo: Images.reset, state: .normal)
        button.setButtonIcon(hasIcon: true, imageColor: Colors.green)
        button.layer.borderColor = Colors.green.cgColor
    }
    
    lazy var stackView = UIStackView(arrangedSubviews: [studyChangebutton, reloadButton]).then { stackView in
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.alignment = .fill
    }

    override func configure() {
        super.configure()
        addSubViews(views: emptyTitleLabel, emptySubTitleLabel, imageView, stackView, collcectionView)
    }

    override func setConstraints() {
        
        collcectionView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        emptyTitleLabel.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
        }
        
        emptySubTitleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(emptyTitleLabel.snp.bottom).offset(8)
        }
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.width.height.equalTo(64)
            make.bottom.equalTo(emptyTitleLabel.snp.top).offset(-44)
        }
        
        stackView.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(48)
        }
        
        reloadButton.snp.makeConstraints { make in
            make.width.equalTo(reloadButton.snp.height)
        }

    }

    func setViewMode(viewMode: ViewMode) {
        let emptyObject = [emptyTitleLabel, emptySubTitleLabel, imageView, stackView]
        switch viewMode {
        case .empty:
            collcectionView.isHidden = true
            emptyObject.forEach {
                $0.isHidden = false
            }
        case .cardList:
            collcectionView.isHidden = false
            emptyObject.forEach {
                $0.isHidden = true
            }
        }
    }
    
    func emptySubtitleText(text: String) {
        emptySubTitleLabel.text = text
    }
    
    enum ViewMode {
        case empty
        case cardList
    }
}
