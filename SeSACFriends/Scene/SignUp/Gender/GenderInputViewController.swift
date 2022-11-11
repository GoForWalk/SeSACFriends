//
//  GenderInputViewController.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/11.
//

import UIKit

import RxSwift
import RxCocoa

final class GenderInputViewController: BaseViewController {
    
    private let mainView = GenderInputView()
    private let disposeBag = DisposeBag()
    var viewModel: GenderInputViewModel?
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configure() {
        super.configure()
        
        mainView.genderPickCollectionView.delegate = self
        mainView.genderPickCollectionView.dataSource = self
        mainView.genderPickCollectionView.register(GenderCollectionViewCell.self, forCellWithReuseIdentifier: GenderCollectionViewCell.description())
        mainView.genderPickCollectionView.collectionViewLayout = setCellSize()
    }
    
    override func bind() {
        
        
        
    }
    
}

private extension GenderInputViewController {
    
    func setCellSize() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 4
        let numOfCell: CGFloat = 2
        let numOfSpace: CGFloat = numOfCell + 1

        let width = (UIScreen.main.bounds.width - (spacing * numOfSpace)) / numOfCell

        let height = mainView.genderPickCollectionView.bounds.height
        
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.itemSize = CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.scrollDirection = .horizontal
        
        return layout
    }
    
}

extension GenderInputViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GenderInfo.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenderCollectionViewCell.description(), for: indexPath) as? GenderCollectionViewCell else { return UICollectionViewCell() }
        
        cell.setCell(indexPath: indexPath.item)
        cell.tag = indexPath.item
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? GenderCollectionViewCell {
            cell.contentView.backgroundColor = Colors.whiteGreen
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? GenderCollectionViewCell {
            cell.contentView.backgroundColor = Colors.white
        }

    }
}

@frozen enum GenderInfo: Int, CaseIterable {
    
    case male = 1
    case female = 0
}

extension GenderInfo {
    
    var image: UIImage {
        switch self {
        case .male:
            return Images.man.image
        case .female:
            return Images.woman.image
        }
    }
    
    var text: String {
        switch self {
        case .male:
            return "남자"
        case .female:
            return "여자"
        }
    }
    
}
