//
//  APIService.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/10.
//

import Foundation
import RxSwift

protocol APIService {
//    func getUser() -> Single<UserInfo>
        func getUser(completionHandler: @escaping (Result<UserInfo, Error>) -> Void)
}

struct APIServiceImpi: APIService {
    
    func getUser(completionHandler: @escaping (Result<UserInfo, Error>) -> Void) {
//            func getUser() -> Single<UserInfo> {
//                return Single<UserInfo>.create { single in
        
        let getUser = Endpoint.getUser
        let urlComponents = URLComponents(string: getUser.url)
        
        guard let url = urlComponents?.url, let idToken = UserDefaults.idToken else { return }
        
        var request = URLRequest(url: url)
        
        request.addValue(HTTPHeader.encodedURL.value, forHTTPHeaderField: HTTPHeader.forHTTPHeaderField)
        request.addValue(idToken, forHTTPHeaderField: HTTPHeader.idToken)
        request.httpMethod = HTTPMethod.get.rawValue
        
        let defaultSession = URLSession(configuration: .default)
        
        let task = defaultSession.dataTask(with: request) { data, response, error in
            
            guard error == nil else {
                print("Error occur: error calling Get - \(String(describing: error))")
//                                    single((APIError.serverError))
                completionHandler(.failure(APIError.serverError))
                return
            }
            
            guard let data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                let response = response as! HTTPURLResponse
                print("StatusCode Not 200, Now StatusCode:\(response.statusCode)")
//                                    single(.failure(APIError(rawValue: response.statusCode) ?? .serverError))
                completionHandler(.failure(APIError(rawValue: response.statusCode) ?? .serverError))
                return
            }
            
            let decoder = JSONDecoder()
            
            guard let userInfo = try? decoder.decode(UserInfo.self, from: data) else { return }
            print("✅✅✅ Get userInfo")
//                            single(.success(userInfo))
            completionHandler(.success(userInfo))
        }
        
        task.resume()
        
        
//                    return Disposables.create()
                
        
        
    }//: getUser()
    
    
//    func postUser(nick: String, birth: String, email: String, gender: Int) -> Single<String> {
//
//        return Single<String>.create { single in
//
//            let postUser = Endpoint.postUser
//
//            var urlComponents = URLComponents(string: postUser.url)
//
//            urlComponents?.queryItems = [
//                URLQueryItem(name: "phoneNumber", value: UserDefaults.phoneNum),
//                URLQueryItem(name: "FCMtoken", value: UserDefaults.fcmToken),
//                URLQueryItem(name: "nick", value: nick),
//                URLQueryItem(name: "birth", value: birth),
//                URLQueryItem(name: "email", value: email),
//                URLQueryItem(name: "gender", value: "\(gender)")
//            ]
//
//            guard let url = urlComponents?.url else { return }
//
//            var request = URLRequest(url: url)
//            request.addValue(HTTPHeader.forHTTPHeaderField, forHTTPHeaderField: HTTPHeader.encodedURL.value)
//            request.addValue(HTTPHeader.idToken, forHTTPHeaderField: UserDefaults.idToken)
//
//            request.httpMethod = HTTPMethod.post.rawValue
//
//            let defaultSession = URLSession(configuration: .default)
//
//            let task = defaultSession.dataTask(with: request) { data, response, error in
//
//                guard error == nil else {
//                    print("Error occur: error calling POST - \(String(describing: error))")
//                    single(.failure(APIError.serverError))
//                }
//
//                guard let data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//                    let response = response as! HTTPURLResponse
//                    print("StatusCode Not 200, Now StatusCode:\(response.statusCode)")
//                    single(.failure(APIError(rawValue: response.statusCode)))
//                    return
//                }
//            }
//
//            task.resume()
//
//            return Disposables.create {
//                task.cancel()
//            }
//        }
//
//    }
}

