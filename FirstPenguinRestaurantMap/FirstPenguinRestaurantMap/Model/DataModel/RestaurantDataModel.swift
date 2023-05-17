//
//  RestaurantDataModel.swift
//  FirstPenguinRestaurantMap
//
//  Created by Oh!ara on 2023/05/17.
//

//　使用する店の情報

import Foundation

class RestaurantDataModel: Codable {
    
    var name: String
    var lat: Double
    var lng: Double
    var access: String
    var imageULR: String
    
    
    init(name: String, lat: Double, lng: Double, access: String, imageULR: String) {
        self.name = name
        self.lat = lat
        self.lng = lng
        self.access = access
        self.imageULR = imageULR
    }
}
