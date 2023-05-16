//
//  RestaurantInfoViewController.swift
//  FirstPenguinRestaurantMap
//
//  Created by Oh!ara on 2023/05/13.
//

import UIKit

class RestaurantInfoViewController: UIViewController {
    // MARK: - UIパーツ
    // MARK: - 変数
    // MARK: - ライフサイクル
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - 関数
    // 画面展開
    static func makeFromStoryboard() -> RestaurantInfoViewController {
        let vc = UIStoryboard.restaurantInfoViewController
        
        print("ttttttttttttttttttt")
        
        return vc
    }
}

// MARK: - extension
