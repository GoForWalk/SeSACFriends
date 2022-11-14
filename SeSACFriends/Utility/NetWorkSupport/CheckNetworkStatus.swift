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
    var handleNetworkDisConnected: (() -> Void)? { get set }
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
        monitor?.pathUpdateHandler = { [weak self] path in
            print("👀👀👀 Monitoring NetWork Connection start: \(self)")
            self?.setNetWorkCheck(path: path, handler: self?.handleNetworkDisConnected)
        }
        monitor?.start(queue: queue)
        isMonitoring = true
    }
    /// Network connection 모니터링 종료 함수
    func stopMonitoring() {
        if isMonitoring, let monitor {
            print("👀👀👀 Monitoring NetWork Connection done: \(self)")
            monitor.cancel()
            self.monitor = nil
            isMonitoring = false
        }
        
    }
    
    private func setNetWorkCheck(path: NWPath, handler: (() -> Void)?) {
        
        if isConnected {
            print("👀👀👀 Monitoring NetWork Connection: \(self)")
            return
        } else {
            guard let handler else { return }
            handler()
        }
        
    }
    
}


