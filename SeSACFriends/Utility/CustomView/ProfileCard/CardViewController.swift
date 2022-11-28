//
//  CardViewController.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/15.
//

import UIKit

@objc protocol CardTableViewDelegateAndDataSource: AnyObject, UITableViewDelegate,  UITableViewDataSource {
    
}

class CardViewController: BaseViewController, CardTableViewDelegateAndDataSource {
    
    private let cardView = ProfileCardView()
    private let searchCardData: SearchCardDataDTO
    private var cardMode: CardViewDisplayView
    
    override func loadView() {
        view = cardView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCardView(cardMode: cardMode, data: searchCardData)
    }
    
    init(searchCardData: SearchCardDataDTO, cardMode: CardViewDisplayView) {
        self.searchCardData = searchCardData
        self.cardMode = cardMode
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(cardViewTable: UITableView?, cardMode: CardViewDisplayView) {
        self.init(searchCardData: SearchCardDataDTO(nick: "샘플새싹", reputation: [0,0,0,0,0,0], studyList: ["Swift"], reviews: [], sesac: 0, background: 0), cardMode: .mainMatchingRequesting)
        self.cardMode = cardMode
    }
        
    func setCardView() {
        let cardViewTable = cardView.profileView.tableView
        cardViewTable.delegate = self
        cardViewTable.dataSource = self
        cardViewTable.register(CardTitleTableCell.self, forCellReuseIdentifier: CardTitleTableCell.description())
        cardViewTable.register(CardReviewTableViewCell.self, forCellReuseIdentifier: CardReviewTableViewCell.description())
        cardViewTable.register(CardTableHeaderView.self, forHeaderFooterViewReuseIdentifier: CardTableHeaderView.description())
        cardViewTable.reloadData()
        cardViewTable.rowHeight = UITableView.automaticDimension
    }
}

private extension CardViewController {
    
    func setCardView(cardMode: CardViewDisplayView, data: SearchCardDataDTO) {
        setRequestButton(cardMode: cardMode)
        cardView.backgroundImageView.image = SeSACBackgoundImage(rawValue: data.background)?.image ?? Images.background1
        cardView.charactorImageView.image = SeSACCharactorImage(rawValue: data.sesac)?.image ?? Images.sesacFace1.image
        cardView.profileView.nameLabel.text = data.nick
        
    }
    
    func setRequestButton(cardMode: CardViewDisplayView) {
        switch cardMode {
        case .myProfile:
            cardView.requestButton.backgroundColor = Colors.error
        case .mainMatchingRequested:
            cardView.requestButton.backgroundColor = Colors.sucess
        case .mainMatchingRequesting:
            cardView.requestButton.isHidden = true
        }
    }
}

extension CardViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return CardViewSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CardTableHeaderView.description()) as? CardTableHeaderView else { return UIView() }
        header.translatesAutoresizingMaskIntoConstraints = false

        switch section {
        case CardViewSection.title.rawValue:
            header.setConfigure(text: CardViewSection.title.headerTitle, isButtonHidden: false)
            return header

        case CardViewSection.review.rawValue:
             header.setConfigure(text: CardViewSection.review.headerTitle, isButtonHidden: false)
            return header
        default:
            return UIView()
        }
    }

//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return CardViewSection.allCases[section].headerTitle
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case CardViewSection.title.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CardTitleTableCell.description()) as? CardTitleTableCell else { return UITableViewCell() }
            cell.updateButtonStatus(dataList: searchCardData.reputation)
            return cell
        case CardViewSection.review.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CardReviewTableViewCell.description()) as? CardReviewTableViewCell else { return UITableViewCell() }
            cell.reviewTextView.text = searchCardData.reviews.first ?? "등록된 리뷰가 없습니다."
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

@frozen enum CardViewDisplayView {
    case myProfile
    case mainMatchingRequested
    case mainMatchingRequesting
}
