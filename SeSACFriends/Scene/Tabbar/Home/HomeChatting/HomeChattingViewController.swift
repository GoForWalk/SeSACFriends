//
//  HomeChattingViewController.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/12/01.
//

import UIKit

import RxCocoa
import RxSwift
import Differentiator
import RxDataSources

final class HomeChattingViewController: KeyboardViewController {
    
    private let mainView = HomeChattingView()
    private let disposeBag = DisposeBag()
    private let placeholderText = "메세지를 입력하세요"
    
    let viewModel: HomeChattingViewModel
    
    let dataSource = RxTableViewSectionedAnimatedDataSource<ChatDataSection> { dataSource, tableView, indexPath, item in
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FirstChatTableViewCell.self), for: indexPath) as? FirstChatTableViewCell else { return  UITableViewCell() }
            
            return cell
        }
        
        switch item.messageType {
        case .my:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(MyChatTableViewCell.self), for: indexPath) as? MyChatTableViewCell else { return  UITableViewCell() }
            cell.setMessageText(text: item.text, time: item.date.dateToString(format: DateFormat.chatTime))
            return cell
            
        case .your:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(YourChatTableViewCell.self), for: indexPath) as? YourChatTableViewCell else { return  UITableViewCell() }
            
            return cell
        }
        
    }
    
    init(viewModel: HomeChattingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configure() {
        super.configure()
        setNavi()
        mainView.chatTableView.register(FirstChatTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(FirstChatTableViewCell.self))
        mainView.chatTableView.register(YourChatTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(YourChatTableViewCell.self))
        mainView.chatTableView.register(MyChatTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(MyChatTableViewCell.self))
    }
    
    override func bind() {
        
        let input = HomeChattingViewModel.Input(
            text: mainView.textField.rx.text,
            postButton: mainView.button.rx.tap,
            viewWillAppear: self.rx.viewWillAppear,
            viewDidDisappear: self.rx.viewDidDisappear
        )
        
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        
        mainView.textField.rx.didBeginEditing
            .subscribe(with: self) { vc, _ in
                vc.removePlaceHolder()
            }
            .disposed(by: disposeBag)
        
        mainView.textField.rx.didEndEditing
            .subscribe(with: self) { vc, _ in
                vc.setPlaceHolder()
            }
            .disposed(by: disposeBag)
        
        // TODO: 추가 띄우기
//        navigationItem.rightBarButtonItem?.rx.tap
        
    }
    
}

private extension HomeChattingViewController {
    
    func setPlaceHolder() {
        let textView = mainView.textField
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = Colors.gray7
        }
    }
    
    func removePlaceHolder() {
        let textView = mainView.textField
        if textView.textColor == Colors.gray7 {
            textView.text = nil
            textView.textColor = Colors.black
        }
    }
    
    func switchButton(text: String) {
        if mainView.textField.textColor == Colors.black {
            mainView.changeTextButton(isTexton: text.isEmpty)
        }
    }
    
    func setNavi() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Images.more.image, style: .plain, target: self, action: nil)
    }
}

@frozen enum MessageTypes {
    case my
    case your
//    case first
}

struct ChatData: Hashable {
    var text: String
    var nickName: String
    var messageType: MessageTypes
    var date: Date
}

extension ChatData: IdentifiableType, Equatable {
    var identity: String {
        return UUID().uuidString
    }
}

struct ChatDataSection {
    var header: String
    var items: [Item]
}

extension ChatDataSection: AnimatableSectionModelType {
    typealias Item = ChatData
    
    var identity: String {
        return header
    }
    
    init(original: ChatDataSection, items: [ChatData]) {
        self = original
        self.items = items
    }
}

typealias ChatDataSource = [ChatDataSection]
