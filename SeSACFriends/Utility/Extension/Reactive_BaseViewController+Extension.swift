//
//  Reactive_BaseViewController+Extension.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/20.
//

import UIKit

import RxCocoa
import RxSwift

extension Reactive where Base: UIViewController {
    
    var viewDidLoad: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewWillAppear)).map { _ in }
        return ControlEvent(events: source)
    }
    
    var viewWillAppear: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewWillAppear(_:))).map { _ in }
        return ControlEvent(events: source)
    }
    
    var viewDidAppear: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidAppear(_:))).map { _ in }
        return ControlEvent(events: source)
    }
    
    var viewWillDisappear: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewWillDisappear(_:))).map { _ in }
        return ControlEvent(events: source)
    }
    
    var viewDidDisappear: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidDisappear(_:))).map { _ in }
        return ControlEvent(events: source)
    }
    
}
