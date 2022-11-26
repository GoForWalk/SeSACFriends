//
//  HomeMatchCardListViewController.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/26.
//
import UIKit

import RxSwift
import RxCocoa

final class HomeMatchCardListViewController: BaseViewController {
    
    let mainView = HomeMatchCardListView()
    let viewModel: HomeMatchCardListViewModel
    
    init(viewModel: HomeMatchCardListViewModel) {
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
    //TODO:
}
