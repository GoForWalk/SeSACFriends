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
    func getChattingList(otherID: String) -> Single<[ChatDTO]>
    func postMyChat(text: String, otherID: String) -> Single<ChatDTO>
}

final class ChattingRepositoryImpi: ChattingRepository {
    
    private let localChatListRealm = try! Realm()
    // TODO: 의존성 추가
    private let chatAPIService: ChatAPIService = ChatAPIServiceImpi()
    
    /// 채팅 처음 실행할때 목록 받아오기
    func getChattingList(otherID: String) -> Single<[ChatDTO]> {
        
        var localData = fetchLastChat(to: otherID)
        let lastDate = localData.last?.createdAt.dateToString(format: DateFormat.format) ?? "2000-01-01T00:00:00.000Z"
        if !localData.isEmpty {
            localData.removeLast()
        }
        
        return Single<[ChatDTO]>.create { [weak self] emitter in
            self?.chatAPIService.getNewChatList(otherID: otherID, lastChatDate: lastDate, completionHandler: { result in
                
                switch result {
                case .success(let chatting):
                    let temp = chatting.payload.map { data in
                        return ChatDTO(id: data.id, to: data.to, from: data.from, chat: data.chat, createdAt: data.createdAt.stringToDate(format: DateFormat.format) ?? Date())
                    }
                    self?.postMyChatToLocalRealm(chat: temp)
                    localData.append(contentsOf: temp)
                    emitter(.success(localData))
                    
                case .failure(let error as APIError):
                    emitter(.failure(error))
                default:
                    return
                }
            })
            return Disposables.create()
        }
    }//: getChattingList
    
    /// 내가 보내는 채팅 서버에 올리기, 결과 돌아오면 화면에 업데이트 해주기!!
    func postMyChat(text: String, otherID: String) -> Single<ChatDTO> {
        return Single<ChatDTO>.create {[weak self] emitter in
            
            self?.chatAPIService.postMyChat(otherID: otherID, chatText: text, completionHandler: { result in
                switch result {
                case .success(let chatData):
                    let chatDTO = ChatDTO(id: chatData.id, to: chatData.to, from: chatData.from, chat: chatData.chat, createdAt: chatData.createdAt.stringToDate(format: DateFormat.format) ?? Date())
                    self?.postMyChatToLocalRealm(chat: [chatDTO])
                    emitter(.success(chatDTO))
                case .failure(let error as APIError):
                    emitter(.failure(error))
                default:
                    return
                }
            })
            return Disposables.create()
        }
    }//: postMyChat
    
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
    
    func postMyChatToLocalRealm(chat: [ChatDTO]) {
        do {
            try localChatListRealm.write {
                chat.forEach { chat in
                    localChatListRealm.add(ChattingRealm(id: chat.id, to: chat.to, from: chat.from, chat: chat.chat, createdAt: chat.createdAt))
                }
            }
        } catch {
            print("🐨🐨🐨🐨 Realm save Failure")
        }
    }
    
}

