//
//  HomeChattingViewController.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/12/01.
//

import UIKit

import RxCocoa
import RxSwift

final class HomeChattingViewController: BaseViewController {
    
    private let mainView = HomeChattingView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configure() {
        
    }
    
    override func bind() {
        
    }
    
}


