//
//  CarefullySelectViewModel.swift
//  FirstPenguinRestaurantMap
//
//  Created by Oh!ara on 2023/05/13.
//

import Foundation
import RxSwift
import RxCocoa

protocol CarefullySelectViewModelType {
    
    associatedtype carefullySelectViewInput
    associatedtype carefullySelectViewOutput
    
    func transform(input: carefullySelectViewInput) -> carefullySelectViewOutput
    
}


final class CarefullySelectViewModel {
    private let resutaurantModel: ResutaurantModel = ResutaurantModel()
    
}

extension CarefullySelectViewModel: CarefullySelectViewModelType {
    
    struct carefullySelectViewInput {
        // 画面の展開
        let isMadeStoryboard: Observable<[Any]>
        // 電波の状況
        let comunnicationState: Observable<[Any]>
        // 画面遷移
        let goMapView: Signal<Void>
    }
    
    struct carefullySelectViewOutput {
        // 通信状況
        let comunnicationState: Driver<networkstate>
        
        let reloadRestaurantData: Driver<Bool>
        let restaurantData: Driver<[RestaurantDataModel]>
        
        let goMapView: Driver<Bool>
    }
    
    func transform(input: carefullySelectViewInput) -> carefullySelectViewOutput {
        
        // 通信状況
        let comunnicationState = input.comunnicationState
            .map { state in
                return state[0] as! networkstate
            }
            .asDriver(onErrorDriveWith: .empty())
        
        let reloadRestaurantData = input.isMadeStoryboard
            .map { _ in
                self.resutaurantModel.reloadResutaurantArray()
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        let restaurantData = reloadRestaurantData.asObservable()
            .filter {$0 == true }
            .map { result in
                self.resutaurantModel.setResutaurantData()
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        let goMapView = input.goMapView.asObservable()
            .map { _ in
                return true
            }
            .asDriver(onErrorDriveWith: .empty())
        
        return carefullySelectViewOutput(
            comunnicationState: comunnicationState,
            reloadRestaurantData: reloadRestaurantData,
            restaurantData: restaurantData,
            goMapView: goMapView
        )
    }
}
