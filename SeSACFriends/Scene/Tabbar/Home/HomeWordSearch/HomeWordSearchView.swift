//
//  HomeWordSearchView.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/21.
//

import UIKit

import SnapKit

final class HomeWordSearchView: BaseView {
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [backButton, searchBar])
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "띄어쓰기로 복수 입력이 가능해요."
        return searchBar
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImageSize(imageInfo: Images.arrow, state: .normal)
        return button
    }()
    
    lazy var searchButton: MainButton = {
        let button = MainButton(frame: .zero, buttonMode: .fill, buttonSize: .h48, hasIcon: false)
        
        return button
    }()
    
    override func configure() {
        super.configure()
        addSubViews(views: collectionView, stackView, searchBar, backButton, searchButton)
    }
    
    override func setConstraints() {
        stackView.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(self.safeAreaLayoutGuide)
        }
        
        backButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
        }
        
        searchBar.snp.makeConstraints { make in
            make.leading.equalTo(backButton.snp.trailing).offset(8)
            make.trailing.equalTo(stackView.snp.trailing)
            make.verticalEdges.equalTo(stackView)
        }
        
        searchButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(self).inset(16)
        }
        
    }
        
}
