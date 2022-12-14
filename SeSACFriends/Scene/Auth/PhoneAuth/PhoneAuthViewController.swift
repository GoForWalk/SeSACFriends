//
//  PhoneAuthViewController.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/08.
//

import UIKit

import RxCocoa
import RxSwift

class PhoneAuthViewController: BaseViewController {

    // +82 10-8989-9999  , 123123
//    let phoneNumber = "+821089899999"
//    let verificationCode = "123123"
    
    private var disposeBag = DisposeBag()
    private let mainView = PhoneAuthView()
    var viewModel = PhoneAuthViewModel()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind() {
        
        let input = PhoneAuthViewModel.Input(
            phoneNum: mainView.textField.rx.text,
            sendMessageButton: mainView.authButton.rx.tap
        )
        
        let output = viewModel.transform(input: input, disposeBag: self.disposeBag)
        
        output.phoneNumText
            .asDriver(onErrorJustReturn: "")
            .drive(mainView.textField.rx.text)
            .disposed(by: disposeBag)
        
        output.phoneNumValidated
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] bool in
                switch bool {
                case true: self?.mainView.authButton.buttonMode = .fill
                case false: self?.mainView.authButton.buttonMode = .disable
                }
            })
            .disposed(by: disposeBag)
        
//        mainView.authButton.rx.tap
//            .map { true }
//            .withLatestFrom(output.phoneNumValidated)
//            .debounce(.seconds(2), scheduler: MainScheduler.instance)
//            .debug()
//            .subscribe { [weak self] validate in
//                if validate {
//                    
//                } else {
//                    self?.presentToast(message: "")
//                }
//            }
        
        output.messageAuthFlow
            .asDriver(onErrorJustReturn: false)
            .drive { [weak self] bool in
                if bool {
                    guard let useCase = self?.viewModel.authUseCase else { return }
                    let vc = MessageAuthViewController()
                    vc.viewModel = MessageAuthViewModel(useCase: useCase)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
    
}
