//
//  OnboardingView.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/08.
//

import UIKit
import SnapKit

final class OnBoardingView: BaseView {
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = Colors.gray5
        pageControl.currentPageIndicatorTintColor = Colors.black
        return pageControl
    }()
    
    let startButton: MainButton = {
        let mainButton = MainButton(frame: .zero, buttonMode: .fill, buttonSize: .h48, hasIcon: false)
        mainButton.setTitle("시작하기", for: .normal)
        
        return mainButton
    }()
    
    override func configure() {
        super.configure()
        
        [collectionView, startButton, pageControl].forEach {
            addSubview($0)
        }
        
    }
    
    override func setConstraints() {
        startButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(16)
        }
        
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalTo(startButton.snp.top).offset(-16)
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.bottom.equalTo(collectionView.snp.bottom).inset(16)
            make.horizontalEdges.equalTo(collectionView.snp.horizontalEdges)
            make.height.equalTo(16)
        }
    }
    
}
