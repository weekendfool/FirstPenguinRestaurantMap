//
//  APIDataModel.swift
//  FirstPenguinRestaurantMap
//
//  Created by Oh!ara on 2023/05/14.
//

// APIのデータ構造

import Foundation

struct APIDataModel: Codable {
    var results_available: Int
    var results_returned: Int
    
    var results: [shop]
}

struct shop: Codable {
    // 店名
    var name: String
    // image
    
    
    var lat: String
    var lng: String
    // アクセス
    var mobile_access: String
    // 写真
    var photo: [mobile]
}

struct mobile: Codable {
    
    var l: URL
    var s: URL
}
