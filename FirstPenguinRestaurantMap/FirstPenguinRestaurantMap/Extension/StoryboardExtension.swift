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
        
    }
    
    // 検索結果表示画面
    static var intuitionSelectViewController: IntuitionSelectViewController {
        UIStoryboard.init(name: "IntuitionSelectView", bundle: nil).instantiateInitialViewController() as! IntuitionSelectViewController
    }
    
    // 地図表示画面
    static var mapViewController: MapViewController {
        UIStoryboard.init(name: "MapView", bundle: nil).instantiateInitialViewController() as! MapViewController
    }
    
    // 表示画面
    static var carefullySelectViewController: CarefullySelectViewController {
        UIStoryboard.init(name: "CarefullySelectView", bundle: nil).instantiateInitialViewController() as! CarefullySelectViewController
    }
    
    //　店情報画面
    static var restaurantInfoViewController: RestaurantInfoViewController {
        UIStoryboard.init(name: "RestaurantInfoView", bundle: nil).instantiateInitialViewController() as! RestaurantInfoViewController
    }
    
}
