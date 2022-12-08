//
//  HomeChattingView.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/12/01.
//

import UIKit

import SnapKit

final class HomeChattingView: BaseView {
    
    let chatTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    let textField: UITextView = {
       let textView = UITextView()
        textView.backgroundColor = Colors.gray1
        textView.layer.cornerRadius = 8
        textView.setLineHeight(fontInfo: Fonts.body3R14)
        return textView
    }()
    
    let button: UIButton = {
       let button = UIButton()
        button.setImage(Images.sendInactive, for: .normal)
        return button
    }()
    
    let messageView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.gray1
        view.layer.cornerRadius = 8
        return view
    }()
    
    override func configure() {
        super.configure()
        messageView.addSubViews(views: button, textField)
        addSubview(chatTableView)
    }
    
    override func setConstraints() {
        chatTableView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(self.safeAreaLayoutGuide)
        }
        
        
        
        
    }
    
    func changeTextButton(isTexton: Bool) {
        if isTexton {
            button.setImage(Images.sendActive, for: .normal)
        } else {
            button.setImage(Images.sendInactive, for: .normal)
        }
        
    }
    
}
