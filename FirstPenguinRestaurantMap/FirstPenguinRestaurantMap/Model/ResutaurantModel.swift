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
    
   
    var resutaurantArray: [RestaurantDataModel] = []
    // MARK: - 関数

    func getData(data: APIDataModel) -> Observable<Bool> {
        
        let userDefaluts = UserDefaults.standard
        
        return Observable.create { [self] observable in
            
            print("555555555555555555555555555555")
            print("data: \(data.results.shop)")
            
            let inputData = data.results.shop
            
            changeData(inputData: inputData) {
                userDefaluts.setResutaurantData(resutaurantArray, forKey: "resutaurant")
                
                observable.onNext(true)
            }

            
            return Disposables.create()
        }
    }
    
    private func changeData(inputData: [shop], completion: ()->()){
        for shop in inputData {
            
            var resutaurant: RestaurantDataModel = RestaurantDataModel(
                name: shop.name,
                lat: shop.lat,
                lng: shop.lng,
                access: shop.mobile_access,
                imageULR: shop.photo.mobile.l.absoluteString
            )

           print("shop : \(shop)")
            print("resutaurant : \(resutaurant.name)")

            
            resutaurantArray.append(resutaurant)
        }
        
        print("resutaurantArray : \(resutaurantArray[7].name)")
        completion()
    }
    
    // 情報保存
//    func registerItem() -> Observable<Bool> {
//        return Observable.create { observable in
//
//            return Disposables.create()
//        }
//    }
//
    // 保存
    // 共通処理
    private func setData(item: item, data: Any, completion: () -> ()) {
        
        let userDefaluts = UserDefaults.standard
        
        // 保存処理
        switch item {
        
        case .name:
            let name = data as! String
            userDefaluts.set(name, forKey: item.isValue)
            
        case .lat:
            let lat = data as! Double
            userDefaluts.set(lat, forKey: item.isValue)
        case .lng:
            let lng = data as! Double
            userDefaluts.set(lng, forKey: item.isValue)
        case .access:
            let access = data as! String
            userDefaluts.set(access, forKey: item.isValue)
        case .imageURL:
            let imageURL = data as! String
            userDefaluts.set(imageURL, forKey: item.isValue)
        }
        
        completion()
    }
    
    func reloadResutaurantArray() -> Observable<[RestaurantDataModel]> {
        
        return Observable.create { [self] observable in
            let userDefaluts = UserDefaults.standard
            
            resutaurantArray = userDefaluts.getResutaurantData([RestaurantDataModel].self, forKey: "resutaurant")!
            
            observable.onNext(resutaurantArray)
            
            return Disposables.create()
        }

    }

    
    func reloadData() {
        
        let userDefaluts = UserDefaults.standard
        
        resutaurantArray = userDefaluts.getResutaurantData([RestaurantDataModel].self, forKey: "resutaurant")!
        
        for shop in resutaurantArray {
            print("resutaurantData: \(resutaurantArray)")
            print("data2: \(shop.name)")
       
//
//        switch item {
//        case .name:
//            resutaurant.name = shop.string(forKey: item.isValue)!
//        case .lat:
//            resutaurant.lat = shop.double(forKey: item.isValue)
//        case .lng:
//            resutaurant.lng = shop.double(forKey: item.isValue)
//        case .access:
//            resutaurant.access = shop.string(forKey: item.isValue)!
//        case .imageURL:
//            resutaurant.imageULR = shop.string(forKey: item.isValue)!
//        }
        }
//        completion()
        
    }
    
    
}

enum item {
    case name
    case lat
    case lng
    case access
    case imageURL
}

extension item {
    var isValue: String {
        switch self {
            
        case .name:
            return "name"
        case .lat:
            return "lat"
        case .lng:
            return "lng"
        case .access:
            return "access"
        case .imageURL:
            return "imageURL"
        }
    }
}
