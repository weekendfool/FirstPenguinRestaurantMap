//
//  StoryboardExtension.swift
//  FirstPenguinRestaurantMap
//
//  Created by Oh!ara on 2023/05/14.
//

import UIKit


extension UIStoryboard {
    // 検索画面
    static var conditionalInputViewController: ConditionalInputViewController {
        UIStoryboard.init(name: "ConditionalInputView", bundle: nil).instantiateInitialViewController() as! ConditionalInputViewController
        
//        print("RRRRRRRRRRRRRRR")
    }
}
