//
//  MapViewModel.swift
//  FirstPenguinRestaurantMap
//
//  Created by Oh!ara on 2023/05/13.
//

import Foundation
import RxCocoa
import RxSwift

protocol MapViewModelType {
    associatedtype mapViewInput
    associatedtype mapViewOutput
    
    func transform(input: mapViewInput) -> mapViewOutput
}

final class MapViewModel {
    private let restaurantModel: RestaurantModel = RestaurantModel()
}

extension MapViewModel: MapViewModelType {
    
    struct mapViewInput {
        // 画面の展開
        let isMadeStoryboard: Observable<[Any]>
        // 電波の状況
        let comunnicationState: Observable<[Any]>
        
        let myLat: Observable<[Any]>
        let myLng: Observable<[Any]>
        
        let tappedBackButton: Signal<Void>
    }
    
    struct mapViewOutput {
        
        // 通信状況
        let comunnicationState: Driver<networkstate>
        // 距離
        let myLat: Driver<String>
        let myLng: Driver<String>
        let myPosition: Driver<(latString: String, lngString: String)>
        
        let gatRestaurantData: Driver<Bool>
        
        // 目的地
        let goalLat: Driver<Double>
        let goalLng: Driver<Double>
        let goalPostion: Driver<(lat: Double, lng: Double)>
        
        // 画面遷移
        let goConditionalInputView: Driver<Bool>
    }
    
    func transform(input: mapViewInput) -> mapViewOutput {
        // 通信状況
        let comunnicationState = input.comunnicationState
            .map { state in
                return state[0] as! networkstate
            }
            .asDriver(onErrorDriveWith: .empty())
        
        // 位置情報
        let myLat = input.myLat.asObservable()
            .map { lat in
                return lat.first as! String
            }
            .asDriver(onErrorDriveWith: .empty())
        
        let myLng = input.myLng.asObservable()
            .map { lng in
                return lng.first as! String
            }
            .asDriver(onErrorDriveWith: .empty())
        
        
        let myPosition = Driver.combineLatest(
            myLat,
            myLng
        ) { (latString: $0, lngString: $1) }
        
        let gatRestaurantData = input.isMadeStoryboard
            .map { _ in
                self.restaurantModel.reloadRestaurantArray(isSelected: true)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        let goalLat = gatRestaurantData.asObservable()
            .filter { $0 == true }
            .map { result in
                self.restaurantModel.fetchDoubleData(item: .lat, isSelected: true)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        let goalLng = gatRestaurantData.asObservable()
            .filter { $0 == true }
            .map { result in
                self.restaurantModel.fetchDoubleData(item: .lng, isSelected: true)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        let goalPostion = Driver.combineLatest(
            goalLat,
            goalLng
        ) { (lat: $0, lng: $1) }
        
        let goConditionalInputView = input.tappedBackButton.asObservable()
            .map { _ in
                return true
            }
            .asDriver(onErrorDriveWith: .empty())
        
        return mapViewOutput(
            comunnicationState: comunnicationState,
            myLat: myLat,
            myLng: myLng,
            myPosition: myPosition,
            gatRestaurantData: gatRestaurantData,
            goalLat: goalLat,
            goalLng: goalLng,
            goalPostion: goalPostion,
            goConditionalInputView: goConditionalInputView
        )
    }
}


