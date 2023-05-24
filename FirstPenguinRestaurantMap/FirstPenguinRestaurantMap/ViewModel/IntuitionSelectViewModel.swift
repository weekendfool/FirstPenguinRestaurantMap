//
//  IntuitionSelectViewModel.swift
//  FirstPenguinRestaurantMap
//
//  Created by Oh!ara on 2023/05/13.
//

import Foundation
import RxCocoa
import RxSwift

protocol IntuitionSelectViewModelType {
    associatedtype intuitionSelectViewInput
    associatedtype intuitionSelectViewOutput
    
    func transform(input: intuitionSelectViewInput) -> intuitionSelectViewOutput
}


final class IntuitionSelectViewModel {
    private let restaurantModel: RestaurantModel = RestaurantModel()
}

extension IntuitionSelectViewModel: IntuitionSelectViewModelType {
    
    struct intuitionSelectViewInput {
        // 画面の展開
        let isMadeStoryboard: Observable<[Any]>
        // 電波の状況
        let comunnicationState: Observable<[Any]>
        //
        let tappedBadButton: Signal<Void>
        let tappedGoodButton: Signal<Void>
        // viewのタップ
        let tappedRestaurantInfoView: Observable<[Any]>
        
        // 画面遷移
        let tappedGoMapViewButton: Signal<Void>
    }
    
    struct intuitionSelectViewOutput {
        // 通信状況
        let comunnicationState: Driver<networkstate>
        
        let reloadRestaurantData: Driver<Bool>
        
        let gatImageUrl: Driver<URL>
        
        // label
        let firstNumberOfRestaurantsLabel: Driver<String>
        let firstRestaurantNameLabel: Driver<String>
        let firstAccessLabel: Driver<String>
        let firstRestaurantImageView: Driver<String>
        
        let changeCounterByBadButton: Driver<Bool>
        let changeCounterByGoodButton: Driver<Bool>
        
        let numberOfRestaurantsLabelByBadButton: Driver<String>
        let restaurantNameLabelByBadButton: Driver<String>
        let accessLabelByBadButton: Driver<String>
        let restaurantImageViewByBadButton: Driver<String>
        let goMapViewByBadButton: Driver<Bool>
        
        let numberOfRestaurantsLabelByGoodButton: Driver<String>
        let restaurantNameLabelByGoodButton: Driver<String>
        let accessLabelByGoodButton: Driver<String>
        let restaurantImageViewByGoodButton: Driver<String>
        
        let goMapViewByGoodButton: Driver<Bool>
        let goRestaurantInfoView: Driver<Bool>
        
        
    }
    
    func transform(input: intuitionSelectViewInput) -> intuitionSelectViewOutput {
        
        // 通信状況
        let comunnicationState = input.comunnicationState
            .map { state in
                return state[0] as! networkstate
            }
            .asDriver(onErrorDriveWith: .empty())
        
        let reloadRestaurantData = input.isMadeStoryboard
            .map { _ in
                self.restaurantModel.reloadRestaurantArray(isSelected: false)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        // 初期設定
        let firstNumberOfRestaurantsLabel = input.isMadeStoryboard
            .map { _ in
                self.restaurantModel.fetchStringData(item: .numberOfRestaurants, isSelected: false)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        let firstRestaurantNameLabel = firstNumberOfRestaurantsLabel.asObservable()
            .filter { $0 != "0"}
            .map { _ in
                self.restaurantModel.fetchStringData(item: .name, isSelected: false)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        let firstAccessLabel = firstNumberOfRestaurantsLabel.asObservable()
            .filter { $0 != "0"}
            .map { _ in
                self.restaurantModel.fetchStringData(item: .access, isSelected: false)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        let firstRestaurantImageView = firstNumberOfRestaurantsLabel.asObservable()
            .filter { $0 != "0"}
            .map { _ in
                self.restaurantModel.fetchStringData(item: .imageURL, isSelected: false)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        let gatImageUrl = firstRestaurantImageView.asObservable()
            .map { urlString in
                return URL(string: urlString)!
            }
            .asDriver(onErrorDriveWith: .empty())
        
        
        // 二件目以降：by BadButton
        let changeCounterByBadButton = input.tappedBadButton.asObservable()
            .map { _ in
                self.restaurantModel.selectData(isSelected: false)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        
        
        
        // 表示
        let numberOfRestaurantsLabelByBadButton = changeCounterByBadButton.asObservable()
            .map { _ in
                self.restaurantModel.fetchStringData(item: .numberOfRestaurants, isSelected: false)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        let restaurantNameLabelByBadButton = numberOfRestaurantsLabelByBadButton.asObservable()
            .filter { $0 != "0"}
            .map { _ in
                self.restaurantModel.fetchStringData(item: .name, isSelected: false)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        let accessLabelByBadButton = numberOfRestaurantsLabelByBadButton.asObservable()
            .filter { $0 != "0"}
            .map { _ in
                self.restaurantModel.fetchStringData(item: .access, isSelected: false)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        
        let restaurantImageViewByBadButton = numberOfRestaurantsLabelByBadButton.asObservable()
            .filter { $0 != "0"}
            .map { _ in
                self.restaurantModel.fetchStringData(item: .imageURL, isSelected: false)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        let goMapViewByBadButton = numberOfRestaurantsLabelByBadButton.asObservable()
            .filter { $0 == "0"}
            .map { _ in
                return true
            }
            .asDriver(onErrorDriveWith: .empty())
        
        
        // 二件目以降：by GoodButton
        let changeCounterByGoodButton = input.tappedGoodButton.asObservable()
            .map { _ in
                self.restaurantModel.selectData(isSelected: true)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        
        let numberOfRestaurantsLabelByGoodButton = changeCounterByGoodButton.asObservable()
            .map { _ in
                self.restaurantModel.fetchStringData(item: .numberOfRestaurants, isSelected: false)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        let restaurantNameLabelByGoodButton = numberOfRestaurantsLabelByGoodButton.asObservable()
            .filter { $0 != "0"}
            .map { _ in
                self.restaurantModel.fetchStringData(item: .name, isSelected: false)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        let accessLabelByGoodButton = numberOfRestaurantsLabelByGoodButton.asObservable()
            .filter { $0 != "0"}
            .map { _ in
                self.restaurantModel.fetchStringData(item: .access, isSelected: false)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        let restaurantImageViewByGoodButton = numberOfRestaurantsLabelByGoodButton.asObservable()
            .filter { $0 != "0"}
            .map { _ in
                self.restaurantModel.fetchStringData(item: .imageURL, isSelected: false)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        let goMapViewByGoodButton = numberOfRestaurantsLabelByGoodButton.asObservable()
            .filter { $0 == "0"}
            .map { _ in
                return true
            }
            .asDriver(onErrorDriveWith: .empty())
        
        let goRestaurantInfoView = input.tappedRestaurantInfoView
            .map { _ in
                self.restaurantModel.selectRestaurant(indexPath: 0)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        
        
        
        return intuitionSelectViewOutput(
            comunnicationState: comunnicationState,
            reloadRestaurantData: reloadRestaurantData,
            gatImageUrl: gatImageUrl,
            firstNumberOfRestaurantsLabel: firstNumberOfRestaurantsLabel,
            firstRestaurantNameLabel: firstRestaurantNameLabel,
            firstAccessLabel: firstAccessLabel,
            firstRestaurantImageView: firstRestaurantImageView,
            changeCounterByBadButton: changeCounterByBadButton,
            changeCounterByGoodButton: changeCounterByGoodButton,
            numberOfRestaurantsLabelByBadButton: numberOfRestaurantsLabelByBadButton,
            
            restaurantNameLabelByBadButton: restaurantNameLabelByBadButton,
            accessLabelByBadButton: accessLabelByBadButton,
            restaurantImageViewByBadButton: restaurantImageViewByBadButton,
            goMapViewByBadButton: goMapViewByBadButton,
            numberOfRestaurantsLabelByGoodButton: numberOfRestaurantsLabelByGoodButton,
            
            restaurantNameLabelByGoodButton: restaurantNameLabelByGoodButton,
            accessLabelByGoodButton: accessLabelByGoodButton,
            restaurantImageViewByGoodButton: restaurantImageViewByGoodButton,
            goMapViewByGoodButton: goMapViewByGoodButton,
            goRestaurantInfoView: goRestaurantInfoView
        )
    }
}
