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
        // viewのタップ
        let tappedResutaurantInfoView: Observable<[Any]>
        
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
        let firstResutaurantNameLabel: Driver<String>
        let firstAccessLabel: Driver<String>
        let firstResutaurantImageView: Driver<String>
        
        let changeCounterByBadButton: Driver<Bool>
        let changeCounterByGoodButton: Driver<Bool>
        
        let numberOfRestaurantsLabelByBadButton: Driver<String>
        let resutaurantNameLabelByBadButton: Driver<String>
        let accessLabelByBadButton: Driver<String>
        let resutaurantImageViewByBadButton: Driver<String>
        let goMapViewByBadButton: Driver<Bool>
        
        let numberOfRestaurantsLabelByGoodButton: Driver<String>
        let resutaurantNameLabelByGoodButton: Driver<String>
        let accessLabelByGoodButton: Driver<String>
        let resutaurantImageViewByGoodButton: Driver<String>
        
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
                self.resutaurantModel.reloadResutaurantArray()
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        // 初期設定
        let firstNumberOfRestaurantsLabel = input.isMadeStoryboard
            .map { _ in
                self.resutaurantModel.fetchStringData(item: .numberOfRestaurants)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        let firstResutaurantNameLabel = firstNumberOfRestaurantsLabel.asObservable()
            .filter { $0 != "0"}
            .map { _ in
                self.resutaurantModel.fetchStringData(item: .name)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        let firstAccessLabel = firstNumberOfRestaurantsLabel.asObservable()
            .filter { $0 != "0"}
            .map { _ in
                self.resutaurantModel.fetchStringData(item: .access)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        let firstResutaurantImageView = firstNumberOfRestaurantsLabel.asObservable()
            .filter { $0 != "0"}
            .map { _ in
                self.resutaurantModel.fetchStringData(item: .imageURL)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        let gatImageUrl = firstResutaurantImageView.asObservable()
            .map { urlString in
                return URL(string: urlString)!
            }
            .asDriver(onErrorDriveWith: .empty())
        
        
        // 二件目以降：by BadButton
        let changeCounterByBadButton = input.tappedBadButton.asObservable()
            .map { _ in
                self.resutaurantModel.selectData(isSelected: false)
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
        
        let resutaurantNameLabelByBadButton = numberOfRestaurantsLabelByBadButton.asObservable()
            .filter { $0 != "0"}
            .map { _ in
                self.resutaurantModel.fetchStringData(item: .name)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        let accessLabelByBadButton = numberOfRestaurantsLabelByBadButton.asObservable()
            .filter { $0 != "0"}
            .map { _ in
                self.resutaurantModel.fetchStringData(item: .access)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        
        let resutaurantImageViewByBadButton = numberOfRestaurantsLabelByBadButton.asObservable()
            .filter { $0 != "0"}
            .map { _ in
                self.resutaurantModel.fetchStringData(item: .imageURL)
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
                self.resutaurantModel.selectData(isSelected: true)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        
        let numberOfRestaurantsLabelByGoodButton = changeCounterByGoodButton.asObservable()
            .map { _ in
                self.resutaurantModel.fetchStringData(item: .numberOfRestaurants)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        let resutaurantNameLabelByGoodButton = numberOfRestaurantsLabelByGoodButton.asObservable()
            .filter { $0 != "0"}
            .map { _ in
                self.resutaurantModel.fetchStringData(item: .name)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        let accessLabelByGoodButton = numberOfRestaurantsLabelByGoodButton.asObservable()
            .filter { $0 != "0"}
            .map { _ in
                self.resutaurantModel.fetchStringData(item: .access)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        let resutaurantImageViewByGoodButton = numberOfRestaurantsLabelByGoodButton.asObservable()
            .filter { $0 != "0"}
            .map { _ in
                self.resutaurantModel.fetchStringData(item: .imageURL)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        let goMapViewByGoodButton = numberOfRestaurantsLabelByGoodButton.asObservable()
            .filter { $0 == "0"}
            .map { _ in
                return true
            }
            .asDriver(onErrorDriveWith: .empty())
        
        let goRestaurantInfoView = input.tappedResutaurantInfoView
            .map { _ in
                return true
            }
            .asDriver(onErrorDriveWith: .empty())
        
        
        
        
        return intuitionSelectViewOutput(
            comunnicationState: comunnicationState,
            reloadRestaurantData: reloadRestaurantData,
            gatImageUrl: gatImageUrl,
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
            goMapViewByBadButton: goMapViewByBadButton,
            numberOfRestaurantsLabelByGoodButton: numberOfRestaurantsLabelByGoodButton,
            
            resutaurantNameLabelByGoodButton: resutaurantNameLabelByGoodButton,
            accessLabelByGoodButton: accessLabelByGoodButton,
            resutaurantImageViewByGoodButton: resutaurantImageViewByGoodButton,
            goMapViewByGoodButton: goMapViewByGoodButton,
            goRestaurantInfoView: goRestaurantInfoView
        )
    }
}
