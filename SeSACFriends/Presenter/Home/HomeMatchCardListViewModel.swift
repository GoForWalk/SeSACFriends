//
//  HomeMatchCardListViewModel.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/26.
//

import Foundation

import RxCocoa
import RxSwift

final class HomeMatchCardListViewModel: ViewModelType {
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        self.configureInput(input: input, disposeBag: disposeBag)
        return createOutput(input: input, disposeBag: disposeBag)
    }
    
}

private extension HomeMatchCardListViewModel {
        
    func configureInput(input: Input, disposeBag: DisposeBag) {
        
    }
    
    func createOutput(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        
        return output
    }
    
}
