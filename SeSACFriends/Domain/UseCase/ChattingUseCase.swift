//
//  ChattingUseCase.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/26.
//

import Foundation

import RxSwift
import RxRelay

protocol ChattingUseCase: UseCase {
    var chatUpdate: PublishSubject<ChatDataSource> { get }
    
    func loadChat()
    func uploadMyChat(text: String)
    func disconnectSocket() 
}

final class ChattingUseCaseImpi: ChattingUseCase, CheckAndRefreshIDToken {
    
    private let webSocketIOManager = SocketIOManager.shared
    private let mainAPIServce: MainAPIService
    private let repository: ChattingRepository
    private let disposeBag = DisposeBag()
    private var otherID: String
    private var text: String = ""
    private var chatDataSource: ChatDataSource? {
        didSet {
            guard let chatDataSource else { return }
            chatUpdate.onNext(chatDataSource)
        }
    }
    
    let chatUpdate = PublishSubject<ChatDataSource>()
    
    init(mainAPIService: MainAPIService, repository: ChattingRepository, otherID: String) {
        self.mainAPIServce = mainAPIService
        self.repository = repository
        self.otherID = otherID
    }
    
    deinit {
        print("❌❌❌❌❌❌❌❌ ChattingUseCaseImpi deinit ❌❌❌❌❌❌❌❌❌")
    }
    
    /// Chat Page를 열때 기존 Chat Data + server에 요청해서 가져오는 함수
    /// page 열릴때 실행된다.
    func loadChat() {
        webSocketIOManager.establishConnection()
        repository.getChattingList(otherID: otherID)
            .subscribe(with: self) { uc, chatDTOs in
                let event = uc.transChatDTOToChatDataSource(chatDTOs: chatDTOs)
                uc.chatUpdate.onNext(event)
                uc.chatDataSource = event
            } onFailure: { uc, error in
                let error = error as? APIError
                uc.checkRefreshToken(errorCode: error?.rawValue ?? 500, task: uc.loadChat)
            }
            .disposed(by: disposeBag)
        websocketHandling()
    }
    
    /// 내가 채팅을 치면 동작하는 메서드
    func uploadMyChat(text: String) {
        self.text = text
        uploadMyChat2()
    }
    
    func disconnectSocket() {
        webSocketIOManager.closeConnection()
    }
}

private extension ChattingUseCaseImpi {
    
    func transferChatDTOToChatData(chatDTO: ChatDTO) -> ChatData {
        let messageType: MessageTypes = UserDefaults.myChatID == chatDTO.id ? .my : .your

        return ChatData(text: chatDTO.chat, nickName: chatDTO.from, messageType: messageType, date: chatDTO.createdAt)
    }
    
    func transChatDTOToChatDataSource(chatDTOs: [ChatDTO]) -> ChatDataSource {
        
        let chatDatas = chatDTOs.map { chatDTO in
            
            let messageType: MessageTypes = UserDefaults.myChatID == chatDTO.id ? .my : .your
            
            return ChatData(text: chatDTO.chat, nickName: chatDTO.from, messageType: messageType , date: chatDTO.createdAt)
        }
        
        let result = ChatDataSection(header: "", items: chatDatas)
        
        return [result]
    }
    
    func uploadMyChat2() {
        repository.postMyChat(text: self.text, otherID: otherID)
            .subscribe(with: self) { uc, chatDTO in
                let event = uc.transferChatDTOToChatData(chatDTO: chatDTO)
                uc.chatDataSource?[0].items.append(event)
                
            } onFailure: { uc, error in
                let error = error as? APIError
                uc.checkRefreshToken(errorCode: error?.rawValue ?? 500, task: uc.uploadMyChat2)
            }
            .disposed(by: disposeBag)
    }
    
    /// 웹 소켓에서 데이터 받아오면 localRealm에 저장하고, 채팅 리스트 갱신
    /// 웹 소켓 연결 시 실행되는 함수
    func websocketHandling() {
        webSocketIOManager.eventListen
            .subscribe(with: self) { [unowned self] uc, chat in
                // ChatDTO -> ChatDataSource
                let event = self.transChatDTOToChatDataSource(chatDTOs: self.repository.postSocketChat(chatData: chat))
                self.chatUpdate.onNext(event)
            }
            .disposed(by: disposeBag)
    }
    
}
