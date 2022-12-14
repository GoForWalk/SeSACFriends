//
//  StartViewController.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/13.
//

import UIKit

import SnapKit
import FirebaseCore
import FirebaseMessaging

class StartViewController: BaseViewController, CheckAndRefreshIDToken {

    var apiService: UserAPIService?
        
    let mainImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = Images.splashLogo
        imageView.contentMode = .scaleAspectFit
        imageView.semanticContentAttribute = .unspecified
        return imageView
    }()
    
    let textImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.logoText
        imageView.contentMode = .scaleAspectFit
        imageView.semanticContentAttribute = .unspecified
         return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configure() {
        super.configure()
        
        [mainImageView, textImageView].forEach {
            view.addSubview($0)
        }
        
        mainImageView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(78.5)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(219)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(333)
        }
        
        textImageView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(41.5)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(197)
            make.top.equalTo(mainImageView.snp.bottom).offset(35.5)
        }
        
    }
    
    override func bind() {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        setRemoteAlert()
        takeFCMToken()
        setView()
    }
    
    private func setView() {
        guard UserDefaults.idToken != nil else {
            presentVC(presentType: .presentNewNavi) {
                return PhoneAuthViewController()
            }
            return
        }
        apiService?.getUser(completionHandler: { [weak self] result in
            self?.decideDestination(result: result)
        })
    }
    
    private func decideDestination(result: Result<UserInfo, Error>) {
        guard let apiService else { return }

        apiService.getUser { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let userInfo):
                self.presentVC(presentType: .makeNewView) {
                    return TabbarController()
                }
                print("??????loginSuccess")
                dump(userInfo)
            case .failure(let error as APIError):
                self.selectDestination(errorCode: self.checkRefreshToken(errorCode: error.rawValue, task: self.setView) )
            default:
                return
            }
        }
    }
    
    private func selectDestination(errorCode: Int) {
        if errorCode == 406 {
            presentVC(presentType: .presentNewNavi) {
                let vc = NickInputViewController()
                vc.viewModel = NickInputViewModel(useCase: SignInUseCaseImpi())
                return vc
            }
        } else if errorCode == 800 {
            DispatchQueue.main.async { [weak self] in
                self?.presentToast(message: APIError(rawValue: 800)?.errorDescription ?? "")
            }
        } else {
            print(APIError(rawValue: errorCode))
        }
    }
}

extension StartViewController: UNUserNotificationCenterDelegate {
    
    func setRemoteAlert() {
        
        let application = UIApplication.shared
        
        // ?????? ?????? ??????
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
          )
        } else {
          let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()

    }
    
    // Token ????????? ?????? ??????
    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      Messaging.messaging().apnsToken = deviceToken
    }

}

// MARK: - Message Delegate ??????
extension StartViewController: MessagingDelegate {
    
    // ?????? ?????? ?????? ??????
    // token??? ???????????? ????????? ??????,
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        print("FCM registration token: \(String(describing: fcmToken))")
        UserDefaults.fcmToken = fcmToken
        
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
          name: Notification.Name("FCMToken"),
          object: nil,
          userInfo: dataDict
        )
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    func takeFCMToken() {

        // ?????? ????????? Push Token ????????????
        Messaging.messaging().token { token, error in
          if let error = error {
            print("Error fetching FCM registration token: \(error)")
          } else if let token = token {
              UserDefaults.fcmToken = token
              print("FCM registration token: \(token)")
          }
        }
    }

    
}
