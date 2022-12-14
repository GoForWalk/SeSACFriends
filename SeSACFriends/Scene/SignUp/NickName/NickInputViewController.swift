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
        
        guard let output = viewModel?.transform(input: input, disposeBag: disposeBag) else { return }
        
        output.nickValidation
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] bool in
                guard let self else { return }
                switch bool {
                case true:
                    self.mainView.authButton.buttonMode = .fill
                case false:
                    self.mainView.authButton.buttonMode = .disable
                }
            })
            .disposed(by: disposeBag)
        
        mainView.authButton.rx.tap
            .map { true }
            .withLatestFrom(output.nickValidation)
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe { [weak self] element in
                guard let element = element.element, let self else { return }
                if element {
                    self.presentVC(presentType: .push, initViewController: self.presentNextView)
                } else {
                    self.presentToast(message: "닉네임은 1자 이상 10자 이내로 부탁드려요.")
                }
            }
            .disposed(by: disposeBag)
    }
    
}

private extension NickInputViewController {
    
    func presentNextView() -> BaseViewController {
        guard let useCase = viewModel?.useCase else { return  BaseViewController() }
        let vc = BirthInputViewController()
        vc.viewModel = BirthInputViewModel(useCase: useCase)
//        navigationController?.pushViewController(vc, animated: true)
        return vc
    }
    
}
