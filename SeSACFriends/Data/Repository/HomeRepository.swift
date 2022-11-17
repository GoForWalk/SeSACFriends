//
//  File.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/17.
//

import Foundation

import RxRelay
import RxSwift

protocol HomeRepository {
    func fetchMainMapAnnotation(lat: Double, long: Double) -> Single<[MapAnnotionUserDTO]>
}

final class HomeRespositoryImpi: HomeRepository, CheckAndRefreshIDToken {
    
    // TODO: 의존성 추가
    let mainAPIService: MainAPIService = MainAPIServiceImpi()
    
    func fetchMainMapAnnotation(lat: Double, long: Double) -> Single<[MapAnnotionUserDTO]> {
        
        return Single<[MapAnnotionUserDTO]>.create { emittor in
            
            self.mainAPIService.postSearch(lat: lat, long: long) { result in
                switch result {
                case .success(let searchUser):
                    let requests = searchUser.fromQueueDB
                    
                    let data = requests.map { request in
                        MapAnnotionUserDTO(lat: request.lat, long: request.long, gender: request.gender, type: request.type, sesac: request.sesac)
                    }
                    emittor(.success(data))
                    
                case .failure(let error as APIError):
                    print("😡😡😡😡 MapAnnotationError \( error.errorDescription)")
                    emittor(.failure(error))
            
                default:
                    return
                }
            }
            
            return Disposables.create()
        }
    }
    
    
}
