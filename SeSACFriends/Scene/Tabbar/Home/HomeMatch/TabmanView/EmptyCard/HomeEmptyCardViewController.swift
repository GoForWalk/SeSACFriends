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
    
    private let mainView = HomeEmptyCardView()
    private let viewModel: HomeEmptyCardViewModel
    private var tabSection: TabSection
    private let disposeBag = DisposeBag()
    
    init(viewModel: HomeEmptyCardViewModel, tabSection: TabSection) {
        self.viewModel = viewModel
        self.tabSection = tabSection
        super.init(nibName: nil, bundle: nil)
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
        
        let input = HomeEmptyCardViewModel.Input()
        
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        
    }
    
}
