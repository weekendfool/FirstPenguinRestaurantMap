//
//  ConditionalInputViewModel.swift
//  FirstPenguinRestaurantMap
//
//  Created by Oh!ara on 2023/05/13.
//

import Foundation
import RxCocoa
import RxSwift


protocol ConditionalInputViewModelType {
    associatedtype conditionalInputViewInput
    associatedtype conditionalInputViewOutput
    
    func transform(input: conditionalInputViewInput) -> conditionalInputViewOutput
}


final class ConditionalInputViewModel {

    private let apiModel: APIModel = APIModel()
    private let restaurantModel: RestaurantModel = RestaurantModel()
}

extension ConditionalInputViewModel: ConditionalInputViewModelType {
   
    
    
    struct conditionalInputViewInput {
        // 画面の展開
        let isMadeStoryboard: Observable<[Any]>
 
        
        let myLat: Observable<[Any]>
        let myLng: Observable<[Any]>
        
        let selectedRange: Observable<Int>
        
        // button
        let tappedGoCarefullySelectViewButton: Signal<Void>
        let tappedGoIntuitionSelectViewButton: Signal<Void>
        // mapView
        
        // 電波の状況
        let comunnicationState: Observable<[Any]>
    }
    
    struct conditionalInputViewOutput {
        // 通信状況
        let comunnicationState: Driver<networkstate>
        
       // restaurantの初期化
        let resetRestaurantData: Driver<Bool>
        // 距離
        let lat: Driver<String>
        let lng: Driver<String>
        let myPosition: Driver<(latString: String, lngString: String)>
        
        // 検索範囲
        let searchingRange: Driver<range>
       
        // API通信
        let fetchApiDataByGoCarefullySelectViewButton: Driver<Data?>
        let fetchApiDataByGoIntuitionSelectViewButton: Driver<Data?>
        
        // 情報の整理
        let decodingApiDataByGoCarefullySelectViewButton: Driver<APIDataModel>
        let decodingApiDataByGoIntuitionSelectViewButton: Driver<APIDataModel>
        
        let setRestaurantDataByGoCarefullySelectViewButton: Driver<Bool>
        let setRestaurantDataByGoIntuitionSelectViewButton: Driver<Bool>
        
        
        let goIntuitionSelectView: Driver<Bool>
        let goCarefullySelectView: Driver<Bool>
    }
    
    
    func transform(input: conditionalInputViewInput) -> conditionalInputViewOutput {
        
        // 通信状況
        let comunnicationState = input.comunnicationState
            .map { state in
                return state[0] as! networkstate
            }
            .asDriver(onErrorDriveWith: .empty())
        
        let resetRestaurantData = input.isMadeStoryboard
            .map { _ in
                self.restaurantModel.deleateRestaurantArray()
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        let searchingRange = input.selectedRange.asObservable()
            .map { inputRange in
                switch inputRange {
                case 0:
                    return range.first
                case 1:
                    return range.second
                case 2:
                    return range.third
                case 3:
                    return range.fourth
                case 4:
                    return range.fifth
                default:
                    return range.third
                }
            }
            .asDriver(onErrorDriveWith: .empty())
        
       
        // 位置情報
        let lat = input.myLat.asObservable()
            .map { lat in
                return lat.first as! String
            }
            .asDriver(onErrorDriveWith: .empty())
        
        let lng = input.myLng.asObservable()
            .map { lng in
                return lng.first as! String
            }
            .asDriver(onErrorDriveWith: .empty())
        
        
        let myPosition = Driver.combineLatest(
            lat,
            lng
        ) { (latString: $0, lngString: $1) }
        
        // API通信
        // 一覧
        let fetchApiDataByGoCarefullySelectViewButton = input.tappedGoCarefullySelectViewButton.asObservable()
            .withLatestFrom(myPosition)
            .withLatestFrom(searchingRange)
        { myPosition, range in
                self.apiModel.getData(lat: myPosition.latString, lng: myPosition.lngString, range: range)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        let decodingApiDataByGoCarefullySelectViewButton = fetchApiDataByGoCarefullySelectViewButton.asObservable()
            .filter { $0 != nil }
            .map { data in
                self.apiModel.decodeData(data: data!)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        let setRestaurantDataByGoCarefullySelectViewButton = decodingApiDataByGoCarefullySelectViewButton.asObservable()
            .map { data in
                self.restaurantModel.getData(data: data)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        let goCarefullySelectView = setRestaurantDataByGoCarefullySelectViewButton.asObservable()
            .filter { $0 == true}
            .map { result in
                return result
            }
            .asDriver(onErrorDriveWith: .empty())
        
        
        // 個別
        let fetchApiDataByGoIntuitionSelectViewButton = input.tappedGoIntuitionSelectViewButton.asObservable()
            .withLatestFrom(myPosition)
            .withLatestFrom(searchingRange)
        { myPosition, range in
                self.apiModel.getData(lat: myPosition.latString, lng: myPosition.lngString, range: range)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        let decodingApiDataByGoIntuitionSelectViewButton = fetchApiDataByGoIntuitionSelectViewButton.asObservable()
            .filter { $0 != nil }
            .map { data in
                self.apiModel.decodeData(data: data!)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        let setRestaurantDataByGoIntuitionSelectViewButton = decodingApiDataByGoIntuitionSelectViewButton.asObservable()
            .map { data in
                self.restaurantModel.getData(data: data)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
    
        
        let goIntuitionSelectView = setRestaurantDataByGoIntuitionSelectViewButton.asObservable()
            .filter { $0 == true}
            .map { result in
                return result
            }
            .asDriver(onErrorDriveWith: .empty())
       
        
        return conditionalInputViewOutput(
            comunnicationState: comunnicationState,
            resetRestaurantData: resetRestaurantData,
            lat: lat,
            lng: lng,
            myPosition: myPosition,
            searchingRange: searchingRange,
            fetchApiDataByGoCarefullySelectViewButton: fetchApiDataByGoCarefullySelectViewButton,
            fetchApiDataByGoIntuitionSelectViewButton: fetchApiDataByGoIntuitionSelectViewButton,
            decodingApiDataByGoCarefullySelectViewButton: decodingApiDataByGoCarefullySelectViewButton,
            decodingApiDataByGoIntuitionSelectViewButton: decodingApiDataByGoIntuitionSelectViewButton,
            setRestaurantDataByGoCarefullySelectViewButton: setRestaurantDataByGoCarefullySelectViewButton,
            setRestaurantDataByGoIntuitionSelectViewButton: setRestaurantDataByGoIntuitionSelectViewButton,
            goIntuitionSelectView: goIntuitionSelectView,
            goCarefullySelectView: goCarefullySelectView
        )
    }
    
}
