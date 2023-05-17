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
    private let resutaurantModel: ResutaurantModel = ResutaurantModel()
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
        // 画面遷移
        let goMapView: Signal<Void>
    }
    
    struct intuitionSelectViewOutput {
        // 通信状況
        let comunnicationState: Driver<networkstate>
        
        // label
        let firstNumberOfRestaurantsLabel: Driver<String>
        let firstResutaurantNameLabel: Driver<String>
        let firstAccessLabel: Driver<String>
        let firstResutaurantImageView: Driver<String>
        
        let changeCounterByBadButton: Driver<Bool>
        let changeCounterByGoodButton: Driver<Bool>
        
        let numberOfRestaurantsLabelByBadButton: Driver<String>
        let resutaurantNameLabelByBadButton: Driver<String>
        let accessLabelByBadButton: Driver<String>
        let resutaurantImageViewByBadButton: Driver<String>
        
        
        let numberOfRestaurantsLabelByGoodButton: Driver<String>
        let resutaurantNameLabelByGoodButton: Driver<String>
        let accessLabelByGoodButton: Driver<String>
        let resutaurantImageViewByGoodButton: Driver<String>
        
        
    }
    
    func transform(input: intuitionSelectViewInput) -> intuitionSelectViewOutput {
        
        // 通信状況
        let comunnicationState = input.comunnicationState
            .map { state in
                return state[0] as! networkstate
            }
            .asDriver(onErrorDriveWith: .empty())
        
        // 初期設定
        let firstNumberOfRestaurantsLabel = input.isMadeStoryboard
            .map { _ in
                self.resutaurantModel.fetchStringData(item: .numberOfRestaurants)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        let firstResutaurantNameLabel = input.isMadeStoryboard
            .map { _ in
                self.resutaurantModel.fetchStringData(item: .name)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        let firstAccessLabel = input.isMadeStoryboard
            .map { _ in
                self.resutaurantModel.fetchStringData(item: .access)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        let firstResutaurantImageView = input.isMadeStoryboard
            .map { _ in
                self.resutaurantModel.fetchStringData(item: .imageURL)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        let changeCounterByBadButton = input.tappedBadButton.asObservable()
            .map { _ in
                self.resutaurantModel.selectData(isSelected: false)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        let changeCounterByGoodButton = input.tappedGoodButton.asObservable()
            .map { _ in
                self.resutaurantModel.selectData(isSelected: true)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        
        // 表示
        let numberOfRestaurantsLabelByBadButton = changeCounterByBadButton.asObservable()
            .map { _ in
                self.resutaurantModel.fetchStringData(item: .numberOfRestaurants)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        let resutaurantNameLabelByBadButton = changeCounterByBadButton.asObservable()
            .map { _ in
                self.resutaurantModel.fetchStringData(item: .name)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        let accessLabelByBadButton = changeCounterByBadButton.asObservable()
            .map { _ in
                self.resutaurantModel.fetchStringData(item: .access)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        
        let resutaurantImageViewByBadButton = changeCounterByBadButton.asObservable()
            .map { _ in
                self.resutaurantModel.fetchStringData(item: .imageURL)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        let numberOfRestaurantsLabelByGoodButton = changeCounterByGoodButton.asObservable()
            .map { _ in
                self.resutaurantModel.fetchStringData(item: .numberOfRestaurants)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        let resutaurantNameLabelByGoodButton = changeCounterByGoodButton.asObservable()
            .map { _ in
                self.resutaurantModel.fetchStringData(item: .name)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        let accessLabelByGoodButton = changeCounterByGoodButton.asObservable()
            .map { _ in
                self.resutaurantModel.fetchStringData(item: .access)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        let resutaurantImageViewByGoodButton = changeCounterByGoodButton.asObservable()
            .map { _ in
                self.resutaurantModel.fetchStringData(item: .imageURL)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        
        
        
        return intuitionSelectViewOutput(
            comunnicationState: comunnicationState,
            firstNumberOfRestaurantsLabel: firstNumberOfRestaurantsLabel,
            firstResutaurantNameLabel: firstResutaurantNameLabel,
            firstAccessLabel: firstAccessLabel,
            firstResutaurantImageView: firstResutaurantImageView,
            changeCounterByBadButton: changeCounterByBadButton,
            changeCounterByGoodButton: changeCounterByGoodButton,
            numberOfRestaurantsLabelByBadButton: numberOfRestaurantsLabelByBadButton,
            
            resutaurantNameLabelByBadButton: resutaurantNameLabelByBadButton,
            accessLabelByBadButton: accessLabelByBadButton,
            resutaurantImageViewByBadButton: resutaurantImageViewByBadButton,
            numberOfRestaurantsLabelByGoodButton: numberOfRestaurantsLabelByGoodButton,
            
            resutaurantNameLabelByGoodButton: resutaurantNameLabelByGoodButton,
            accessLabelByGoodButton: accessLabelByGoodButton,
            resutaurantImageViewByGoodButton: resutaurantImageViewByGoodButton
        )
    }
}
