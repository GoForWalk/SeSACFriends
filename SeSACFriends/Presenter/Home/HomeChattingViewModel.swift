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
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        self.configureInput(input: input, disposeBag: disposeBag)
        return createOutput(input: input, disposeBag: disposeBag)
    }
    
}

private extension HomeChattingViewModel {
        
    func configureInput(input: Input, disposeBag: DisposeBag) {
        
    }
    
    func createOutput(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        
        return output
    }
    
}
