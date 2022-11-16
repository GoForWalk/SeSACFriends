//
//  ProfileInfoViewController.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/14.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class ProfileInfoViewController: CardViewController {

    let mainView = ProfileInfoView()
    var tableStackView: UIStackView?
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        cardViewTable?.snp.updateConstraints { make in
            make.height.equalTo(cardViewTable?.contentSize.height ?? 0)
        }
        cardViewTable?.reloadData()
//        tableStackView?.layoutIfNeeded()
        
        
        mainView.collectionView.reloadData()
    }
    
    override func configure() {
        super.configure()
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.register(ProfileCardCollectionViewCell.self, forCellWithReuseIdentifier: ProfileCardCollectionViewCell.description())
        mainView.collectionView.register(ProfileSettingCollectionViewCell.self, forCellWithReuseIdentifier: ProfileSettingCollectionViewCell.description())
        mainView.collectionView.collectionViewLayout = setCellSize()
    }
    
}

extension ProfileInfoViewController: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    private func setCellSize() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        let spacing: CGFloat = 24
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        return layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item {
        case ProfileInfoType.card.rawValue:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCardCollectionViewCell.description(), for: indexPath) as? ProfileCardCollectionViewCell else { return UICollectionViewCell() }
            
            
            cardViewTable = cell.profileCard.profileView.stackView.subviews[1].subviews.first as? UITableView
            setCardView()
            
             tableStackView = cell.profileCard.profileView.stackView
            return cell
        case ProfileInfoType.setting.rawValue:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileSettingCollectionViewCell.description(), for: indexPath) as? ProfileSettingCollectionViewCell else { return UICollectionViewCell() }
            
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    
}

@frozen enum ProfileInfoType: Int, CaseIterable {
    case card
    case setting
}
