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
    
   // 全件データ配列
    var resutaurantArray: [RestaurantDataModel] = []
    // 選ばれた配列
    var selectedRestaurantArray: [RestaurantDataModel] = []
    
    // 件数
//    var numberOfResutaurants: Int = 0
    
    
    // MARK: - 関数

    func getData(data: APIDataModel) -> Observable<Bool> {
        
        let userDefaluts = UserDefaults.standard
        
        return Observable.create { [self] observable in
            
            
            
            let inputData = data.results.shop
            
            changeData(inputData: inputData) {
                userDefaluts.setResutaurantData(resutaurantArray, forKey: "resutaurant")
                
                print("555555555555555555555555555555")
                print("resutaurantArray: \(resutaurantArray)")
//                userDefaluts.set(resutaurantArray.count, forKey: item.numberOfRestaurants.isValue)
                
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
        
//        numberOfResutaurants = resutaurantArray.count
        print("resutaurantArray : \(resutaurantArray[7].name)")
        completion()
    }
    
 
    
    func reloadResutaurantArray() -> Observable<Bool> {
        
        return Observable.create { [self] observable in
            let userDefaluts = UserDefaults.standard
            
            resutaurantArray = userDefaluts.getResutaurantData([RestaurantDataModel].self, forKey: "resutaurant")!
            
            observable.onNext(true)
            
            return Disposables.create()
        }

    }
    
    // データの返却
    func fetchStringData(item: item) -> Observable<String> {
        return Observable.create { [self] observable in
            switch item {
        
            case .name:
                observable.onNext(resutaurantArray[0].name)
            case .lat:
                observable.onCompleted()
            case .lng:
                observable.onCompleted()
            case .access:
                observable.onNext(resutaurantArray[0].access)
            case .imageURL:
                observable.onNext(resutaurantArray[0].imageULR)
            case .numberOfRestaurants:
                observable.onNext(String(resutaurantArray.count))
            }
            return Disposables.create()
        }
    }

    // データの返却
    func fetchDoubleData(item: item) -> Observable<Double> {
        return Observable.create { [self] observable in
            switch item {
        
            case .name:
                observable.onCompleted()
            case .lat:
                observable.onNext(resutaurantArray[0].lat)
            case .lng:
                observable.onNext(resutaurantArray[0].lng)
            case .access:
                observable.onCompleted()
            case .imageURL:
                observable.onCompleted()
            case .numberOfRestaurants:
                observable.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    // データの整理
    func selectData(isSelected: Bool) -> Observable<Bool> {
        return Observable.create { [self] observable in
            
            if isSelected {
                
                selectedRestaurantArray.append(resutaurantArray[0])
            }
            
            resutaurantArray.remove(at: 0)
            
            observable.onNext(true)
            
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
    case numberOfRestaurants
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
        case .numberOfRestaurants:
            return "numberOfRestaurants"
        }
    }
}
