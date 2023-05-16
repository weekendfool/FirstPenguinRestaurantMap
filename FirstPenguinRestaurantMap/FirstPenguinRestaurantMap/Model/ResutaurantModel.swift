//
//  ResutaurantModel.swift
//  FirstPenguinRestaurantMap
//
//  Created by Oh!ara on 2023/05/17.
//

// 店情報の管理

import Foundation
import RxSwift


class ResutaurantModel {
    
    // MARK: - 変数
    // 店情報
    var resutaurant: RestaurantDataModel = RestaurantDataModel(
        name: "",
        lat: 0.0,
        lng: 0.0,
        access: "",
        imageULR: ""
    )
    
    var resutaurantArray: [RestaurantDataModel] = []
    // MARK: - 関数

    func getData(data: [APIDataModel]) -> Observable<Bool> {
        return Observable.create { [self] observable in
            
            for data in data {
                resutaurant.name = data.results.shop.first?.name ?? ""
                resutaurant.lat = data.results.shop.first?.lat ?? 0.0
                resutaurant.lng = data.results.shop.first?.lng ?? 0.0
                resutaurant.access = data.results.shop.first?.mobile_access ?? ""
                resutaurant.imageULR = data.results.shop.first?.photo.mobile.l.absoluteString ?? ""
                
                resutaurantArray.append(resutaurant)
            }
            
            if resutaurantArray.count !=  {
                observable.onNext(true)
            } else {
                observable.onNext(false)
            }
            
            
            return Disposables.create()
        }
    }
}
