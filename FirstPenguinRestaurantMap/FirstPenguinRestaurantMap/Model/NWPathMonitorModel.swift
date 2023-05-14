//
//  NWPathMonitorModel.swift
//  FirstPenguinRestaurantMap
//
//  Created by Oh!ara on 2023/05/14.
//

// 通信の管理

import Foundation
import Network
import RxCocoa
import RxSwift


final class NWPathMonitorModel {
 
    var monitor = NWPathMonitor()
    
  
    func monitorComunnication( completion: @escaping (_ state:networkstate)->() ) {
            // 状態のハンドリング
        var state: networkstate?
        
        self.monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
      
                state = .successfulCommunication
                completion(state!)
            } else {
              
                state = .failureCommunication
                completion(state!)
            }
        }

    }

    // 監視開始
    func start() {
        
        let queue = DispatchQueue(label: "Monitor")
        
        monitor.start(queue: queue)
    }
    
}


enum networkstate {
    case successfulCommunication
    case failureCommunication
}

