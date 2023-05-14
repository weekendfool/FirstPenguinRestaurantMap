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
    associatedtype viewModelInput
    associatedtype viewModelOutput
    
    func transform(input: viewModelInput) -> viewModelOutput
}


final class ConditionalInputViewModel {

}

extension ConditionalInputViewModel: ConditionalInputViewModelType {
   
    
    
    struct viewModelInput {
        // 画面の展開
        let isMadeStoryboard: Observable<[Any]>
        // スライダー
        let inputDistanceSlider: Observable<Int>
        // button
        let tappedSearchButton: Signal<Void>
        // mapView
        let inputMapView: Signal<Void>
        
        // 電波の状況
        let comunnicationState: Observable<[Any]>
    }
    
    struct viewModelOutput {
        // 距離
        let distance: Driver<Float>
    }
    
    
    func transform(input: viewModelInput) -> viewModelOutput {
        <#code#>
    }
    
}
