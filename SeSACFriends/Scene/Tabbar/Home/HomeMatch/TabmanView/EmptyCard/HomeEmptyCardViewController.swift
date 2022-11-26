//
//  EmptyViewController.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/26.
//

import UIKit

import RxSwift
import RxCocoa

final class HomeEmptyCardViewController: BaseViewController {
    
    let mainView = HomeEmptyCardView()
    let viewModel: HomeEmptyCardViewModel
    
    init(viewModel: HomeEmptyCardViewModel) {
        self.viewModel = viewModel
    }
    
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
