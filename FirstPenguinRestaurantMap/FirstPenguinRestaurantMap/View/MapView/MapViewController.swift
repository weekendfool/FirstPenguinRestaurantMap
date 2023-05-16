//
//  MapViewController.swift
//  FirstPenguinRestaurantMap
//
//  Created by Oh!ara on 2023/05/13.
//

import UIKit

class MapViewController: UIViewController {
    
    // MARK: - UIパーツ
    // MARK: - 変数
    // MARK: - ライフサイクル
   
   

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    // MARK: - 関数
    // 画面展開
    static func makeFromStoryboard() -> MapViewController {
        let vc = UIStoryboard.mapViewController
        
        print("ttttttttttttttttttt")
        
        return vc
    }
}

// MARK: - extension
