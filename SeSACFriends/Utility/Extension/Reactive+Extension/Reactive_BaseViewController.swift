//
//  Reactive_BaseViewController.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/12/06.
//

import UIKit

import RxSwift
import RxCocoa

extension Reactive where Base: UITextViewDelegate {
    
    /// 편집이 시작될 때, 커서가 시작될 때
    var textViewDidBeginEditing: ControlEvent<Void> {
        let source =
        self.methodInvoked(#selector(Base.self.textViewDidBeginEditing)).map { _ in
        }
        return ControlEvent(events: source)
    }
    
    /// 편집이 끝났을 떄, 커서가 없어지는 순간
    var textViewDidEndEditing: ControlEvent<Void> {
        let source =
        self.methodInvoked(#selector(Base.self.textViewDidEndEditing)).map { _ in
        }
        return ControlEvent(events: source)
    }
    
}
