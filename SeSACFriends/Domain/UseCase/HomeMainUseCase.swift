//
//  HomeMainUseCase.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/16.
//

import Foundation
import MapKit
import CoreLocation

import RxSwift
import RxCocoa


protocol HomeMainUseCase: UseCase {
    
    
}

final class HomeMainUseCaseImpi: HomeMainUseCase, CheckAndRefreshIDToken {
    
    private var homeStatus: HomeStatus = .searching
    private var MainAPIService: MainAPIService = MainAPIServiceImpi()
    
    let homeStatusOut = PublishSubject<HomeStatus>()
    
    deinit {
        print("🐙🐙🐙🐙🐙🐙🐙 UseCase deinit \(self) 🐙🐙🐙🐙🐙🐙🐙🐙🐙🐙")
    }
    
}

private extension HomeMainUseCaseImpi {
    
    func setHomeMode() {
        
    }
    
    
    
}


@frozen enum HomeStatus {
    case searching
    case matchWaiting
    case matched
}

extension HomeStatus {
    var buttonImage: ImageInfo {
        switch self {
        case .searching:
            return Images.search
        case .matchWaiting:
            return Images.antenna
        case .matched:
            return Images.message
        }
    }
}
