//
//  APIModel.swift
//  FirstPenguinRestaurantMap
//
//  Created by Oh!ara on 2023/05/13.
//

// apiの通信管理

import Foundation
//import RxCocoa
import RxSwift
import Alamofire
import AlamofireImage

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
    
    func getData(lat: String, lng: String, range: range) -> Observable<Data?> {
        
        // リクエスト用URL生成
        let urlString = "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=\(apiKey)&lat=\(lat)&lng=\(lng)&range=\(range.isValue)&format=json"
        
        let encodeUrlString: String = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let url = URL(string: encodeUrlString)
        
        print("url : \(url)")
        
        return Observable.create { observable in
            
            AF.request(url!).responseJSON { response in
            
                switch response.result {
                case .success:
                    
                    observable.onNext(response.data)
                case .failure:
                    
                    observable.onNext(nil)
                }
            }
            return Disposables.create()
        }
    }
    

    // 情報の取得
    
    // デコード
    func decodeData(data: Data) -> Observable<APIDataModel> {
        return Observable.create { observable in
            
            let decoder: JSONDecoder = JSONDecoder()
            
            let restaurantData: APIDataModel = try! decoder.decode(APIDataModel.self, from: data)
            
            observable.onNext(restaurantData)
            
            return Disposables.create()
        }
    }
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
