//
//  MainAPIService.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/17.
//

import Foundation
import Network

final class MainAPIServiceImpi: MainAPIService, CheckNetworkStatus {
    
    var monitor: NWPathMonitor?
    var isMonitoring: Bool = false
    var handleNetworkDisConnected: (() -> Void)?
    
    /// 스터디 입력 화면에서 스터디 조건 설정 후, ‘새싹 찾기’ 버튼 클릭시 호출
    func studyRequest(lat: Double, long: Double, studyList: [String], completionHandler: @escaping (Result<QueueSuccessType, Error>) -> Void) {
        handleNetworkDisConnected = {
            completionHandler(.failure(APIError.notConnected))
        }
        startMonitering()
        print(studyList)
        let queue = MainEndpoint.queue
        let urlComponents = URLComponents(string: queue.url)
        let formData: [String: String] = [
            "lat":"\(lat)",
            "long":"\(long)",
//            "studylist": studyList
        ]
        
        let formDataString = (formData.compactMap({ key, value in
            return "\(key)=\(value)"
        }) as Array).joined(separator: "&").appending(changeListToSendableString(key: "studylist", strings: studyList))
        
        let formEncodedData = formDataString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)?.data(using: .utf8)
        
        guard let url = urlComponents?.url, let idToken = UserDefaults.idToken else { return }
        
        var request = URLRequest(url: url)
        request.addValue(HTTPHeader.encodedURL.value, forHTTPHeaderField: HTTPHeader.forHTTPHeaderField)
        request.addValue(idToken, forHTTPHeaderField: HTTPHeader.idToken)
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = formEncodedData
        
        let defaultSession = URLSession(configuration: .default)
        
        let task = defaultSession.dataTask(with: request) { [weak self] _, response, error in
            guard error == nil else {
                print("Error occur: error calling Get - \(String(describing: error))")
                completionHandler(.failure(APIError.serverError))
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...300).contains(response.statusCode) else {
                let response = response as! HTTPURLResponse
                print("StatusCode Not 200, Now StatusCode:\(response.statusCode)")
                completionHandler(.failure(APIError(rawValue: response.statusCode) ?? .serverError))
                return
            }
            print("✅✅✅ studyRequest Success")
            completionHandler(.success(QueueSuccessType(rawValue: response.statusCode)!))
            self?.stopMonitoring()
        }
        task.resume()
    }//: studyRequest()
    
    /// 새싹 찾기 화면에서 찾기중단 버튼 클릭 시 호출
    func deleteStudyRequest( completionHandler: @escaping (Result<DeleteQueueSuccessType, Error>) -> Void) {
        handleNetworkDisConnected = {
            completionHandler(.failure(APIError.notConnected))
        }
        startMonitering()
        
        let queue = MainEndpoint.queue
        let urlComponents = URLComponents(string: queue.url)
        
        guard let url = urlComponents?.url, let idToken = UserDefaults.idToken else { return }
        
        var request = URLRequest(url: url)
        request.addValue(HTTPHeader.encodedURL.value, forHTTPHeaderField: HTTPHeader.forHTTPHeaderField)
        request.addValue(idToken, forHTTPHeaderField: HTTPHeader.idToken)
        request.httpMethod = HTTPMethod.delete.rawValue
        
        let defaultSession = URLSession(configuration: .default)
        
        let task = defaultSession.dataTask(with: request) { [weak self] _, response, error in
            guard error == nil else {
                print("Error occur: error calling Get - \(String(describing: error))")
                completionHandler(.failure(APIError.serverError))
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...300).contains(response.statusCode) else {
                let response = response as! HTTPURLResponse
                print("StatusCode Not 200, Now StatusCode:\(response.statusCode)")
                completionHandler(.failure(APIError(rawValue: response.statusCode) ?? .serverError))
                return
            }
            print("✅✅✅ studyRequest Success")
            completionHandler(.success(DeleteQueueSuccessType(rawValue: response.statusCode)!))
            self?.stopMonitoring()
        }
        task.resume()
    }//: DeleteStudyRequest()

    
    func postSearch(lat: Double, long: Double, completionHandler: @escaping (Result<SearchUser, Error>) -> Void) {
        
        handleNetworkDisConnected = {
            completionHandler(.failure(APIError.notConnected))
        }
//        startMonitering()
        let search = MainEndpoint.search
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
            guard let result = try? jsonDecoder.decode(SearchUser.self, from: data) else {
                completionHandler(.failure(APIError.serverError))
                return }
            print("✅✅✅✅✅✅ Search user Done \(Date())")
            print(result.fromQueueDB.count)
            completionHandler(.success(result))
        }
        task.resume()
    }
    
    ///
    func getMyQueueState(completionHandler: @escaping (Result<MyQueueStateSendable, Error>) -> Void) {
        handleNetworkDisConnected = {
            completionHandler(.failure(APIError.notConnected))
        }
        startMonitering()
        let search = MainEndpoint.myQueueState
        let urlComponents = URLComponents(string: search.url)
        
        guard let url = urlComponents?.url ,let idToken = UserDefaults.idToken else { return }
        var request = URLRequest(url: url)
        request.addValue(HTTPHeader.encodedURL.value, forHTTPHeaderField: HTTPHeader.forHTTPHeaderField)
        request.addValue(idToken, forHTTPHeaderField: HTTPHeader.idToken)
        request.httpMethod = HTTPMethod.get.rawValue
        
        let defaultSession = URLSession(configuration: .default)
        let task = defaultSession.dataTask(with: request) { [weak self] data, response, error in
            
            guard error == nil else {
                print("Error occur: error calling POST - \(String(describing: error))")
                completionHandler(.failure(APIError.serverError))
                return
            }
            
            guard let data, let response = response as? HTTPURLResponse, (200...300).contains(response.statusCode) else {
                let response = response as! HTTPURLResponse
                print("StatusCode Not 200, Now StatusCode:\(response.statusCode)")
                completionHandler(.failure(APIError(rawValue: response.statusCode) ?? .serverError))
                return
            }
            if response.statusCode == 201 {
                let temp = MyQueueStateSendable(myQueueState: nil, statusCode: 201)
                completionHandler(.success(temp))
                print("✅✅✅✅✅✅ getMyQueueState Done \(Date())")
                return
            }
            
            let jsonDecoder = JSONDecoder()
            guard let result = try? jsonDecoder.decode(MyQueueState.self, from: data) else {
                completionHandler(.failure(APIError.serverError))
                return }
            print("✅✅✅✅✅✅ getMyQueueState Done \(Date()), \(result)")
            
            completionHandler(.success(MyQueueStateSendable(myQueueState: result, statusCode: 200)))
            self?.stopMonitoring()
        }
        task.resume()
    }
    
    /// 스터디 요청하는 request
    /// 요청 바디: 스터디를 요청할 상대방 uid
    func postStudyRequest(otherID: String, completionHandler: @escaping (Result<StudyRequestSuccessStatusCodeType, Error>) -> Void) {
        handleNetworkDisConnected = {
            completionHandler(.failure(APIError.notConnected))
        }
        startMonitering()
        let search = MainEndpoint.studyRequest
        let urlComponents = URLComponents(string: search.url)
        let formData: [String: String] = [
            "otheruid":"\(otherID)"
        ]
        
        let formDataString = (formData.compactMap({ (key, value) -> String in
            return "\(key)=\(value)"
        }) as Array).joined(separator: "&")
        
        let formEncodedData = formDataString.data(using: .utf8)
        
        guard let url = urlComponents?.url ,let idToken = UserDefaults.idToken else { return }
        var request = URLRequest(url: url)
        request.addValue(HTTPHeader.encodedURL.value, forHTTPHeaderField: HTTPHeader.forHTTPHeaderField)
        request.addValue(idToken, forHTTPHeaderField: HTTPHeader.idToken)
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = formEncodedData
        
        let defaultSession = URLSession(configuration: .default)
        let task = defaultSession.dataTask(with: request) { [weak self] data, response, error in
            
            guard error == nil else {
                print("Error occur: error calling POST - \(String(describing: error))")
                completionHandler(.failure(APIError.serverError))
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...300).contains(response.statusCode) else {
                let response = response as! HTTPURLResponse
                print("StatusCode Not 200, Now StatusCode:\(response.statusCode)")
                completionHandler(.failure(APIError(rawValue: response.statusCode) ?? .serverError))
                return
            }

            completionHandler(.success(StudyRequestSuccessStatusCodeType(rawValue: response.statusCode) ?? .success))
            print("✅✅✅✅✅✅ postStudyRequest Done \(Date())")

            self?.stopMonitoring()
        }
        task.resume()
    }
    
    func postStudyAccept(otherID: String, completionHandler: @escaping (Result<StudyAcceptStatusCodeType, Error>) -> Void) {
        handleNetworkDisConnected = {
            completionHandler(.failure(APIError.notConnected))
        }
        startMonitering()
        let search = MainEndpoint.studyAccept
        let urlComponents = URLComponents(string: search.url)
        let formData: [String: String] = [
            "otheruid":"\(otherID)"
        ]
        
        let formDataString = (formData.compactMap({ (key, value) -> String in
            return "\(key)=\(value)"
        }) as Array).joined(separator: "&")
        
        let formEncodedData = formDataString.data(using: .utf8)
        
        guard let url = urlComponents?.url ,let idToken = UserDefaults.idToken else { return }
        var request = URLRequest(url: url)
        request.addValue(HTTPHeader.encodedURL.value, forHTTPHeaderField: HTTPHeader.forHTTPHeaderField)
        request.addValue(idToken, forHTTPHeaderField: HTTPHeader.idToken)
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = formEncodedData
        
        let defaultSession = URLSession(configuration: .default)
        let task = defaultSession.dataTask(with: request) { [weak self] data, response, error in
            
            guard error == nil else {
                print("Error occur: error calling POST - \(String(describing: error))")
                completionHandler(.failure(APIError.serverError))
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...300).contains(response.statusCode) else {
                let response = response as! HTTPURLResponse
                print("StatusCode Not 200, Now StatusCode:\(response.statusCode)")
                completionHandler(.failure(APIError(rawValue: response.statusCode) ?? .serverError))
                return
            }

            completionHandler(.success(StudyAcceptStatusCodeType(rawValue: response.statusCode) ?? .success))
            print("✅✅✅✅✅✅ postStudyAccept Done \(Date())")

            self?.stopMonitoring()
        }
        task.resume()
    }
    
}

private extension MainAPIServiceImpi {
    
    func changeListToSendableString(key: String, strings: [String]) -> String {
        
        let result = strings.reduce("") { partialResult, string in
            return "\(partialResult)&\(key)=\(string)"
        }
        return result
    }
}

struct NetworkRequestFrom {
    let urlStr: String
    /// idToken과 encode 방식에 대한 내용은 이미 들어가있다.
    let httpHeaders: [String: String]?
    let requestMethod: HTTPMethod
    let requestBody: [String: String]?
}

//class NetworkRequest: CheckNetworkStatus, CheckAndRefreshIDToken {
//
//    var monitor: NWPathMonitor?
//    var isMonitoring: Bool = false
//    var handleNetworkDisConnected: (() -> Void)?
//
//    func setRequest(router: NetworkRequestFrom) {
//
//        guard let url = URL(string: router.urlStr), let idToken = UserDefaults.idToken else { return }
//        var request = URLRequest(url: url)
//
//        if let headers = router.httpHeaders {
//            headers.forEach { key, value in
//                request.addValue(value, forHTTPHeaderField: key)
//            }
//        }
//        request.addValue(HTTPHeader.encodedURL.value, forHTTPHeaderField: HTTPHeader.forHTTPHeaderField)
//        request.addValue(idToken, forHTTPHeaderField: HTTPHeader.idToken)
//        request.httpMethod = router.requestMethod.rawValue
//
//        if let body = router.requestBody {
//            let formDataString = (body.compactMap({ (key, value) -> String in
//                return "\(key)=\(value)"
//            }) as Array).joined(separator: "&")
//
//            request.httpBody = formDataString.data(using: .utf8)
//        }
//
//    }//: setRequest
//
//    func encode<T>(isNetworkMonitoring: Bool = true, completionHandler: @escaping(Result<T, Error>) -> Void){
//        handleNetworkDisConnected = {
//            completionHandler(.failure(APIError.notConnected))
//        }
//        if isNetworkMonitoring {
//            startMonitering()
//        }
//
//        let defaultSession = URLSession(configuration: .default)
//        let task = defaultSession.dataTask(with: <#T##URLRequest#>, completionHandler: <#T##(Data?, URLResponse?, Error?) -> Void#>)
//    }
//
//}
