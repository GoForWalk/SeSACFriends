//
//  WebSocketService.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/12/02.
//

import Foundation

import SocketIO

final class SocketIOManager {
    
    static let shared = SocketIOManager()
    
    /// 서버와 메세지를 주고받기 위한 클래스
    var manager: SocketManager!
    
    /// 소켓 링크
    var socket: SocketIOClient!
    
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
        socket.on("sesac") { dataArray, ack in
            
            
            
        }
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
}
