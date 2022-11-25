//
//  HomeViewController.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/14.
//

import UIKit

import RxCocoa
import RxSwift
import MapKit

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
        mapService.mapView = mainView.map
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavi()
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startMonitering()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopMonitoring()
    }
    
    override func configure() {
        super.configure()
    }
    
    override func bind() {
                
        let input = HomeMainViewModel.Input(
            mapCenterLocation: mapService.mapCenter,
            setLocationButtonTapped: mainView.setLocationButton.rx.tap,
            viewWillAppear: self.rx.viewWillAppear,
            viewDidDisappear: self.rx.viewDidDisappear,
            statusButtonTapped: mainView.statusButton.rx.tap,
            viewDidAppear: self.rx.viewDidAppear
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
            .bind(with: self, onNext: { vc, coordinate in
                vc.mapService.setMapCenter(center: coordinate)
            })
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

// MARK: - HomeViewController Private Function
extension HomeViewController {
    
    func setNavi() {
        navigationController?.isToolbarHidden = true
    }
    
    func showRequestLocationServiceAlert() {
      let requestLocationServiceAlert = UIAlertController(title: "위치정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
      let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
        
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
            presentVC(presentType: .push) { [weak self] in
                guard let useCase = self?.viewModel?.useCase else { return UIViewController() }
                return HomeWordSearchViewController(viewModel: HomeSearchWordViewModel(useCase: useCase))
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
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        print(#function)
    }

}

