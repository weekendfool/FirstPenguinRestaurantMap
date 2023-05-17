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
        let resutaurantNameLabel: Driver<String>
        let accessLabel: Driver<String>
        let resutaurantImageView: Driver<URL>
        
        
    }
    
    func transform(input: intuitionSelectViewInput) -> intuitionSelectViewOutput {
        
        return intuitionSelectViewOutput(
            comunnicationState: <#T##Driver<networkstate>#>,
            resutaurantNameLabel: <#T##Driver<String>#>,
            accessLabel: <#T##Driver<String>#>,
            resutaurantImageView: <#T##Driver<URL>#>
        )
    }
}
