//
//  ChatTableHeaderView.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/12/02.
//

import UIKit

import SnapKit

final class FirstChatTableView: BaseTableViewCell {
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 20
        label.backgroundColor = Colors.gray7
        label.setLineHeight(fontInfo: Fonts.title5M12)
        label.textColor = Colors.white
        label.textAlignment = .center
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [bellImage, nickLabel])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    let bellImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.bell.image
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let nickLabel: UILabel = {
        let label = UILabel()
        label.setLineHeight(fontInfo: Fonts.title3M14)
        label.textColor = Colors.gray7
        label.text = "고래밥님과 매칭되었습니다."
        return label
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.gray6
        label.setLineHeight(fontInfo: Fonts.title4R14)
        label.text = "채팅을 통헤 약속을 정해보세요 :)"
        return label
    }()
    
    override func configure() {
        super.configure()
        addSubViews(views: dateLabel, stackView, infoLabel)
    }
    
    override func setConstraints() {
        
    }
    
    func setConfigure(dateStr: String, otherNick: String) {
        nickLabel.text = "\(otherNick)님과 매칭되었습니다"
        dateLabel.text = " \(dateStr) "
    }
    
}
