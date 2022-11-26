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
    func postQueueStudy(lat: Double, long: Double, studyList: String) -> Single<QueueSuccessType>
    func deleteQueueStudy() -> Single<DeleteQueueSuccessType>
    func fetchMyQueueStatus() -> Single<HomeStatus>
    func fetchCardData(lat: Double, long: Double) -> Single<SearchCardDatasDTO>

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
    }//: fetchMainMapAnnotation
    
    func fetchMainMapSearchWord(lat: Double, long: Double) -> Single<MapSearchWordDTO> {
        print(#function)
        return Single<MapSearchWordDTO>.create { [weak self] emittor in
            self?.mainAPIService.postSearch(lat: lat, long: long, completionHandler: { result in
                switch result {
                case .success(let searchUsers):
                    let recommend = searchUsers.fromRecommend
                    var fromqueue = searchUsers.fromQueueDB.map { fromQueueDB in
                        fromQueueDB.studylist
                    }
                    
                    fromqueue.append(contentsOf: searchUsers.fromQueueDBRequested.map { fromQueueDB in
                        fromQueueDB.studylist
                    })
                    
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
    } //: fetchMainMapSearchWord
    
    func postQueueStudy(lat: Double, long: Double, studyList: String) -> Single<QueueSuccessType> {
        print(#function)
        return Single<QueueSuccessType>.create { [weak self] emitter in
            
            self?.mainAPIService.studyRequest(lat: lat, long: long, studyList: studyList, completionHandler: { result in
                
                switch result {
                case .success(let queueSuccessType):
                    emitter(.success(queueSuccessType))
                case .failure(let error as APIError):
                    print("😡😡😡😡 postQueueStudyError \( error.errorDescription)")
                    emitter(.failure(error))
                default:
                    return
                }
            })
            
            return Disposables.create()
        }
        
    }//: postQueueStudy
    
    func deleteQueueStudy() -> Single<DeleteQueueSuccessType> {
        
        return Single<DeleteQueueSuccessType>.create { [weak self] emitter in
            
            self?.mainAPIService.deleteStudyRequest { result in
                switch result {
                case .success(let deleteSuccessType):
                    emitter(.success(deleteSuccessType))
                case .failure(let error as APIError):
                    print("😡😡😡😡 deleteQueueStudyError \( error.errorDescription)")
                    emitter(.failure(error))
                default:
                    return
                }
            }
            
            return Disposables.create()
        }
        
    }//: deleteQueueStudy
    
    func fetchMyQueueStatus() -> Single<HomeStatus>{
        return Single<HomeStatus>.create { [weak self] emitter in
            self?.mainAPIService.getMyQueueState(completionHandler: { result in
                switch result {
                case .failure(let error as APIError):
                    print("😡😡😡😡 fetchMyQueueStatus Error \( error.errorDescription)")
                    emitter(.failure(error))
                case .success(let myQueueStateSendable):
                    if myQueueStateSendable.statusCode == 201 {
                        emitter(.success(.searching))
                        return
                    }
                    
                    guard let state = myQueueStateSendable.myQueueState?.matched, let queueState = myQueueStateSendable.myQueueState else { return }
                    
                    switch state {
                    case 0:
                        emitter(.success(.matchWaiting))
                        return
                    case 1:
                        emitter(.success(.matched(nick: queueState.matchedNick, uid: queueState.matchedUid)))
                        return
                    default:
                        return
                    }
                    
                default:
                    return
                }
            })
            return Disposables.create()
        }
    }//: fetchMyQueueStatus
    
    func fetchCardData(lat: Double, long: Double) -> Single<SearchCardDatasDTO>{
        return Single<SearchCardDatasDTO>.create { [weak self] emitter in
            
            self?.mainAPIService.postSearch(lat: lat, long: long, completionHandler: { result in
                
                // TODO: - 여기서부터 내일하기: 카드뷰 통신 만들기
                switch result {
                case .success(let searchUser):
                    let nearByCards = searchUser.fromQueueDB.map {
                        return SearchCardDataDTO(nick: $0.nick, reputation: $0.reputation, studyList: $0.studylist, reviews: $0.reviews, sesac: $0.sesac, background: $0.background)
                    }
                    let requestCards = searchUser.fromQueueDBRequested.map {
                        return SearchCardDataDTO(nick: $0.nick, reputation: $0.reputation, studyList: $0.studylist, reviews: $0.reviews, sesac: $0.sesac, background: $0.background)
                    }
                    emitter(.success(SearchCardDatasDTO(nearByUserCards: nearByCards, requestUserCards: requestCards)))
                    return
                    
                case .failure(let error as APIError):
                    print("😡😡😡😡 fetchMyQueueStatus Error \( error.errorDescription)")
                    emitter(.failure(error))
                    return
                    
                default:
                    return
                }
            })
            
            return Disposables.create()
        }
    }
}
