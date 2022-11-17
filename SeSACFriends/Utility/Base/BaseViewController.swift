//
//  BaseViewController.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/07.
//

import UIKit
import Toast
import Network

class BaseViewController: UIViewController, CheckNetworkStatus {
//class BaseViewController: UIViewController {
    
    var monitor: NWPathMonitor?
    var isMonitoring: Bool = false
    var handleNetworkDisConnected: (() -> Void)?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        handleNetworkDisConnected = { [weak self] in
            self?.presentToast(message: "네트워크 연결이 원활하지 않습니다.")
        }
        startMonitering()
        configure()
        bind()
    }
    
    func configure() {
        view.backgroundColor = Colors.white
    }
    
    func bind() {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        stopMonitoring()
    }
    
    deinit {
        stopMonitoring()
        print("❌❌❌❌❌❌❌❌❌ \(self.description) ❌❌❌❌❌❌❌❌❌")
    }
    
}

extension BaseViewController {
    
    // Toast View
    func presentToast(message: String) {
        DispatchQueue.main.async {
            self.view.makeToast(message, duration: 1.5, position: .center)
        }
        
    }
    
    // present View
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
            
            case .makeNewView:
                self.makeNewView(vc: initViewController())
                
            case .presentNewNavi:
                let nav = UINavigationController(rootViewController: initViewController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            }

        }
    }
}

private extension BaseViewController {
    
    func makeNewView(vc: UIViewController) {
        // iOS13+ SceneDelegate를 쓸 때 동작하는 코드
        // 앱을 처음 실행하는 것 처럼 동작하게 한다.
        // SceneDelegate 밖에서 window에 접근하는 방법
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        // 생명주기 담당
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        // window에 접근
        sceneDelegate?.window?.rootViewController = vc
        sceneDelegate?.window?.makeKeyAndVisible()
    }
    
}

@frozen enum PresentType {
    
    case presentNewNavi
    case push
    case over
    case makeNewView
    
}
