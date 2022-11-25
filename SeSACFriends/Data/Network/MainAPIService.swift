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
    func studyRequest(lat: Double, long: Double, studyList: String, completionHandler: @escaping (Result<QueueSuccessType, Error>) -> Void)
    func deleteStudyRequest( completionHandler: @escaping (Result<DeleteQueueSuccessType, Error>) -> Void)
    func getMyQueueState(completionHandler: @escaping (Result<MyQueueStateSendable, Error>) -> Void)

}

/// SUCCESS 이외에서는 새싹 찾기 불가 -> 스터디 입력화면 유지
@frozen enum QueueSuccessType: Int {
    case studyRequestSuccess = 200
    case over3Report = 201
    case cancelPenalty1Lv = 203
    case cancelPenalty2Lv = 204
    case cancelPenalty3Lv = 205
    
    var successDescription: String {
        switch self {
        case .studyRequestSuccess:
            return "QUEUE SUCCESS"
        case .over3Report:
            return "신고가 누적되어 이용하실 수 없습니다."
        case .cancelPenalty1Lv:
            return "스터디 취소 패널티로, 1분동안 이용하실 수 없습니다."
        case .cancelPenalty2Lv:
            return "스터디 취소 패널티로, 2분동안 이용하실 수 없습니다."
        case .cancelPenalty3Lv:
            return "스터디 취소 패널티로, 3분동안 이용하실 수 없습니다."
        }
    }
}

@frozen enum DeleteQueueSuccessType: Int {
    case deleteSuccess = 200
    
    /// 이미 매칭중인 상태 -> 채팅화면으로 이동
    case matchingStatus = 201
    
    var successDescription: String {
        switch self {
        case .matchingStatus:
            return "누군가와 스터디를 함께하기로 약속했어요!"
        default:
            return "NONE DESCRIPTION"
        }
    }
}



final class MainAPIServiceImpi: MainAPIService, CheckNetworkStatus {
    
    var monitor: NWPathMonitor?
    var isMonitoring: Bool = false
    var handleNetworkDisConnected: (() -> Void)?
    
    /// 스터디 입력 화면에서 스터디 조건 설정 후, ‘새싹 찾기’ 버튼 클릭시 호출
    func studyRequest(lat: Double, long: Double, studyList: String, completionHandler: @escaping (Result<QueueSuccessType, Error>) -> Void) {
        handleNetworkDisConnected = {
            completionHandler(.failure(APIError.notConnected))
        }
        startMonitering()
        
        let queue = Endpoint.queue
        let urlComponents = URLComponents(string: queue.url)
        let formData: [String: String] = [
            "lat":"\(lat)",
            "long":"\(long)",
            "studylist": "\"\(studyList)\""
        ]
        
        let formDataString = (formData.compactMap({ key, value in
            return "\(key)=\(value)"
        }) as Array).joined(separator: "&")
        
        let formEncodedData = formDataString.data(using: .utf8)
        
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
        
        let queue = Endpoint.queue
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
//        print(#function)
        handleNetworkDisConnected = {
            completionHandler(.failure(APIError.notConnected))
        }
//        startMonitering()
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
//            self?.stopMonitoring()
        }
        task.resume()
    }
    
    ///
    func getMyQueueState(completionHandler: @escaping (Result<MyQueueStateSendable, Error>) -> Void) {
//        print(#function)
        handleNetworkDisConnected = {
            completionHandler(.failure(APIError.notConnected))
        }
        startMonitering()
        let search = Endpoint.myQueueState
        let urlComponents = URLComponents(string: search.url)
        
        guard let url = urlComponents?.url ,let idToken = UserDefaults.idToken else { return }
        print(url)
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
                return
            }
            
            let jsonDecoder = JSONDecoder()
            guard let result = try? jsonDecoder.decode(MyQueueState.self, from: data) else {
                completionHandler(.failure(APIError.serverError))
                return }
            print("✅✅✅✅✅✅ getMyQueueState Done \(Date())")
            
            completionHandler(.success(MyQueueStateSendable(myQueueState: result, statusCode: 200)))
            self?.stopMonitoring()
        }
        task.resume()
    }
}

@frozen enum MyMatchingStatus: Int {
    /// 매칭 상태 확인 성공 -> MyQueueState 보내기
    case matchingSuccess = 200
    /// 새싹스터디 찾기를 요청하지 않는 일반상태
    case normalStatus = 201
}
