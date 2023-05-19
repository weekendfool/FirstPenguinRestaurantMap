//
//  RestaurantInfoViewModel.swift
//  FirstPenguinRestaurantMap
//
//  Created by Oh!ara on 2023/05/13.
//

import Foundation
import RxCocoa
import RxSwift


protocol RestaurantInfoViewModelType {
    associatedtype restaurantInfoViewInput
    associatedtype restaurantInfoViewOutput
    
    func transform(input: restaurantInfoViewInput) -> restaurantInfoViewOutput
}


final class RestaurantInfoViewModel {
    private let apiModel: APIModel = APIModel()
    private let resutaurantModel: ResutaurantModel = ResutaurantModel()
}


extension RestaurantInfoViewModel: RestaurantInfoViewModelType {
    
    struct restaurantInfoViewInput {
        
        // 画面の展開
        let isMadeStoryboard: Observable<[Any]>
        // 電波の状況
        let comunnicationState: Observable<[Any]>
        
        let tappedGoMapView: Signal<Void>
    }
    
    struct restaurantInfoViewOutput {
        // 通信状況
        let comunnicationState: Driver<networkstate>
        
        let reloadRestaurantData: Driver<Bool>
                
        let resutaurantName: Driver<String>
        let resutaurantAdress: Driver<String>
        let resutaurantBusinessHours: Driver<String>
        let creditCardLabel: Driver<creidtCardState>
        let resutaurantImageView: Driver<String>
        
        let goMapView: Driver<Bool>
        
    }
    
    func transform(input: restaurantInfoViewInput) -> restaurantInfoViewOutput {
        
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
        
        let resutaurantName = reloadRestaurantData.asObservable()
            .filter { $0 == true}
            .map { result in
                self.resutaurantModel.fetchStringData(item: .name)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        let resutaurantAdress = reloadRestaurantData.asObservable()
            .filter { $0 == true}
            .map { result in
                self.resutaurantModel.fetchStringData(item: .adress)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        let resutaurantBusinessHours = reloadRestaurantData.asObservable()
            .filter { $0 == true}
            .map { result in
                self.resutaurantModel.fetchStringData(item: .businessHours)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
         
        let creditCardLabel = reloadRestaurantData.asObservable()
            .filter { $0 == true}
            .map { result in
                self.resutaurantModel.fetchStringData(item: .creditCard)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        let resutaurantImageView = reloadRestaurantData.asObservable()
            .filter { $0 == true}
            .map { result in
                self.resutaurantModel.fetchStringData(item: .imageURL)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        let goMapView = input.tappedGoMapView.asObservable()
            .map { _ in
                return true
            }
            .asDriver(onErrorDriveWith: .empty())
        
        
        return restaurantInfoViewOutput(
            comunnicationState: comunnicationState,
            reloadRestaurantData: reloadRestaurantData,
            resutaurantName: resutaurantName,
            resutaurantAdress: resutaurantAdress,
            resutaurantBusinessHours: resutaurantBusinessHours,
            creditCardLabel: creditCardLabel,
            resutaurantImageView: resutaurantImageView,
            goMapView: goMapView
        )
    }
}
