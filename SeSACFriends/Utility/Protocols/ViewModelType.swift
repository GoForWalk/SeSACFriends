//
//  ViewModelType.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/08.
//

import Foundation
import RxSwift

protocol ViewModelType {
    
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output
}
