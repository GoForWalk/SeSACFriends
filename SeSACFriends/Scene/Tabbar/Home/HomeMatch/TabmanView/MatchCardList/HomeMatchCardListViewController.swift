//
//  HomeMatchCardListViewController.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/26.
//
import UIKit

import RxSwift
import RxCocoa

final class HomeMatchCardListViewController: BaseViewController {
    
    private let mainView = HomeMatchCardListView()
    private let viewModel: HomeMatchCardListViewModel
    private var tabSection: TabSection
    private var cardData: [SearchCardDataDTO]
    private let disposeBag = DisposeBag()
    
    init(viewModel: HomeMatchCardListViewModel, tabSection: TabSection, cardData: [SearchCardDataDTO]) {
        self.viewModel = viewModel
        self.tabSection = tabSection
        self.cardData = cardData
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configure() {
        setCollectionView()
    }
    
    override func bind() {
        let input = HomeMatchCardListViewModel.Input()
        
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
    
    }
}

private extension HomeMatchCardListViewController {
    
    func setCollectionView() {
        mainView.collcectionView.register(HomeMatchCardCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(HomeMatchCardCollectionViewCell.self))
        mainView.collcectionView.collectionViewLayout = setCollectionViewLayout()
    }
    
    func setCollectionViewLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(100))
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item])
        group.interItemSpacing = .fixed(16)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .vertical
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        layout.configuration = config
        
        return layout
    }
}

extension HomeMatchCardListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(HomeMatchCardCollectionViewCell.self), for: indexPath) as? HomeMatchCardCollectionViewCell else { return UICollectionViewCell() }
        
        
        return cell
    }
    
    
    
    
}
