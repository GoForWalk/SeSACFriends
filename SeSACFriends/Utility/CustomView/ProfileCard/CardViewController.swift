//
//  CardViewController.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/15.
//

import UIKit

@objc protocol CardTableViewDelegateAndDataSource: AnyObject, UITableViewDelegate,  UITableViewDataSource {
    var cardViewTable: UITableView? { get set }
}

class CardViewController: BaseViewController, CardTableViewDelegateAndDataSource {
    
    var cardViewTable: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
        
    func setCardView() {
        self.cardViewTable?.delegate = self
        self.cardViewTable?.dataSource = self
        cardViewTable?.register(CardTitleTableCell.self, forCellReuseIdentifier: CardTitleTableCell.description())
        cardViewTable?.register(CardReviewTableViewCell.self, forCellReuseIdentifier: CardReviewTableViewCell.description())
        cardViewTable?.register(CardTableHeaderView.self, forHeaderFooterViewReuseIdentifier: CardTableHeaderView.description())
        cardViewTable?.reloadData()
        cardViewTable?.rowHeight = UITableView.automaticDimension
    }

}

extension CardViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CardTableHeaderView.description()) as? CardTableHeaderView else { return UIView() }
//        header.translatesAutoresizingMaskIntoConstraints = false
//
//        switch section {
//        case CardViewSection.title.rawValue:
//            header.setConfigure(text: CardViewSection.title.headerTitle, isButtonHidden: false)
//            return header
//
//        case CardViewSection.review.rawValue:
//             header.setConfigure(text: CardViewSection.review.headerTitle, isButtonHidden: false)
//            return header
//        default:
//            return UIView()
//        }
//    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return CardViewSection.allCases[section].headerTitle
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case CardViewSection.title.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CardTitleTableCell.description()) as? CardTitleTableCell else { return UITableViewCell() }
            
            return cell
        case CardViewSection.review.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CardReviewTableViewCell.description()) as? CardReviewTableViewCell else { return UITableViewCell() }
            
            return cell
        default:
            return UITableViewCell()
        }
        
    }
}

@frozen enum CardViewSection: Int, CaseIterable {
    case title
    case review
    
    var headerTitle: String {
        switch self {
        case .title:
            return "새싹 타이틀"
        case .review:
            return "새싹 리뷰"
        }
    }
}
