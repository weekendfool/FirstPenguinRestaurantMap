//
//  RestaurantModel.swift
//  FirstPenguinRestaurantMap
//
//  Created by Oh!ara on 2023/05/17.
//

// 店情報の管理

import Foundation
import RxSwift


class RestaurantModel {
    
   // 全件データ配列
    var restaurantArray: [RestaurantDataModel] = []
    // 選ばれた配列
    var selectedRestaurantArray: [RestaurantDataModel] = []
    
    let userDefaults = UserDefaults.standard
    
    
    // MARK: - 関数

    // 取得したデータの整形
    func getData(data: APIDataModel) -> Observable<Bool> {
        
        
        return Observable.create { [self] observable in
            
            
            let inputData = data.results.shop
            
            changeData(inputData: inputData) {
                userDefaults.setRestaurantData(restaurantArray, forKey: "restaurant")
   
                observable.onNext(true)
            }

            
            return Disposables.create()
        }
    }
    private func changeData(inputData: [shop], completion: ()->()){
    for shop in inputData {
        
        var restaurant: RestaurantDataModel = RestaurantDataModel(
            name: shop.name,
            lat: shop.lat,
            lng: shop.lng,
            access: shop.mobile_access,
            imageULR: shop.photo.mobile.l.absoluteString,
            adress: shop.address,
            businessHours: shop.open,
            creditCard: shop.card
            
        )
        
    
        restaurantArray.append(restaurant)
    }

    completion()
}
    
 
    // データのリロード
    func reloadRestaurantArray(isSelected: Bool) -> Observable<Bool> {
        
        return Observable.create { [self] observable in
            
            if isSelected {
                selectedRestaurantArray = userDefaults.getRestaurantData([RestaurantDataModel].self, forKey: "selectedRestaurant")!
                
                observable.onNext(true)
            } else {
                restaurantArray = userDefaults.getRestaurantData([RestaurantDataModel].self, forKey: "restaurant")!
                observable.onNext(true)
            }
            
            
            return Disposables.create()
        }

    }
    
    // データの返却
    func fetchStringData(item: item, isSelected: Bool) -> Observable<String> {
        return Observable.create { [self] observable in
            
            if isSelected {
                switch item {
            
                case .name:
                    observable.onNext(selectedRestaurantArray[0].name)
                case .lat:
                    observable.onCompleted()
                case .lng:
                    observable.onCompleted()
                case .access:
                    observable.onNext(selectedRestaurantArray[0].access)
                case .imageURL:
                    observable.onNext(selectedRestaurantArray[0].imageULR)
                case .numberOfRestaurants:
                    observable.onNext(String(selectedRestaurantArray.count))
                case .adress:
                    observable.onNext(selectedRestaurantArray[0].adress)
                case .businessHours:
                    observable.onNext(selectedRestaurantArray[0].businessHours)
                case .creditCard:
                    observable.onNext(selectedRestaurantArray[0].creditCard)
                }
            } else {
                switch item {
            
                case .name:
                    observable.onNext(restaurantArray[0].name)
                case .lat:
                    observable.onCompleted()
                case .lng:
                    observable.onCompleted()
                case .access:
                    observable.onNext(restaurantArray[0].access)
                case .imageURL:
                    observable.onNext(restaurantArray[0].imageULR)
                case .numberOfRestaurants:
                    observable.onNext(String(restaurantArray.count))
                case .adress:
                    observable.onNext(restaurantArray[0].adress)
                case .businessHours:
                    observable.onNext(restaurantArray[0].businessHours)
                case .creditCard:
                    observable.onNext(restaurantArray[0].creditCard)
                }
            }
            
            return Disposables.create()
        }
    }
    func fetchDoubleData(item: item, isSelected: Bool) -> Observable<Double> {
        return Observable.create { [self] observable in
            
            if isSelected {
                switch item {
            
                case .name:
                    observable.onCompleted()
                case .lat:
                    observable.onNext(selectedRestaurantArray[0].lat)
                case .lng:
                    observable.onNext(selectedRestaurantArray[0].lng)
                case .access:
                    observable.onCompleted()
                case .imageURL:
                    observable.onCompleted()
                case .numberOfRestaurants:
                    observable.onCompleted()
                case .adress:
                    observable.onCompleted()
                case .businessHours:
                    observable.onCompleted()
                case .creditCard:
                    observable.onCompleted()
                }
            } else {
                switch item {
            
                case .name:
                    observable.onCompleted()
                case .lat:
                    observable.onNext(restaurantArray[0].lat)
                case .lng:
                    observable.onNext(restaurantArray[0].lng)
                case .access:
                    observable.onCompleted()
                case .imageURL:
                    observable.onCompleted()
                case .numberOfRestaurants:
                    observable.onCompleted()
                case .adress:
                    observable.onCompleted()
                case .businessHours:
                    observable.onCompleted()
                case .creditCard:
                    observable.onCompleted()
                }
            }
            
            return Disposables.create()
        }
    }
    

    // データの整理
    func selectData(isSelected: Bool) -> Observable<Bool> {
        return Observable.create { [self] observable in
            
            if isSelected {
                
                selectedRestaurantArray.append(restaurantArray[0])
            }
            
            restaurantArray.remove(at: 0)
            
            observable.onNext(true)
            
            return Disposables.create()
        }
    }
    
    
    // 選択されたレストランのデータの格納
    func selectRestaurant(indexPath: Int) -> Observable<Bool> {
        return Observable.create { [self] observable in
            
            selectedRestaurantArray.append(restaurantArray[indexPath])
            
            
            userDefaults.setRestaurantData(selectedRestaurantArray, forKey: "selectedRestaurant")
            
            observable.onNext(true)
            
            return Disposables.create()
        }
    }
    func setRestaurantData() -> Observable<[RestaurantDataModel]>{
        return Observable.create { [self] observable in
            
            observable.onNext(restaurantArray)
            
            return Disposables.create()
        }
    }
    
    // データの削除
    func deleateRestaurantArray() -> Observable<Bool> {
        return Observable.create { [self] observable in
            
            deleateRestaurantData {
                observable.onNext(true)
            }
            return Disposables.create()
        }
    }
    
    private func deleateRestaurantData(completion:()->()) {
        
        restaurantArray.removeAll()
        selectedRestaurantArray.removeAll()
        
       
        
        if restaurantArray.count == 0 && selectedRestaurantArray.count == 0 {
            userDefaults.setRestaurantData(restaurantArray, forKey: "restaurant")
            userDefaults.setRestaurantData(selectedRestaurantArray, forKey: "selectedRestaurant")
            completion()
        }
    }
        
    
}

enum item {
    case name
    case lat
    case lng
    case access
    case imageURL
    case numberOfRestaurants
    case adress
    case businessHours
    case creditCard
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
        case .adress:
            return "adress"
        case .businessHours:
            return "businessHours"
        case .creditCard:
            return "creditCard"
        }
    }
}

