//
//  HomeMatchCardCollectionViewCell.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/28.
//

import UIKit

import SnapKit
import RxSwift

final class HomeMatchCardCollectionViewCell: BaseCollectionViewCell {
    
    var data: SearchCardDataDTO?
    var cellType: CardViewDisplayView?
    let dispoaseBag = DisposeBag()
    
    lazy var viewController: CardViewController = {
        guard let data, let cellType else { return } // 이거 맞음??
        let viewController = CardViewController(searchCardData: data, cardMode: cellType)
        
        return viewController
    }()
    
    override func configure() {
        super.configure()
        contentView.addSubview(viewController.view)
    }
    
    override func setConstraints() {
        viewController.view.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
        
    }
}
