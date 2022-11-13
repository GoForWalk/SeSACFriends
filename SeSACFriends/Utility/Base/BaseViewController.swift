//
//  BaseViewController.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/07.
//

import UIKit

class BaseViewController: UIViewController {
    
    var childViewContollerList: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }
    
    func configure() {
        
    }
    
    func bind() {
        
    }
    
    deinit {
        print("❌❌❌❌❌❌❌❌❌ \(self.description) ❌❌❌❌❌❌❌❌❌")
    }
}

extension BaseViewController {
    
    // Toast View
    
    // present View
    
}

private extension BaseViewController {
    
    
    
}
