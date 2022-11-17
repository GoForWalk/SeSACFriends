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
    // TODO: 의존성 주입으로 변경
    var viewModel: HomeMainViewModel? = HomeMainViewModel()
    private let mapService = MapServiceImpi()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configure() {
        super.configure()
        setNavi()
    }
    
    override func bind() {
        let input = HomeMainViewModel.Input(
            mapCenterLocation: mapService.getMapCenterCoordinator(),
            setLocationButtonTapped: mainView.setLocationButton.rx.tap
        )
        
        guard let output = viewModel?.transform(input: input, disposeBag: disposeBag) else { return }
        
        output.buttonStatus
            .debug()
            .withUnretained(self)
            .bind(onNext: {
                $0.mainView.statusButton.setImage($1.buttonImage.image, for: .normal)
            })
            .disposed(by: disposeBag)
        
        output.mapCenterLocation
            .map { $0.coordinate }
            .bind(to: mainView.map.rx.centerCoordinate)
            .disposed(by: disposeBag)
        
        output.mapAnnotation
            .bind(with: self) { vc, mapAnnotations in
                vc.mapService.setAnnotion(locations: mapAnnotations)
            }
            .disposed(by: disposeBag)

        output.authError
            .bind(with: self) { vc, authArror in
                switch authArror {
                case .locationServiceOFF:
                    vc.presentToast(message: authArror.rawValue)
                case .authNotAllowed:
                    vc.showRequestLocationServiceAlert()
                }
            }
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
    
    func showRequestLocationServiceAlert() {
      let requestLocationServiceAlert = UIAlertController(title: "위치정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
      let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
        
          // 설정창으로 이동하는 코드
          // 설정까지 이동하거나 설정 세부화면까지 이동
          // 한 번도 설정 앱에 들어가지 않았거나, 막 다운받은 앱이거나...
          if let appSetting = URL(string: UIApplication.openSettingsURLString) {
              UIApplication.shared.open(appSetting)
          }
          
      }
      let cancel = UIAlertAction(title: "취소", style: .default)
      requestLocationServiceAlert.addAction(cancel)
      requestLocationServiceAlert.addAction(goSetting)
      
      present(requestLocationServiceAlert, animated: true, completion: nil)
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
