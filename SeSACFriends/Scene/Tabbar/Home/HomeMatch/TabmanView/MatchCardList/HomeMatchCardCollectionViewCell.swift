//
//  HomeMatchCardCollectionViewCell.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/28.
//

import UIKit

import SnapKit

final class HomeMatchCardCollectionViewCell: BaseCollectionViewCell {
    
    private let data: SearchCardDataDTO
    private let cellType: CardViewDisplayView
    
    lazy var viewController: CardViewController = {
        let viewController = CardViewController(searchCardData: data, cardMode: cellType)
        
        return viewController
    }()
    
    init(data: SearchCardDataDTO, cellType: CardViewDisplayView) {
        self.data = data
        self.cellType = cellType
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
