//
//  ProfileView.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/14.
//

import UIKit

import SnapKit

final class ProfileCardRollableView: BaseView {
    
    private var isTapped: Bool = true
    var tableHeight: ConstraintMakerEditable?
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [profiletitleView, tableContainerView])
        stackView.layer.cornerRadius = 8
        stackView.layer.borderColor = Colors.gray2.cgColor
        stackView.layer.borderWidth = 1
        stackView.clipsToBounds = true
        stackView.axis = .vertical
//        stackView.autoresizesSubviews = true
        stackView.distribution = .fill
        return stackView
    }()
    
    lazy var nameLabel: UILabel = {
       let label = UILabel()
        label.setLineHeight(fontInfo: Fonts.title1M16)
        label.textColor = Colors.black
        label.text = "새싹이"
        label.textAlignment = .left
        return label
    }()
    
    lazy var crossImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.moreArrow.image
        return imageView
    }()
    
    lazy var profiletitleView: UIView = {
        let view = UIView()
        backgroundColor = Colors.white
        return view
    }()
    
    lazy var tableContainerView: UIView = {
        let view = UIView()
        backgroundColor = Colors.white
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
        tableView.isScrollEnabled = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = Colors.white
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override func configure() {
        profiletitleView.addSubViews(views: nameLabel, crossImageView)
        tableContainerView.addSubview(tableView)
        addSubViews(views: stackView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileTapped(sender:)))
        profiletitleView.addGestureRecognizer(tapGesture)
//        tableView.isHidden = !isTapped
    }
    
    override func setConstraints() {
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(self)
            make.width.equalTo(UIScreen.main.bounds.width - 32)
            make.height.equalTo(500)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profiletitleView)
            make.leading.equalTo(profiletitleView).inset(16)
            make.height.equalTo(26)
            make.trailing.greaterThanOrEqualTo(crossImageView.snp.leading).offset(10)
        }
        
        crossImageView.snp.makeConstraints { make in
            make.width.height.equalTo(12)
            make.trailing.equalTo(profiletitleView).inset(18)
            make.centerY.equalTo(nameLabel)
        }
        
        profiletitleView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(stackView)
            make.top.equalTo(stackView)
            make.height.equalTo(52)
            make.bottom.equalTo(tableView.snp.top)
        }
        
        tableView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(stackView)
            make.bottom.equalTo(stackView)
            let temp = make.height.equalTo(0)
            self.tableHeight = temp
            // updateConstraints
        }
        
    }
        
    @objc private func profileTapped(sender: UITapGestureRecognizer) {
        tableView.isHidden = !isTapped
        isTapped.toggle()
    }
    
    func setStartInfoViewMode(isHidden: Bool) {
        isTapped = isHidden
    }
    
}
