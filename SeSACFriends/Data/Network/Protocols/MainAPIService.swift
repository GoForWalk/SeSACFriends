//
//  MainAPIService.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/12/01.
//

import Foundation

protocol MainAPIService: AnyObject {
    func postSearch(lat: Double, long: Double, completionHandler: @escaping (Result<SearchUser, Error>) -> Void)
    func studyRequest(lat: Double, long: Double, studyList: [String], completionHandler: @escaping (Result<QueueSuccessType, Error>) -> Void)
    func deleteStudyRequest( completionHandler: @escaping (Result<DeleteQueueSuccessType, Error>) -> Void)
    func getMyQueueState(completionHandler: @escaping (Result<MyQueueStateSendable, Error>) -> Void)
    func postStudyAccept(otherID: String, completionHandler: @escaping (Result<StudyAcceptStatusCodeType, Error>) -> Void)
    func postStudyRequest(otherID: String, completionHandler: @escaping (Result<StudyRequestSuccessStatusCodeType, Error>) -> Void)
}
