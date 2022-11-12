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
        
        guard let output = viewModel?.transform(input: input, disposeBag: disposeBag) else { return }
        
        let emailValidation = output.emailValidation
        let tap = mainView.authButton.rx.tap
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
        
        emailValidation
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] bool in
                if bool {
                    self?.mainView.authButton.buttonMode = .fill
                } else {
                    self?.mainView.authButton.buttonMode = .disable
                }
            })
            .disposed(by: disposeBag)
        
        tap
            .map { true }
            .withLatestFrom(emailValidation)
            .debug()
            .subscribe { [weak self] element in
                if element {
                    self?.presentNextView()
                } else {
                    // TODO: Toast 시키기
                }
            }
            .disposed(by: disposeBag)
    }
    
}

private extension EmailInputViewController {
    
    func presentNextView() {
        guard let useCase = viewModel?.useCase else { return }
        let vc = GenderInputViewController()
        vc.viewModel = GenderInputViewModel(useCase: useCase)
        navigationController?.pushViewController(vc, animated: true)
    }
}
