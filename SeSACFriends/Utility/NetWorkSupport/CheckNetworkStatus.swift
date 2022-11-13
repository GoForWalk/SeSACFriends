//
//  CheckNetworkStatus.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/11.
//

import Foundation

import Network
// TODO: Check NetWork Status

protocol CheckNetworkStatus: AnyObject {
    var monitor: NWPathMonitor? { get set }
    var isMonitoring: Bool { get set }
    var handleDidStartNetworkMonitoring: (() -> Void)? { get set }
    var handleDidStoppedNetworkMonitoring: (() -> Void)? { get set }
}

extension CheckNetworkStatus {
    
    var isConnected: Bool {
        guard let monitor = monitor else { return false }
        return monitor.currentPath.status == .satisfied
    }
    
    /// Network connection 모니터링 시작 함수
    func startMonitering() {
        if isMonitoring { return }
        monitor = NWPathMonitor()
        
        let queue = DispatchQueue(label: "NWMonitor", qos: .default)
        monitor?.start(queue: queue)
        monitor?.pathUpdateHandler = { [weak self] _ in
            self?.handleDidStartNetworkMonitoring?()
        }
        isMonitoring = true
        handleDidStartNetworkMonitoring?()
    }
    /// Network connection 모니터링 종료 함수
    func stopMonitoring() {
        if isMonitoring, let monitor {
            monitor.cancel()
            self.monitor = nil
            isMonitoring = false
            
            handleDidStoppedNetworkMonitoring?()
        }
        
    }
    
}


