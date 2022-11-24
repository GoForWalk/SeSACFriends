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

final class HomeWordSearchViewController: BaseViewController, UICollectionViewDelegate {
    
    private let mainView = HomeWordSearchView()
    private let disposeBag = DisposeBag()
    // TODO: 의존성 주입
    var viewModel: HomeSearchWordViewModel
    
    let dataSource = RxCollectionViewSectionedAnimatedDataSource<CustomDataSection> { dataSource, collectionView, indexPath, item in
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
    
    init(viewModel: HomeSearchWordViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        navigationController?.isNavigationBarHidden = true
    }
    
    override func configure() {
        super.configure()
        mainView.collectionView.delegate = self
        mainView.collectionView.collectionViewLayout = setCollectionViewLayout()
        mainView.collectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(TagCollectionViewCell.self) )
        mainView.collectionView.register(TagHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NSStringFromClass(TagHeaderView.self))
        
    }
    
    override func bind() {
        let input = HomeSearchWordViewModel.Input(
            searchTextInput: mainView.searchBar.rx.text,
            collectionCellTapped: mainView.collectionView.rx.itemSelected,
            searchButtonTapped: mainView.searchBar.rx.searchButtonClicked,
            postStudyListButtonTapped: mainView.searchButton.rx.tap,
            viewDidAppear: self.rx.viewDidAppear
        )
        
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        
        output.tagTitleError
            .map { $0.rawValue }
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { vc, errorMessage in
                vc.presentToast(message: errorMessage)
            }
            .disposed(by: disposeBag)
        
        output.dataSourceOutput
            .debug()
            .bind(to: mainView.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.postStudyListResult
            .subscribe(with: self) { vc, queueSuccessType in
                switch queueSuccessType {
                case .studyRequestSuccess:
                    // TODO: MapStatus load 해야함... HomeMainViewController 에서 작업!!
                    vc.dismiss(animated: true)
                default:
                    vc.presentToast(message: queueSuccessType.successDescription)
                }
            }
            .disposed(by: disposeBag)
        
        mainView.searchBar.rx.searchButtonClicked
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { vc, _ in
                vc.mainView.searchBar.text = ""
            }
            .disposed(by: disposeBag)
        
        mainView.backButton.rx.tap
            .subscribe(with: self) { vc, _ in
                vc.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
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
            heightDimension: .estimated(55))
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item])
        
        group.interItemSpacing = .fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(50.0))
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .vertical
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        layout.configuration = config
        
        // UICollectionViewCompositional Layout
        return layout
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

struct CustomDataSection {
    var header: String
    var items: [Item]
}

extension CustomDataSection: AnimatableSectionModelType {
    typealias Item = CustomData
    
    var identity: String {
        return header
    }

    init(original: CustomDataSection, items: [Item]) {
        self = original
        self.items = items
    }
    
}

typealias CustomDataSource = [CustomDataSection]
