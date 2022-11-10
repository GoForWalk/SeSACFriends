//
//  MessageAuthViewController.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/08.
//

import UIKit

import RxCocoa
import RxSwift

class MessageAuthViewController: BaseViewController {

//    let phoneNumber = "+821089899999"
//    let verificationCode = "123123"
    private let disposeBag = DisposeBag()
    private let mainView = MessageAuthView()
    var viewModel: MessageAuthViewModel?
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bind() {
        
        let input = MessageAuthViewModel.Input(
            resendButtonTap: mainView.resendButton.rx.tap,
            authButtonTap: mainView.authButton.rx.tap,
            messageNum: mainView.textField.rx.text
        )
        
        let output = viewModel?.transform(input: input, disposeBag: disposeBag)
        
        output?.expiredTimeOut
            .asDriver(onErrorJustReturn: "")
            .drive(mainView.timeLabel.rx.text)
            .disposed(by: disposeBag)
        
        output?.messageNumValidate
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] bool in
                switch bool {
                case true: self?.mainView.authButton.buttonMode = .fill
                case false: self?.mainView.authButton.buttonMode = .disable
                }
            })
            .disposed(by: disposeBag)
        
        output?.isMessageExpired
            .asDriver(onErrorJustReturn: true)
            .drive(onNext: { [weak self] bool in
                if bool {
                    self?.mainView.authButton.buttonMode = .disable
                    // 탭시 에러문 방출
                }
            })
            .disposed(by: disposeBag)
        
    }
    
}
