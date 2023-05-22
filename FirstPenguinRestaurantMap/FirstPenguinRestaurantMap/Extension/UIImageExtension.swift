//
//  UIImageExtension.swift
//  FirstPenguinRestaurantMap
//
//  Created by Oh!ara on 2023/05/18.
//

// imageの拡張

import UIKit

extension UIImage {
    
    
    // urlからの生成
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
    
    // リサイズ
    func resaize(image: UIImage, width: Double) -> UIImage {
        // 元画像のアスペクト比を計算
        let aspectScale = image.size.height / image.size.width
        
        let resizedSize = CGSize(width: width, height: width * Double(aspectScale))
        
        UIGraphicsBeginImageContext(resizedSize)
        image.draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
        
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage!
        
    }
    

}

