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

    override func configure() {
        super.configure()
        addSubview(collcectionView)
    }

    override func setConstraints() {
        collcectionView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }

}
