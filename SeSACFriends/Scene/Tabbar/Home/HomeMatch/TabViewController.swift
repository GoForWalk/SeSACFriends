//
//  TabViewController.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/26.
//

import UIKit
import Tabman
import Pageboy

import RxCocoa
import RxSwift
import Toast

final class TabViewController: TabmanViewController {
    
    private var viewControllers: [BaseViewController] = [
        HomeMatchCardListViewController(viewModel: HomeMatchCardListViewModel(), tabSection: .nearBySeSac, cardData: []),
        HomeMatchCardListViewController(viewModel: HomeMatchCardListViewModel(), tabSection: .requested, cardData: [])
    ]
    private let viewModel: HomeTabViewModel
    private let disposeBag = DisposeBag()
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, viewModel: HomeTabViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        setTMBar()
        setNavi()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
}

// MARK: - ViewController 등록
private extension TabViewController {
    
    func bind() {
        
        let input = HomeTabViewModel.Input(
            searchStopButton: (navigationItem.leftBarButtonItem?.rx.tap)!
        )
                
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        
        output.getCardData
            .subscribe(with: self) { vc, searchCardDatas in
                vc.setTab(data: searchCardDatas)
                vc.reloadData()
            }
            .disposed(by: disposeBag)
        
        output.deleteSuccessOutput
            .subscribe(with: self) { vc, deleteQueueSuccessType in
                vc.deletePresentView(deleteStatus: deleteQueueSuccessType)
            }
            .disposed(by: disposeBag)
    }
    
    func setTab(data: SearchCardDatasDTO) {
        
    }
    
    func setNavi() {
        title = "새싹 찾기"
        let searchStopButton = UIBarButtonItem(title: "찾기중단", style: .plain, target: TabViewController.self, action: nil)
        navigationController?.navigationItem.leftBarButtonItem = searchStopButton
    }
    
    func setTMBar() {
        // Create Bar
        let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap
        bar.scrollMode = .swipe
        bar.tintColor = Colors.green
        bar.layout.contentMode = .intrinsic
        bar.layout.alignment = .centerDistributed
        
        // Add to View
        addBar(bar, dataSource: self, at: .top)
    }
    
    func deletePresentView(deleteStatus: DeleteQueueSuccessType) {
        
        switch deleteStatus {
        case .deleteSuccess:
            self.navigationController?.popToRootViewController(animated: true)
        case .matchingStatus:
            DispatchQueue.main.async {
                self.view.makeToast(deleteStatus.successDescription, duration: 1.5, position: .center)
            }
            // TODO: 채팅뷰 띄워주기
        }
        
    }
    
}

extension TabViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
    func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
//        return TabSection.allCases.count
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: Pageboy.PageboyViewController, at index: Pageboy.PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: Pageboy.PageboyViewController) -> Pageboy.PageboyViewController.Page? {
        nil
    }
    
    func barItem(for bar: Tabman.TMBar, at index: Int) -> Tabman.TMBarItemable {
        let title = TabSection.allCases[index].tabTitle
        return TMBarItem(title: title)
    }
    
}

private extension TabViewController {
    
    func presentVC(presentType: PresentType, initViewController: @escaping () -> UIViewController, presentStyle: UIModalPresentationStyle = .automatic) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            switch presentType {
            case .push:
                self.navigationController?.pushViewController(initViewController(), animated: true)
            
            case .over:
                let vc = initViewController()
                vc.modalPresentationStyle = presentStyle
                self.present(vc, animated: true)
            
            case .presentNewNavi:
                let nav = UINavigationController(rootViewController: initViewController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
                
            default:
                return
            }
        }
    }
    
}

@frozen enum TabSection: Int, CaseIterable {
    case nearBySeSac
    case requested
}

extension TabSection {
    var tabTitle: String {
        switch self {
        case .nearBySeSac:
            return "주변 새싹"
        case .requested:
            return "받은 요청"
        }
    }
    
    var emptyTitle: String {
        switch self {
        case .nearBySeSac:
            return "아쉽게도 주변에 새싹이 없어요ㅠ"
        case .requested:
            return "아직 받은 요청이 없어요ㅠ"
        }
    }
}
