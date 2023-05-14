//
//  APIModel.swift
//  FirstPenguinRestaurantMap
//
//  Created by Oh!ara on 2023/05/13.
//

import Foundation
import RxCocoa
import RxSwift
import Alamofire

final class APIModel {
    
    // MARK: - 変数
    
    // URL
    
    // apiKey
    let apiKey = "cfbf72a9451eb428"
    var keyWord = ""
    
    // 緯度
    var lat = ""
    // 経度
    var lng = ""
    // 範囲: 1-5まで
    var range: range = .first
    
    
    
    // MARK: - 関数
    
    func getData(lat: String, lng: String, range: range) {
        let urlString = "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=\(apiKey)&lat=\(lat)&lng=\(lng)&range=\(range.isValue)"
    }
    
    // 情報の取得
}

// 検索範囲の段階
enum range: Codable {
    case first
    case second
    case third
    case fourth
    case fifth
}

extension range {
    var isValue: String {
        switch self {
        case .first:
            return "1"
        case .second:
            return "2"
        case .third:
            return "3"
        case .fourth:
            return "4"
        case .fifth:
            return "5"
        }
    }
}
