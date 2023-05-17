//
//  UIImageExtension.swift
//  FirstPenguinRestaurantMap
//
//  Created by Oh!ara on 2023/05/18.
//

// imageの拡張

import UIKit

extension UIImage {
    
    
    public convenience init(url: String) {
        let url = URL(string: url)!
        
        do {
            let data = try Data(contentsOf: url)
            self.init(data: data)!
        } catch let error {
            print("Error: \(error)")
        }
        self.init()
    }

}

