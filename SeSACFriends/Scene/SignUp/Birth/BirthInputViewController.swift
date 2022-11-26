//
//  BirthInputViewController.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/11.
//

import UIKit

import RxSwift
import RxCocoa

final class BirthInputViewController: BaseViewController {
    
    private let mainView = BirthInputView()
    private let disposeBag = DisposeBag()
    var viewModel: BirthInputViewModel?
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.datePickerView.becomeFirstResponder()
    }
    
    override func bind() {
        
        let input = BirthInputViewModel.Input(
            datePicked: mainView.datePickerView.rx.date
        )
        
        guard let output = viewModel?.transform(input: input, disposeBag: disposeBag) else { return }
        
        output.pickedDay
            .map {"\($0)"}
            .asDriver(onErrorJustReturn: "")
            .drive(mainView.dayTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.pickedMonth
            .map {"\($0)"}
            .asDriver(onErrorJustReturn: "")
            .drive(mainView.monthTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.pickedYear
            .map {"\($0)"}
            .asDriver(onErrorJustReturn: "")
            .drive(mainView.yearTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.availableAge
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] bool in
                if bool {
                    self?.mainView.authButton.buttonMode = .fill
                } else {
                    self?.mainView.authButton.buttonMode = .disable
                }
            })
            .disposed(by: disposeBag)
        
        mainView.authButton.rx.tap
            .map { true }
            .withLatestFrom(output.availableAge)
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe { [weak self] element in
                if element {
                    self?.presentNextView()
                } else {
                    self?.presentToast(message: "새싹스터디는 만 17세 이상만 사용할 수 있습니다.")
                }
            }
            .disposed(by: disposeBag)
    }
    
}

private extension BirthInputViewController {
    
    func presentNextView() {
        guard let useCase = viewModel?.useCase else { return }
        let vc = EmailInputViewController()
        vc.viewModel = EmailInputViewModel(useCase: useCase)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
