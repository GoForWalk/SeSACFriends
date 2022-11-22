//
//  TagHeaderView.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/22.
//

import UIKit

import SnapKit

final class TagHeaderView: UICollectionReusableView {
    
    lazy var sectionTitleLabel: UILabel = {
        let label = UILabel()
        
        label.setLineHeight(fontInfo: Fonts.title6R12)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        addSubview(sectionTitleLabel)
    }
    
    private func setConstraints() {
        sectionTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.verticalEdges.equalToSuperview()
        }
    }
    
}
