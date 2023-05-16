//
//  IntuitionSelectViewController.swift
//  FirstPenguinRestaurantMap
//
//  Created by Oh!ara on 2023/05/13.
//

import UIKit

class IntuitionSelectViewController: UIViewController {
    // MARK: - UIパーツ
    
    @IBOutlet weak var numberOfRestaurantsLabel: UILabel!
    @IBOutlet weak var resutaurantNameLabel: UILabel!
    @IBOutlet weak var accessLabel: UILabel!
    @IBOutlet weak var resutaurantImageView: UIImageView!
    @IBOutlet weak var badButton: UIButton!
    @IBOutlet weak var goodButton: UIButton!
    @IBOutlet weak var goMapViewButton: UIButton!
    
    // MARK: - 変数
    
    // MARK: - ライフサイクル

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    // MARK: - 関数
    // 画面展開
    static func makeFromStoryboard() -> IntuitionSelectViewController {
        let vc = UIStoryboard.intuitionSelectViewController
        
        print("ttttttttttttttttttt")
        
        return vc
    }
}

// MARK: - extension
