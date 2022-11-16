//
//  ProfileView.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/14.
//

import UIKit

import SnapKit

final class ProfileView: BaseView {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.selectionFollowsFocus = false
        tableView.allowsFocus = false
        return tableView
    }()
    
    override func configure() {
        addSubview(tableView)
    }
    
    override func setConstraints() {
        
        tableView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            make.verticalEdges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
}
