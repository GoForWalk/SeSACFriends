//
//  MessageAuthViewModel.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/08.
//

import Foundation

import RxSwift
import RxCocoa

final class MessageAuthViewModel: ViewModelType {
    
    let useCase: AuthUseCase
    private let time: Int = 15
    private var timerDisposable: Disposable?
    
    init(useCase: AuthUseCase) {
        self.useCase = useCase
    }
    
    struct Input {
        let resendButtonTap: ControlEvent<Void>
        let authButtonTap: ControlEvent<Void>
        let messageNum: ControlProperty<String?>
    }
    
    struct Output {
        let expiredTimeOut = BehaviorRelay<String>(value: "")
        let authButtonTap = BehaviorRelay<Bool>(value: false)
        let messageNumValidate = BehaviorSubject<Bool>(value: false)
        let isMessageExpired = BehaviorRelay<Bool>(value: false)
        let apiConnectResult = BehaviorRelay(value: 0)
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        configureInput(input: input, disposeBag: disposeBag)
        return createOutput(input: input, disposeBag: disposeBag)
    }
    
    
}

private extension MessageAuthViewModel {
    
    func configureInput(input: Input, disposeBag: DisposeBag) {
        
        input.resendButtonTap
            .bind { [weak self] in
                self?.useCase.sendMessage(isResend: true)
            }
            .disposed(by: disposeBag)
        
        input.messageNum.orEmpty
            .withUnretained(self)
            .bind {
                $0.useCase.validateMessage(str: $1)
            }
            .disposed(by: disposeBag)
        
        input.authButtonTap
            .bind { [weak self] in
                self?.useCase.messageAuthDone()
            }
            .disposed(by: disposeBag)
        
    }
    
    func createOutput(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        startTimer(output: output)
        
        input.resendButtonTap
            .bind { [weak self] in
                self?.startTimer(output: output)
            }
            .disposed(by: disposeBag)
        
        useCase.messageValidation
            .bind(to: output.messageNumValidate)
            .disposed(by: disposeBag)
        
        useCase.apiconnect
            .bind(to: output.apiConnectResult)
            .disposed(by: disposeBag)
        
        return output
    }
        
    func secondsToMinutesSeconds(_ seconds: Int) -> String {
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        
        guard let formattedString = formatter.string(from: TimeInterval(seconds)) else { return "" }
        return formattedString
    }
    
    func startTimer(output: Output) {

        timerDisposable?.dispose()
        timerDisposable = Observable<Int>
            .timer(.seconds(1), period: .seconds(1), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { vm, value in
                if value <= vm.time {
                    output.expiredTimeOut.accept(vm.secondsToMinutesSeconds(15 - value))
                } else {
                    output.isMessageExpired.accept(true)
                    vm.timerDisposable?.dispose()
                }
            }
    }
}
