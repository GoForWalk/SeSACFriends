//
//  HomeViewController.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/14.
//

import UIKit

import RxCocoa
import RxSwift

final class HomeViewController: BaseViewController {

    let mainView = HomeMainView()
    var viewModel: HomeMainViewModel?
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func configure() {
        setNavi()
    }
    
    override func bind() {
        let input = HomeMainViewModel.Input(
            mapCenterLocation:mainView.map.rx.centerCoordinate
        )
        
        guard let output = viewModel?.transform(input: input, disposeBag: disposeBag) else { return }
        
        output.buttonStatus
            .bind(onNext: { [weak self] homeStatus in
                self?.mainView.statusButton.setImageSize(imageInfo: homeStatus.buttonImage, state: .normal)
            })
            .disposed(by: disposeBag)
        
        mainView.statusButton.rx.tap
            .map { true }
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(output.buttonStatus)
            .debug()
            .subscribe { [weak self] homeStatus in
                self?.presentMainVC(status: homeStatus.element)
            }
            .disposed(by: disposeBag)
        
        
        
        
    }//: bind()
    
}

private extension HomeViewController {
    
    func setNavi() {
        navigationController?.isToolbarHidden = true
    }
    
    func presentMainVC(status: HomeStatus?) {
        switch status {
        case .searching:
            presentVC(presentType: .push) {
                return UIViewController()
            }
        case .matchWaiting:
            presentVC(presentType: .push) {
                return UIViewController()
            }
        case .matched:
            presentVC(presentType: .push) {
                return UIViewController()
            }
        default:
            return
        }
    }
    
}
