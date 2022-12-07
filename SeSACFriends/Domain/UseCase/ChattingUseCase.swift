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
    
    
}

final class ChattingUseCaseImpi: ChattingUseCase, CheckAndRefreshIDToken {
    
    private let webSocketIOManager = SocketIOManager.shared
    private let chatAPISevice: ChatAPIService
    private let mainAPIServce: MainAPIService
    
    
    
    init(chatAPIService: ChatAPIService, mainAPIService: MainAPIService) {
        self.chatAPISevice = chatAPIService
        self.mainAPIServce = mainAPIService
    }
    
    func websocketHandling() {
        webSocketIOManager.eventListen
            .subscribe(with: self) { uc, chat in
                
            }
    }
}
