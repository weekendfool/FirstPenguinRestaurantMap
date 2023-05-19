//
//  APIDataModel.swift
//  FirstPenguinRestaurantMap
//
//  Created by Oh!ara on 2023/05/14.
//

// APIのデータ構造

import Foundation

struct APIDataModel: Codable {
//    var results_available: Int
//    var results_returned: String
    var results: results
}

struct results: Codable {
//    var results_returned: String
    var shop: [shop]
}

struct shop: Codable {
    // 店名
    var name: String

    var lat: Double
    var lng: Double
    // アクセス
    var mobile_access: String
    
    var address: String
    var open: String
    var card: String
    // 写真
    var photo: photo
}


struct photo: Codable {
    var mobile: mobile
}
struct mobile: Codable {

    var l: URL
    var s: URL
}
