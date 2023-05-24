//
//  RouterModel.swift
//  FirstPenguinRestaurantMap
//
//  Created by Oh!ara on 2023/05/14.
//

// 画面遷移管理

import UIKit

final class RouterModel {
    
    
    
    // 検索画面
    func showConditionalInputViewController(from: UIViewController) {
        let vc = ConditionalInputViewController.makeFromStoryboard()
        
        show(from: from, next: vc)
    }
    
    // 検索結果表示画面
    func showIntuitionSelectViewController(from: UIViewController) {
        let vc = IntuitionSelectViewController.makeFromStoryboard()
        
        show(from: from, next: vc)
    }
    
    // 地図表示画面
    func showMapViewController(from: UIViewController) {
        let vc = MapViewController.makeFromStoryboard()
        
        show(from: from, next: vc)
    }
    
    // 画面
    func showCarefullySelectViewController(from: UIViewController) {
        let vc = CarefullySelectViewController.makeFromStoryboard()
        
        show(from: from, next: vc)
    }
    
    //　店情報画面
    func showRestaurantInfoViewController(from: UIViewController) {
        let vc = RestaurantInfoViewController.makeFromStoryboard()
        
        showHarfModal(from: from, next: vc)
    }
    
    
}

extension RouterModel {
    
    func show(from: UIViewController, next: UIViewController, animated: Bool = true) {
        
        
        next.modalPresentationStyle = .fullScreen
        next.modalTransitionStyle = .flipHorizontal
        from.present(next, animated: animated, completion: nil)
    }
    
    func showHarfModal(from: UIViewController, next: UIViewController, animated: Bool = true) {

        from.present(next, animated: animated, completion: nil)
    }
}
