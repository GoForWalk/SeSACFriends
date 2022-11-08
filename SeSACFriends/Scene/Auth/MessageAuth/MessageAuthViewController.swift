//
//  MessageAuthViewController.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/08.
//

import UIKit

class MessageAuthViewController: BaseViewController {

    let mainView = MessageAuthView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
