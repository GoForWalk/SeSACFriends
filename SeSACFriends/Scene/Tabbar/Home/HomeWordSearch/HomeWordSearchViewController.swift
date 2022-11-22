//
//  HomeWordSearchViewController.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/21.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources
import Differentiator

final class HomeWordSearchViewController: BaseViewController {
    
    private let mainView = HomeWordSearchView()
    private let disposeBag = DisposeBag()
    // TODO: 의존성 주입
    var ViewModel: HomeSearchWordViewModel?
    
    let dataSource = RxCollectionViewSectionedAnimatedDataSource<SectionCustomData> { dataSource, collectionView, indexPath, item in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(TagCollectionViewCell.self), for: indexPath) as? TagCollectionViewCell else { return UICollectionViewCell() }
        cell.configureButton(buttonTitle: item.text, sectionType: item.buttonStyle)
        return cell

    } configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
        print("Kind: \(kind)")
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: NSStringFromClass(TagHeaderView.self), for: indexPath) as? TagHeaderView else { return UICollectionReusableView() }
            header.sectionTitleLabel.text = TagSectionType.allCases[indexPath.section].sectionTitle
            
            return header
        default:
            assert(false, "Unexpected element Kind")
        }
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
    override func configure() {
        super.configure()
        mainView.collectionView.delegate = self
        mainView.collectionView.collectionViewLayout = setCollectionViewLayout()
        mainView.collectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(TagCollectionViewCell.self) )
        mainView.collectionView.register(TagHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NSStringFromClass(TagHeaderView.self))
        
    }
    
    override func bind() {
        
        let input = HomeSearchWordViewModel.Input()
        
        guard let output = ViewModel?.transform(input: input, disposeBag: disposeBag) else { return }
        
        
    }
    
}

// MARK: - Rx Binding
private extension HomeWordSearchViewController {
    
    
    
}

// MARK: - UICollection Delegate
extension HomeWordSearchViewController: UICollectionViewDelegate {
   

}

//MARK: - CompositionalLayout Setting
private extension HomeWordSearchViewController {
    
    func setCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(60),
            heightDimension: .absolute(32)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(55))
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item])
        
        group.interItemSpacing = .fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 0)
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .vertical
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        layout.configuration = config
        
        
        
        // UICollectionViewCompositional Layout
        return layout
    }
    
    func recommandAndNearby() {
        
    }
    
    func myWord() {
        
    }

}

@frozen enum TagSectionType: Int, CaseIterable {
    
    case recommandAndNearby
    case myWord
    
    var sectionTitle: String {
        switch self {
        case .recommandAndNearby:
            return "지금 주변에는"
            
        case .myWord:
            return "내가 하고 싶은"
        }
    }
}

struct CustomData : Hashable{
    var text: String
    var buttonStyle: ButtonSectionStyle
}

extension CustomData: IdentifiableType, Equatable {
    var identity: String {
        return UUID().uuidString
    }
}

struct SectionCustomData {
    var header: String
    var items: [Item]
}

extension SectionCustomData: AnimatableSectionModelType {
    typealias Item = CustomData
    
    var identity: String {
        return header
    }

    init(original: SectionCustomData, items: [Item]) {
        self = original
        self.items = items
    }
    
}
