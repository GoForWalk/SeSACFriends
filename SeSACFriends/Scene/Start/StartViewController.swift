//
//  StartViewController.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/13.
//

import UIKit

import SnapKit

class StartViewController: BaseViewController, CheckAndRefreshIDToken {

    var apiService: APIService?
        
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

        // Do any additional setup after loading the view.
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
            switch result {
            case .success(let userInfo):
//                presentVC(presentType: <#T##PresentType#>, initViewController: <#T##() -> BaseViewController#>)
                print("⭐️loginSuccess")
                dump(userInfo)
            case .failure(let error as APIError):
                guard let self else { return }
                
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


