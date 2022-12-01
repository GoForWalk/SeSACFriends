//
//  APIService.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/10.
//

import Foundation
import Network

final class UserAPIServiceImpi: UserAPIService, CheckNetworkStatus {
    
    var monitor: NWPathMonitor?
    var isMonitoring: Bool = false
    var handleNetworkDisConnected: (() -> Void)?
    
    func getUser(completionHandler: @escaping (Result<UserInfo, Error>) -> Void) {
        handleNetworkDisConnected = {
            completionHandler(.failure(APIError.notConnected))
        }
        startMonitering()
        let getUser = UserEndpoint.getUser
        let urlComponents = URLComponents(string: getUser.url)
        
        guard let url = urlComponents?.url, let idToken = UserDefaults.idToken else { return }
        
        var request = URLRequest(url: url)
        request.addValue(HTTPHeader.encodedURL.value, forHTTPHeaderField: HTTPHeader.forHTTPHeaderField)
        request.addValue(idToken, forHTTPHeaderField: HTTPHeader.idToken)
        request.httpMethod = HTTPMethod.get.rawValue
        
        let defaultSession = URLSession(configuration: .default)
        
        let task = defaultSession.dataTask(with: request) { [weak self] data, response, error in
            guard error == nil else {
                print("Error occur: error calling Get - \(String(describing: error))")
                completionHandler(.failure(APIError.serverError))
                return
            }
            
            guard let data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                let response = response as! HTTPURLResponse
                print("StatusCode Not 200, Now StatusCode:\(response.statusCode)")
                completionHandler(.failure(APIError(rawValue: response.statusCode) ?? .serverError))
                return
            }
            
            let decoder = JSONDecoder()
            
            guard let userInfo = try? decoder.decode(UserInfo.self, from: data) else { return }
            print("✅✅✅ Get userInfo")
            completionHandler(.success(userInfo))
            self?.stopMonitoring()
        }
        task.resume()
    }//: getUser()
    
    
    func postUser(nick: String, birth: String, email: String, gender: Int, completionHandler: @escaping (Result<Int, Error>) -> Void) {
        
        handleNetworkDisConnected = {
            completionHandler(.failure(APIError.notConnected))
        }
        startMonitering()
        
        let postUser = UserEndpoint.postUser
        let urlComponents = URLComponents(string: postUser.url)
        
        guard
            let phoneNumber = UserDefaults.phoneNum,
                let fcmToken = UserDefaults.fcmToken else { return }
        
        let formData: [String: String] = [
            "phoneNumber" : phoneNumber,
            "FCMtoken" : fcmToken,
            "nick" : nick,
            "birth" : birth,
            "email" : email,
            "gender" : "\(gender)"
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
        let task = defaultSession.dataTask(with: request) {[weak self] data, response, error in
            
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
            print("✅✅✅✅✅✅ signUp Done")
            print(data)
            completionHandler(.success(200))
            self?.stopMonitoring()
        }
        task.resume()
    }
    
    //    func withdrawUser() { }

}

