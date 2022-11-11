//
//  EmailInputViewController.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/11.
//

import UIKit

import RxSwift
import RxCocoa

final class EmailInputViewController: BaseViewController {
    
    private let mainView = EmailInputView()
    private let disposeBag = DisposeBag()
    var viewModel: EmailInputViewModel?
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.textField.becomeFirstResponder()
    }
    
    override func bind() {
        
        let input = EmailInputViewModel.Input(
            emailTextInput: mainView.textField.rx.text
        )
        
        let out = viewModel?.transform(input: input, disposeBag: disposeBag)
        
        
    }
    
}
