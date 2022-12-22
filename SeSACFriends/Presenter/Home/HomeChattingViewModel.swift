//
//  HomeChattingViewModel.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/12/02.
//

import Foundation

import RxCocoa
import RxSwift

final class HomeChattingViewModel: ViewModelType {
    
    private let useCase: ChattingUseCase
    
    struct Input {
        let text: ControlProperty<String?>
        let postButton: ControlEvent<Void>
        let viewWillAppear: ControlEvent<Void>
        let viewDidDisappear: ControlEvent<Void>
    }
    
    struct Output {
        let chatDataSource = PublishSubject<ChatDataSource>()
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        self.configureInput(input: input, disposeBag: disposeBag)
        return createOutput(input: input, disposeBag: disposeBag)
    }
    
    init(useCase: ChattingUseCase) {
        self.useCase = useCase
    }
    
}

private extension HomeChattingViewModel {
        
    func configureInput(input: Input, disposeBag: DisposeBag) {
        
        input.postButton
            .map { "" }
            .withLatestFrom(input.text)
            .subscribe(with: self) { vm, text in
                guard let text else { return }
                vm.useCase.uploadMyChat(text: text)
            }
            .disposed(by: disposeBag)
        
        input.viewWillAppear
            .subscribe(with: self) { vm, _ in
                vm.useCase.loadChat()
            }
            .disposed(by: disposeBag)
        
        input.viewDidDisappear
            .subscribe(with: self) { vm, _ in
                vm.useCase.disconnectSocket()
            }
            .disposed(by: disposeBag)
            
    }
    
    func createOutput(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        useCase.chatUpdate
            .subscribe { chatDataSource in
                output.chatDataSource.onNext(chatDataSource)
            }
            .disposed(by: disposeBag)
        
        return output
    }
    
}
