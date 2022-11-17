//
//  MainAPIService.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/17.
//

import Foundation
import Network

protocol MainAPIService: AnyObject {
    func postSearch(lat: Double, long: Double, completionHandler: @escaping (Result<SearchUser, Error>) -> Void)
}

final class MainAPIServiceImpi: MainAPIService, CheckNetworkStatus {
    
    var monitor: NWPathMonitor?
    var isMonitoring: Bool = false
    var handleNetworkDisConnected: (() -> Void)?
    
    func search(completionHandler: @escaping (Result<UserInfo, Error>) -> Void) {
        handleNetworkDisConnected = {
            completionHandler(.failure(APIError.notConnected))
        }
        startMonitering()
        
        let search = Endpoint.search
        let urlComponents = URLComponents(string: search.url)
        
        guard let url = urlComponents?.url, let idToken = UserDefaults.idToken else { return }
        
        var request = URLRequest(url: url)
        request.addValue(HTTPHeader.encodedURL.value, forHTTPHeaderField: HTTPHeader.forHTTPHeaderField)
        request.addValue(idToken, forHTTPHeaderField: HTTPHeader.idToken)
        request.httpMethod = HTTPMethod.post.rawValue
        
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
    
    
    func postSearch(lat: Double, long: Double, completionHandler: @escaping (Result<SearchUser, Error>) -> Void) {
        handleNetworkDisConnected = {
            completionHandler(.failure(APIError.notConnected))
        }
        startMonitering()
        let search = Endpoint.search
        let urlComponents = URLComponents(string: search.url)
        let formData: [String: String] = [
            "lat":"\(lat)",
            "long":"\(long)"
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
            
            let jsonDecoder = JSONDecoder()
            guard let result = try? jsonDecoder.decode(SearchUser.self, from: data) else {
                completionHandler(.failure(APIError.serverError))
                return }
            print("✅✅✅✅✅✅ Search user Done")
            print(result)
            completionHandler(.success(result))
            self?.stopMonitoring()
        }
        task.resume()
    }
    
}

