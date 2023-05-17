//
//  UIImageExtension.swift
//  FirstPenguinRestaurantMap
//
//  Created by Oh!ara on 2023/05/18.
//

// imageの拡張

import UIKit

func getImageByUrl(url: String) -> UIImage {
    
    let url = URL(string: url)!
    
    do {
        let data = try Data(contentsOf: url)
        return UIImage(data: data)!
    } catch let error {
        print("Error: \(error)")
    }
    
    return UIImage()
}
