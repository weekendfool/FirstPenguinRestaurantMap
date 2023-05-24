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
    private let restaurantModel: RestaurantModel = RestaurantModel()
}


extension RestaurantInfoViewModel: RestaurantInfoViewModelType {
    
    struct restaurantInfoViewInput {
        
        // 画面の展開
        let isMadeStoryboard: Observable<[Any]>
        // 電波の状況
        let comunnicationState: Observable<[Any]>
        
    }
    
    struct restaurantInfoViewOutput {
        // 通信状況
        let comunnicationState: Driver<networkstate>
        
        let reloadRestaurantData: Driver<Bool>
                
        
        let restaurantName: Driver<String>
        let restaurantAdress: Driver<String>
        let restaurantBusinessHours: Driver<String>
        let creditCard: Driver<String>
        let restaurantImageUrlString: Driver<String>
        
        
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
                self.restaurantModel.reloadRestaurantArray(isSelected: true)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        let restaurantName = reloadRestaurantData.asObservable()
            .filter { $0 == true}
            .map { result in
                self.restaurantModel.fetchStringData(item: .name, isSelected: true)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        let restaurantAdress = reloadRestaurantData.asObservable()
            .filter { $0 == true}
            .map { result in
                self.restaurantModel.fetchStringData(item: .adress, isSelected: true)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        let restaurantBusinessHours = reloadRestaurantData.asObservable()
            .filter { $0 == true}
            .map { result in
                self.restaurantModel.fetchStringData(item: .businessHours, isSelected: true)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
         
        let creditCard = reloadRestaurantData.asObservable()
            .filter { $0 == true}
            .map { result in
                self.restaurantModel.fetchStringData(item: .creditCard, isSelected: true)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        let restaurantImageUrlString = reloadRestaurantData.asObservable()
            .filter { $0 == true}
            .map { result in
                self.restaurantModel.fetchStringData(item: .imageURL, isSelected: true)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
     
        
        return restaurantInfoViewOutput(
            comunnicationState: comunnicationState,
            reloadRestaurantData: reloadRestaurantData,
            restaurantName: restaurantName,
            restaurantAdress: restaurantAdress,
            restaurantBusinessHours: restaurantBusinessHours,
            creditCard: creditCard,
            restaurantImageUrlString: restaurantImageUrlString
        )
    }
}
