//
//  WebSocketService.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/12/02.
//

import Foundation

import SocketIO
import RxSwift
import RxRelay

final class SocketIOManager {
    
    static let shared = SocketIOManager()
    
    /// 서버와 메세지를 주고받기 위한 클래스
    private var manager: SocketManager!
    
    /// 소켓 링크
    private var socket: SocketIOClient!
    
    var eventListen = PublishSubject<ChatDTO>()
    
    private init() {
        // SocketManager 초기화
        manager = SocketManager(socketURL: URL(string: SFURL.baseURL)! , config: [.forceWebsockets(true)])
        
        socket = manager.defaultSocket
        
        // 연결
        socket.on(clientEvent: .connect) { data, ack in
            print("SOCKET IS CONNECTED", data, ack)
            self.socket.emit("changesocketid", UserDefaults.myChatID)
        }
        
        // 연결 해제
        socket.on(clientEvent: .disconnect) { data, ark in
            print("SOCKET IS DISCONNECTED", data, ark)
        }
        
        // 이벤트 수신
        socket.on("sesac") { [weak self] dataArray, ack in
            print("SESAC RECEIVED", dataArray, ack)
            
            guard let data = dataArray.first as? NSDictionary,
                  let id = data["_id"] as? String,
                  let chat = data["chat"] as? String,
                  let from = data["from"] as? String,
                  let to = data["to"] as? String,
                  let date = data["createdAt"] as? String,
                  let createdAt = date.stringToDate(format: DateFormat.format) else { return }
            
            self?.eventListen.onNext(ChatDTO(id: id, to: to, from: from, chat: chat, createdAt: createdAt))
        }
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
}
