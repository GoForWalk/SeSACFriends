//
//  BirthInputViewModel.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/11.
//

import Foundation

import RxSwift
import RxCocoa

final class BirthInputViewModel: ViewModelType {
    
    let useCase: SignUpUseCase
    private let calendar = Calendar.current

    init(useCase: SignUpUseCase){
        self.useCase = useCase
    }
    
    struct Input {
        let datePicked: ControlProperty<Date>
    }
    
    struct Output {
        let pickedDay = BehaviorSubject(value: 1)
        let pickedMonth = BehaviorSubject(value: 1)
        let pickedYear = BehaviorSubject(value: 1990)
        let availableAge = PublishSubject<Bool>()
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        self.configureInput(input: input, disposeBag: disposeBag)
        return createOutput(input: input, disposeBag: disposeBag)
    }
    
}

private extension BirthInputViewModel {
    
    func configureInput(input: Input, disposeBag: DisposeBag) {
        input.datePicked
            .withUnretained(self)
            .bind { $0.useCase.checkBirthValidate(date: $1) }
            .disposed(by: disposeBag)
    }
    
    func createOutput(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.datePicked
            .withUnretained(self)
            .subscribe {
                output.pickedDay.onNext($0.dateToCalendars(date: $1, component: .day))
                output.pickedMonth.onNext($0.dateToCalendars(date: $1, component: .month))
                output.pickedYear.onNext($0.dateToCalendars(date: $1, component: .year))
            }
            .disposed(by: disposeBag)
        
        useCase.birthValidation
            .bind(to: output.availableAge)
            .disposed(by: disposeBag)
        
        return output
    }
    
    func dateToCalendars(date: Date, component: Calendar.Component) -> Int {
        return calendar.component(component, from: date)
    }
}

