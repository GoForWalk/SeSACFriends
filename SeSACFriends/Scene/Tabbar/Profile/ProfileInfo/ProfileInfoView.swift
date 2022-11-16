//
//  ProfileInfoView.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/14.
//

import UIKit

import SnapKit

final class ProfileInfoView: BaseView {
    
    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 300, height: 300), collectionViewLayout: UICollectionViewLayout.init())
        collectionView.backgroundColor = Colors.white
        return collectionView
    }()
    
    override func configure() {
        super.configure()
        addSubview(collectionView)
    }
    
    override func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(self.safeAreaLayoutGuide)
            make.width.equalTo(UIScreen.main.bounds.width - 32)
            make.centerX.equalToSuperview()
        }
    }
    
}
