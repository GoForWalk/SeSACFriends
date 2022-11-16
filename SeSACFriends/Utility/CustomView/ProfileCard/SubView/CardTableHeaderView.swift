//
//  CardTableHeaderView.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/15.
//

import UIKit

import SnapKit

final class CardTableHeaderView: UITableViewHeaderFooterView {
    
    lazy var label: UILabel = {
       let label = UILabel()
        label.setLineHeight(fontInfo: Fonts.title6R12)
        label.textColor = Colors.black
        label.textAlignment = .left
        return label
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setImage(Images.moreArrow.image, for: .normal)
        return button
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
//        self.addSubViews(views: label, button)
        self.addSubViews(views: label)
        
    }
    
    private func setConstraints() {
        
//        self.snp.makeConstraints { make in
//            make.height.equalTo(24)
//        }
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(self).inset(16)
            make.bottom.equalTo(self).inset(16)
            make.top.equalTo(self).inset(10)
            make.trailing.equalTo(self).inset(30)
        }
        
//        button.snp.makeConstraints { make in
//            make.trailing.equalTo(self).inset(16)
//            make.centerY.equalTo(label)
//            make.width.height.equalTo(12)
//        }
    }
    
    func setConfigure(text: String, isButtonHidden: Bool) {
        button.isHidden = isButtonHidden
        label.text = text
    }
    
    func setConfigure(isButtonHidden: Bool) {
        button.isHidden = isButtonHidden
    }
     
}
