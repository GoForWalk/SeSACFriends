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

final class TabViewController: TabmanViewController {
    
    private var viewControllers: [BaseViewController] = []
    private let useCase: HomeMainUseCase
    private let disposeBag = DisposeBag()
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, useCase: HomeMainUseCase) {
        self.useCase = useCase
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        bind()
        
        // Create Bar
        let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap
        
        // Add to View
        addBar(bar, dataSource: self, at: .top)
        
    }
}

// MARK: - ViewController 등록
private extension TabViewController {
    
    func bind() {
        
    }
    
    func setTab() {
        
    }
    
    func setNavi() {
        title = "새싹 찾기"
        
    }
    
}

extension TabViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
    func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
        return TabSection.allCases.count
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
