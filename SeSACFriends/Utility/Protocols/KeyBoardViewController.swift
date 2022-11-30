//
//  KeyBoardDelegate.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/25.
//

import UIKit

protocol KeyboardDelegate {
    func keyboardShowUpdate(keyboardHeight: CGFloat)
    func keyboardHideUpdate(keyboardHeight: CGFloat)
}

class KeyboardViewController: BaseViewController, KeyboardDelegate {
    
    var restoreFrameValue: CGFloat = 0.0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyBoardNotification(vc: self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeKeyboardNotification(vc: self)
    }
    
    /// 키보드 노티피케이션을 추가하는 메서드
    func addKeyBoardNotification<T: UIViewController>(vc: T) {
        print(#function, self.description)
        NotificationCenter.default.addObserver(vc, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(vc, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /// 키보드 노티피케이션을 제거하는 메서드
    func removeKeyboardNotification<T: UIViewController>(vc: T) {
        print(#function, self.description)
        NotificationCenter.default.removeObserver(vc, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(vc, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        print("🥶🥶🥶🥶")
        print(#function, self.description)
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            let frameHeight = keyboardHeight
//            - (self.tabBarController?.tabBar.frame.size.height ?? 0) / 2
            var moveHeight = frameHeight
            
            if restoreFrameValue >= frameHeight { return }
            else if restoreFrameValue < frameHeight { moveHeight = frameHeight - restoreFrameValue }
            
            UIView.animate(withDuration: 0.3) { [unowned self] in
                self.keyboardShowUpdate(keyboardHeight: moveHeight)
            }
            setNewValue(frameHeight)
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        print("🥶🥶🥶🥶")
        print(#function, self.description)
        
        if self.view.frame.origin.y != restoreFrameValue {
            UIView.animate(withDuration: 0.5) { [unowned self] in
                print(self.view.frame.origin.y)
                print(self.view.layer.bounds.height)
                print(UIScreen.main.bounds.height)
//                self.view.frame.origin.y += self.restoreFrameValue
                self.keyboardHideUpdate(keyboardHeight: self.restoreFrameValue)
            }
            setNewValue(0)
        }
        
    }
    
    func setNewValue(_ frameHeight: CGFloat) {
        restoreFrameValue = frameHeight
        print(#function, restoreFrameValue)
    }
    
    func keyboardShowUpdate(keyboardHeight: CGFloat) { }
    
    func keyboardHideUpdate(keyboardHeight: CGFloat) { }
    
}
