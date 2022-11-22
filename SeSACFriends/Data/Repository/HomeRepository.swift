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
    func fetchMainMapSearchWord(lat: Double, long: Double) -> Single<MapSearchWordDTO>
}

final class HomeRespositoryImpi: HomeRepository {
    
    // TODO: 의존성 추가
    let mainAPIService: MainAPIService = MainAPIServiceImpi()
    
    func fetchMainMapAnnotation(lat: Double, long: Double) -> Single<[MapAnnotionUserDTO]> {
        
        return Single<[MapAnnotionUserDTO]>.create { [weak self] emittor in
            
            self?.mainAPIService.postSearch(lat: lat, long: long) { result in
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
    
    func fetchMainMapSearchWord(lat: Double, long: Double) -> Single<MapSearchWordDTO> {
        
        return Single<MapSearchWordDTO>.create { [weak self] emittor in
            self?.mainAPIService.postSearch(lat: lat, long: long, completionHandler: { result in
                switch result {
                case .success(let searchUsers):
                    let recommend = searchUsers.fromRecommend
                    let fromqueue = searchUsers.fromQueueDB.map { fromQueueDB in
                        fromQueueDB.studylist
                    }
                    
                    let nearBy = Array(Set(fromqueue.flatMap { $0 }))
                    
                    emittor(.success(MapSearchWordDTO(nearByWord: nearBy, recommandWord: recommend)))
                    
                case .failure(let error as APIError):
                    print("😡😡😡😡 MapWordError \( error.errorDescription)")
                    emittor(.failure(error))
            
                default:
                    return
                }
                
            })
            return Disposables.create()
        }
        
    }
    
}
