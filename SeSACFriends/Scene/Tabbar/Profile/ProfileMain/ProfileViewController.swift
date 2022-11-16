//
//  ProfileViewController.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/14.
//

import UIKit

import RxCocoa
import RxSwift

final class ProfileViewController: BaseViewController {

    let mainView = ProfileView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "내정보"
    }
    
    override func configure() {
        super.configure()
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.register(ProfileInfoTableCell.self, forCellReuseIdentifier: ProfileInfoTableCell.description())
        mainView.tableView.register(ProfileMainTableViewCell.self, forCellReuseIdentifier: ProfileMainTableViewCell.description())
    }
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return ProfileTable.allCases.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case ProfileTable.info.rawValue:
            return 96
        case ProfileTable.main.rawValue:
            return 74
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case ProfileTable.info.rawValue:
            return 1
        case ProfileTable.main.rawValue:
            return ProfileMain.allCases.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        
        case ProfileTable.info.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileInfoTableCell.description()) as? ProfileInfoTableCell else { return UITableViewCell ()}
            
            cell.configureCell(name: "새싹이", image: Images.sesacFace1.image)
            
            return cell
            
        case ProfileTable.main.rawValue:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileMainTableViewCell.description()) as? ProfileMainTableViewCell else { return UITableViewCell ()}
            
            cell.configureCell(index: indexPath.row)
            
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            presentVC(presentType: .push) {
                return ProfileInfoViewController()
            }
        }
    }
}

enum ProfileTable: Int, CaseIterable {
    case info
    case main
}
