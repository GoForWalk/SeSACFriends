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
    private var cardData: [SearchCardDataDTO] {
        didSet {
            updateView(isDataEmpty: cardData.isEmpty)
        }
    }
    private let disposeBag = DisposeBag()
    private let requestButtonTabbed = PublishRelay<Int>()
    
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
        super.configure()
        setCollectionView()
        setView()
    }
    
    override func bind() {
        
        let requestButton = ControlEvent(events: requestButtonTabbed)
        
        let input = HomeMatchCardListViewModel.Input()
        
        self.rx.viewWillAppear
        
        mainView.reloadButton.rx.tap
        
        mainView.studyChangebutton.rx.tap
        
        requestButton
        
        
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
    
    }
}

private extension HomeMatchCardListViewController {
    
    func setView() {
        mainView.emptySubtitleText(text: tabSection.emptyTitle)
    }
        
    func updateView(isDataEmpty: Bool) {
        switch isDataEmpty {
        case true:
            mainView.setViewMode(viewMode: .empty)
        case false:
            mainView.setViewMode(viewMode: .cardList)
        }
    }
    
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
        
        guard let view = cell.viewController.view as? ProfileCardView else { return UICollectionViewCell() }
        
        view.requestButton.rx.tap
            .map { _ in
                indexPath.item
            }
            .bind(with: self) { vc, item in
                vc.requestButtonTabbed.accept(item)
            }
            .disposed(by: cell.dispoaseBag)
        
        return cell
    }
    
}
