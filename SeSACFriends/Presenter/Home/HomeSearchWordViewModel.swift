//
//  HomeSearchWordViewModel.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/21.
//

import Foundation

import RxCocoa
import RxSwift

final class HomeSearchWordViewModel: ViewModelType {
    
    let useCase: HomeMainUseCase
    
    struct Input {
        let searchTextInput: ControlProperty<String?>
        let collectionCellTapped: ControlEvent<IndexPath>
        let searchButtonTapped: ControlEvent<Void>
        let postStudyListButtonTapped: ControlEvent<Void>
        let viewDidAppear: ControlEvent<Void>
    }
    
    struct Output {
        let dataSourceOutput = BehaviorSubject<CustomDataSource>(value: [])
        let postStudyListResult = PublishSubject<QueueSuccessType>()
        let tagTitleError = PublishSubject<TagValidation>()
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        self.configureInput(input: input, disposeBag: disposeBag)
        return createOutput(input: input, disposeBag: disposeBag)
    }
    
    init(useCase: HomeMainUseCase) {
        self.useCase = useCase
    }
}

private extension HomeSearchWordViewModel {
        
    func configureInput(input: Input, disposeBag: DisposeBag) {
        
        input.searchButtonTapped
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchTextInput.orEmpty)
            .share()
            .subscribe(with: self) { vm, string in
                vm.useCase.formattingTag(myTag: string)
            }
            .disposed(by: disposeBag)
        
        input.collectionCellTapped
            .debug()
            .subscribe(with: self) { vm, indexPath in
                switch indexPath.section {
                case TagSectionType.recommandAndNearby.rawValue:
                    vm.useCase.addTagFromNearByTags(index: indexPath.item)
                case TagSectionType.myWord.rawValue:
                    vm.useCase.removeMyTag(index: indexPath.item)
                default:
                    return
                }
            }
            .disposed(by: disposeBag)
        
        input.postStudyListButtonTapped
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(with: self) { vm, _ in
                vm.useCase.postStudyList()
            }
            .disposed(by: disposeBag)
        
        input.viewDidAppear
            .subscribe(with: self) { vm, _ in
                vm.useCase.getSearchWord()
            }
            .disposed(by: disposeBag)
    }
    
    func createOutput(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        createDataSource(output: output, disposeBag: disposeBag)
        
        useCase.postStudySearch
            .subscribe(with: self, onNext: { vm, queueSuccessType in
                output.postStudyListResult.onNext(queueSuccessType)
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
    func createDataSource(output: Output, disposeBag: DisposeBag) {
        let nearBy = useCase.searchWordResult.asObservable()
        
        let myTag = BehaviorSubject<[CustomData]>(value: [])
        useCase.myTagOutput
            .subscribe(with: self) { vm, result in
                switch result {
                case .success(let datasource):
                    myTag.onNext(datasource)
                case .failure(let error as TagValidation):
                    output.tagTitleError.onNext(error)
                default:
                    return
                }
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(nearBy, myTag)
            .subscribe { nearBy, myTag in
                output.dataSourceOutput.onNext([
                    CustomDataSection(header: TagSectionType.recommandAndNearby.sectionTitle, items: nearBy),
                    CustomDataSection(header: TagSectionType.myWord.sectionTitle, items: myTag)
                ])
            }
            .disposed(by: disposeBag)
    }
    
    
}
