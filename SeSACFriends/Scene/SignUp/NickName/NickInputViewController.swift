//
//  NickInputViewController.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/11.
//

import UIKit

import RxSwift
import RxCocoa

final class NickInputViewController: BaseViewController {
    
    private let mainView = NickInputView()
    private let disposeBag = DisposeBag()
    var viewModel: NickInputViewModel?
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.textField.becomeFirstResponder()
    }
    
    override func bind() {
        
        let input = NickInputViewModel.Input(
            nickTextInput: mainView.textField.rx.text
        )
        
        let output = viewModel?.transform(input: input, disposeBag: disposeBag)
        
        output?.nickValidation
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] bool in
                guard let self else { return }
                switch bool {
                case true:
                    self.mainView.authButton.buttonMode = .fill
                    self.mainView.authButton.isEnabled = true
                case false:
                    self.mainView.authButton.buttonMode = .disable
                    self.mainView.authButton.isEnabled = false
                }
            })
            .disposed(by: disposeBag)
        
        mainView.authButton.rx.tap
            .bind { [weak self] in
                
                guard let useCase = self?.viewModel?.useCase else { return }
                
                let vc = BirthInputViewController()
                vc.viewModel = BirthInputViewModel(useCase: useCase)
            }
            .disposed(by: disposeBag)
    }
    
}
