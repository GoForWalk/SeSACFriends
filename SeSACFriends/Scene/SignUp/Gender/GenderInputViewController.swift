//
//  GenderInputViewController.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/11.
//

import UIKit

import RxSwift
import RxCocoa

final class GenderInputViewController: BaseViewController {
    
    private let mainView = GenderInputView()
    private let disposeBag = DisposeBag()
    var viewModel: GenderInputViewModel?
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configure() {
        super.configure()
        mainView.genderPickCollectionView.delegate = self
        mainView.genderPickCollectionView.dataSource = self
        mainView.genderPickCollectionView.register(GenderCollectionViewCell.self, forCellWithReuseIdentifier: GenderCollectionViewCell.description())
        mainView.genderPickCollectionView.collectionViewLayout = setCellSize()
        mainView.genderPickCollectionView.backgroundColor = .white
    }
    
    override func bind() {
        
        let input = GenderInputViewModel.Input(
            genderTapped: mainView.genderPickCollectionView.rx.itemSelected,
            signUpButtonTapped: mainView.authButton.rx.tap
        )
        
        guard let output = viewModel?.transform(input: input, disposeBag: disposeBag) else { return }
        
        output.validation
            .asDriver(onErrorJustReturn: false)
            .drive { [weak self] bool in
                if bool {
                    self?.mainView.authButton.buttonMode = .fill
                } else {
                    self?.mainView.authButton.buttonMode = .disable
                }
            }
            .disposed(by: disposeBag)
        
        input.signUpButtonTapped
            .map { 0 }
            .withLatestFrom(output.signUpResult)
            .debug()
            .subscribe { [weak self] resultCode in
                if resultCode.element == 200 {
//                    self?.presentVC(presentType: <#T##PresentType#>, initViewController: <#T##() -> BaseViewController#>)
                    print("TabbBar View Present!!")
                } else if resultCode.element == 202 {
                    self?.moveToNickVC()
                } else {
                    self?.presentToast(message: APIError(rawValue: resultCode.element!)?.errorDescription ?? "기타 에러 [ERROR CODE: \(resultCode.element!)")
                }
            }
            .disposed(by: disposeBag)
    }
    
}

private extension GenderInputViewController {
    
    func setCellSize() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 16
        let numOfCell: CGFloat = 2
        let numOfSpace: CGFloat = numOfCell + 1

        let width = (UIScreen.main.bounds.width - (spacing * numOfSpace)) / numOfCell

        let height: CGFloat = 160
        
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.itemSize = CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        layout.scrollDirection = .horizontal
        return layout
    }
    
    func moveToNickVC() {
        guard let controllers = self.navigationController?.viewControllers else { return }
        for vc in controllers {
            if vc is NickInputViewController {
                _ = self.navigationController?.popToViewController(vc as! NickInputViewController, animated: true)
            }
        }
        
    }

}

extension GenderInputViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GenderInfo.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenderCollectionViewCell.description(), for: indexPath) as? GenderCollectionViewCell else { return UICollectionViewCell() }
        
        cell.setCell(indexPath: indexPath.item)
        cell.tag = indexPath.item
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? GenderCollectionViewCell {
            cell.contentView.backgroundColor = Colors.whiteGreen
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? GenderCollectionViewCell {
            cell.contentView.backgroundColor = Colors.white
        }

    }
}

@frozen enum GenderInfo: Int, CaseIterable {
    case male = 1
    case female = 0
}

extension GenderInfo {
    
    var image: UIImage {
        switch self {
        case .male:
            return Images.man.image
        case .female:
            return Images.woman.image
        }
    }
    
    var text: String {
        switch self {
        case .male:
            return "남자"
        case .female:
            return "여자"
        }
    }
    
}
