//
//  ChattingRepository.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/26.
//

import Foundation
import RealmSwift

import RxSwift

protocol ChattingRepository: AnyObject {
    
}

final class ChattingRepositoryImpi: ChattingRepository {
    
    private let localChatListRealm = try! Realm()
    // TODO: 의존성 추가
    private let chatAPIService: ChatAPIService = ChatAPIServiceImpi()
    
    
    
    
}

// realm Handling
private extension ChattingRepositoryImpi {
    
    func getLocalChatListRealmURL() {
        print("Realm is located at:", localChatListRealm.configuration.fileURL!)
    }
    
    func fetchLastChat(to: String) -> [ChatDTO] {
        let temp =  localChatListRealm.objects(ChattingRealm.self)
            .sorted(byKeyPath: "createdAt", ascending: true)
            .filter { $0.to == to }
            .map { realm in
                return ChatDTO(id: realm.id, to: realm.to, from: realm.from, chat: realm.chat, createdAt: realm.createdAt)
            } as Array
        return temp
    }
    
}

private extension ChattingRepositoryImpi {
    
    func fetchServerChatData(otherID: String, lastChatDate: String) -> Single<ChatDTO> {
        
        return Single<ChatDTO>.create { [weak self] emitter in
            self?.chatAPIService.getNewChatList(otherID: otherID, lastChatDate: lastChatDate, completionHandler: { result in
                
//                switch result {
//                case .success(let chatting):
//                    
//                case .failure(let error as APIError):
//                    
//                }
//            })
//            
            
            return Disposables.create()
        }
    }
    
}
