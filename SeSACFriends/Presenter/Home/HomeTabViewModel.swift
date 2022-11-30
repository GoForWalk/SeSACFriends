//
//  HomeTabViewModel.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/26.
//

import Foundation

import RxCocoa
import RxSwift

final class HomeTabViewModel: ViewModelType {
    
    let useCase: HomeMainUseCase
    
    init(useCase: HomeMainUseCase) {
        self.useCase = useCase
    }
    
    struct Input {
//        let viewWillAppear: ControlEvent<Void>
        let searchStopButton: ControlEvent<()>
    }
    
    struct Output {
        let getCardData = PublishSubject<SearchCardDatasDTO>()
        let deleteSuccessOutput = PublishSubject<DeleteQueueSuccessType>()
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        self.configureInput(input: input, disposeBag: disposeBag)
        return createOutput(input: input, disposeBag: disposeBag)
    }
    
}

private extension HomeTabViewModel {
        
    func configureInput(input: Input, disposeBag: DisposeBag) {
        
//        input.viewWillAppear
//            .subscribe(with: self) { vm, _ in
//                vm.useCase.getCardData()
//            }
//            .disposed(by: disposeBag)
//        
        input.searchStopButton
            .subscribe(with: self) { vm, _ in
                vm.useCase.stopSearchingUser()
            }
            .disposed(by: disposeBag)
        
    }
    
    func createOutput(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        useCase.cardListData
            .subscribe { data in
                output.getCardData.onNext(data)
            }
            .disposed(by: disposeBag)
        
        useCase.deleteQueueSuccessType
            .subscribe { deleteSuccessType in
                output.deleteSuccessOutput.onNext(deleteSuccessType)
            }
            .disposed(by: disposeBag)
        
        return output
    }
    
}
