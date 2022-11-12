//
//  APIService.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/10.
//

import Foundation

import RxSwift

protocol APIService {
    func getUser(completionHandler: @escaping (Result<UserInfo, Error>) -> Void)
    func postUser(nick: String, birth: String, email: String, gender: Int, completionHandler: @escaping (Result<Int, Error>) -> Void)
}

struct APIServiceImpi: APIService {
    
    func getUser(completionHandler: @escaping (Result<UserInfo, Error>) -> Void) {
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
        }
        task.resume()
    }//: getUser()
    
    
    func postUser(nick: String, birth: String, email: String, gender: Int, completionHandler: @escaping (Result<Int, Error>) -> Void) {
        let postUser = Endpoint.postUser
        
        var urlComponents = URLComponents(string: postUser.url)
        
//        guard let phoneNumber = UserDefaults.phoneNum, let fcmToken = UserDefaults.fcmToken else { return }
        
        let formData: [String: String] = [
//            "phoneNumber" : phoneNumber,
            "phoneNumber" : "+821027359012",
//            "FCMtoken" : fcmToken,
            "FCMtoken" : "dD3d-FVHkUdmrU5jIbigv6:APA91bHduYferz4CvD2wfcMxTqWcKHSEwMQCxnYARS-9604LA_Q-Je_YNXpW_LD32KimC2zFhJozzryqxm-5eo86HijL1LK9cIaKdgbl9uuT9AEN7nwxZVPiMeeWhX-6NqP2WTLObxPY",
            "nick" : nick,
            "birth" : birth,
            "email" : email,
            "gender" : "\(gender)"
        ]
        
        let formDataString = (formData.compactMap({ (key, value) -> String in
            return "\(key)=\(value)"
        }) as Array).joined(separator: "&")
        
        let formEncodedData = formDataString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)?.data(using: .utf8)
        
        guard let url = urlComponents?.url, let idToken = UserDefaults.idToken else { return }
        print(url)
        var request = URLRequest(url: url)
        request.addValue(HTTPHeader.encodedURL.value, forHTTPHeaderField: HTTPHeader.forHTTPHeaderField)
        request.addValue(idToken, forHTTPHeaderField: HTTPHeader.idToken)
//        request.addValue("eyJhbGciOiJSUzI1NiIsImtpZCI6ImQ3YjE5MTI0MGZjZmYzMDdkYzQ3NTg1OWEyYmUzNzgzZGMxYWY4OWYiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vc2VzYWMtMSIsImF1ZCI6InNlc2FjLTEiLCJhdXRoX3RpbWUiOjE2NjgyNzA2NjEsInVzZXJfaWQiOiJybWkxOE5KaFBITnVQQ2J6eG44Tmx3dnp0SkMzIiwic3ViIjoicm1pMThOSmhQSE51UENienhuOE5sd3Z6dEpDMyIsImlhdCI6MTY2ODI3MDY2MiwiZXhwIjoxNjY4Mjc0MjYyLCJwaG9uZV9udW1iZXIiOiIrODIxMDI3MzU5MDEyIiwiZmlyZWJhc2UiOnsiaWRlbnRpdGllcyI6eyJwaG9uZSI6WyIrODIxMDI3MzU5MDEyIl19LCJzaWduX2luX3Byb3ZpZGVyIjoicGhvbmUifX0.kvIbChrR52NdHGi_mteuvhj_QiKCZ7DzoAfo93xhIWGC33WtFfuGkfGwAEjDMeP78XTS3H2HJYyshzdCYdgTiaKoReg19tENZlvSohNe8R9AQP0dPJotnufiBZj3ttnQZ2MJb9m2RfLJBrayC3tFFicQxDhLAuYcCz9298iDkwXY34WSYtZCJDi3OhSiAnKVGpEtYc5JO44jYpUySa-sQka6PeEJj0XcmBIIMKU6hDP6M9hsuJy2vcjjHYzSqNUrij_sbWqaS-HDz99zMCQ9_gaNq4Lx4aDBbJH7jDnH8mp0JIQEKxhxZbAhcxw6wkPS0eNfYB_j_4apROZcK7QQGA", forHTTPHeaderField: HTTPHeader.idToken)
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
            print("✅✅✅✅✅✅ signUp Done")
            print(data)
            completionHandler(.success(200))
        }
        task.resume()
    }
}

