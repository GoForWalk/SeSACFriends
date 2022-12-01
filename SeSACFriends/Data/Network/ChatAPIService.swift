//
//  ChatAPIService.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/12/01.
//

import Foundation
import Network

protocol ChatAPIService {
    func postMyChat(otherID: String, chatText: String, completionHandler: @escaping (Result<Payload, Error>) -> Void)
    func getNewChatList(otherID: String, lastChatDate: String, completionHandler: @escaping (Result<Chatting, Error>) -> Void)
}

final class ChatAPIServiceImpi: ChatAPIService, CheckNetworkStatus {
    
    var monitor: NWPathMonitor?
    var isMonitoring: Bool = false
    var handleNetworkDisConnected: (() -> Void)?
    
    /// 채팅화면에서 채팅 전송 버튼 클릭시 호출
    func postMyChat(otherID: String, chatText: String, completionHandler: @escaping (Result<Payload, Error>) -> Void) {
        
        let chat = ChattingEndPont.postChat(otherID: otherID)
        let urlComponents = URLComponents(string: chat.url)
        let formData: [String: String] = [
            "chat": chatText
        ]
        
        let formDataString = (formData.compactMap({ (key, value) -> String in
            return "\(key)=\(value)"
        }) as Array).joined(separator: "&")
        
        let formEncodedData = formDataString.data(using: .utf8)
        
        guard let url = urlComponents?.url ,let idToken = UserDefaults.idToken else { return }
        print(url)
        var request = URLRequest(url: url)
        request.addValue(HTTPHeader.encodedURL.value, forHTTPHeaderField: HTTPHeader.forHTTPHeaderField)
        request.addValue(idToken, forHTTPHeaderField: HTTPHeader.idToken)
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = formEncodedData
        
        let defaultSession = URLSession(configuration: .default)
        let task = defaultSession.dataTask(with: request) { data, response, error in
            
            guard error == nil else {
                print("Error occur: error calling POST - \(String(describing: error))")
                completionHandler(.failure(APIError.serverError))
                return
            }
            
            guard let data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                let response = response as! HTTPURLResponse
                print("StatusCode Not 200, Now StatusCode:\(response.statusCode)")
                completionHandler(.failure(APIError(rawValue: response.statusCode) ?? .serverError))
                return
            }
            
            let jsonDecoder = JSONDecoder()
            guard let result = try? jsonDecoder.decode(Payload.self, from: data) else {
                completionHandler(.failure(APIError.serverError))
                return }
            print("✅✅✅✅✅✅ postMyChat Done \(Date())")
            completionHandler(.success(result))
        }
        task.resume()
    }//: postMyChat
    
    /// 채팅화면 입장시 호출
    /// 디바이스에 저장된 마지막 chat 데이터를 기준으로, 이후 시점의 chat 데이터를 요청
    func getNewChatList(otherID: String, lastChatDate: String, completionHandler: @escaping (Result<Chatting, Error>) -> Void) {
        
        let chat = ChattingEndPont.getChatList(otherID: otherID, lastChatDate: lastChatDate)
        let urlComponents = URLComponents(string: chat.url)

        guard let url = urlComponents?.url ,let idToken = UserDefaults.idToken else { return }
        print(url)
        var request = URLRequest(url: url)
        request.addValue(HTTPHeader.encodedURL.value, forHTTPHeaderField: HTTPHeader.forHTTPHeaderField)
        request.addValue(idToken, forHTTPHeaderField: HTTPHeader.idToken)
        request.httpMethod = HTTPMethod.get.rawValue
        
        let defaultSession = URLSession(configuration: .default)
        let task = defaultSession.dataTask(with: request) { data, response, error in
            
            guard error == nil else {
                print("Error occur: error calling POST - \(String(describing: error))")
                completionHandler(.failure(APIError.serverError))
                return
            }
            
            guard let data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                let response = response as! HTTPURLResponse
                print("StatusCode Not 200, Now StatusCode:\(response.statusCode)")
                completionHandler(.failure(APIError(rawValue: response.statusCode) ?? .serverError))
                return
            }
            
            let jsonDecoder = JSONDecoder()
            guard let result = try? jsonDecoder.decode(Chatting.self, from: data) else {
                completionHandler(.failure(APIError.serverError))
                return }
            print("✅✅✅✅✅✅ getNewChatList Done \(Date())")
            completionHandler(.success(result))
        }
        task.resume()
    }//: getNewChatList
        
    
    
}
