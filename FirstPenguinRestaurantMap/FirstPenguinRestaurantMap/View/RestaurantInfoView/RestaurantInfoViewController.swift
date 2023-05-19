//
//  RestaurantInfoViewController.swift
//  FirstPenguinRestaurantMap
//
//  Created by Oh!ara on 2023/05/13.
//

import UIKit

class RestaurantInfoViewController: UIViewController {
    // MARK: - UIパーツ
    
    @IBOutlet weak var resutaurantNameLabel: UILabel!
    @IBOutlet weak var resutaurantAdressLabel: UILabel!
    @IBOutlet weak var resutaurantBusinessHours: UILabel!
    
    @IBOutlet weak var creditCardLabel: UILabel!
    
    @IBOutlet weak var resutaurantImageView: UIImageView!
    
    
    @IBOutlet weak var goMapButton: UIButton!
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
