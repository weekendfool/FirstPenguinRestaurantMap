//
//  RouterModel.swift
//  FirstPenguinRestaurantMap
//
//  Created by Oh!ara on 2023/05/14.
//

// 画面遷移管理

import UIKit

final class RouterModel {
    
    static func showRootConditionalInputView(window: UIWindow) {
        
//        let vc = ConditionalInputViewController.makeFromStoryboard()
        
//        let x = UIStoryboard.conditionalInputViewController
//        window.rootViewController = vc
        
        window.rootViewController = ConditionalInputViewController.makeFromStoryboard()
        
        window.makeKeyAndVisible()
    }
}

extension RouterModel {
    
    func show(from: UIViewController, next: UIViewController, animated: Bool = true) {
        
        
        next.modalPresentationStyle = .fullScreen
        next.modalTransitionStyle = .flipHorizontal
        from.present(next, animated: animated, completion: nil)
    }
}
