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

    private let apiModel: APIModel = APIModel()
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
        // 通信状況
        let comunnicationState: Driver<networkstate>
        
        let getData: Driver<Data?>
        // 距離
//        let distance: Driver<Float>
        // 画面遷移
        let goIntuitionSelectView: Driver<[APIDataModel]>
    }
    
    
    func transform(input: viewModelInput) -> viewModelOutput {
        
        // 通信状況
        let comunnicationState = input.comunnicationState
            .map { state in
                return state[0] as! networkstate
            }
            .asDriver(onErrorDriveWith: .empty())
        
        let getData = input.tappedSearchButton.asObservable()
            .withLatestFrom(input.inputDistanceSlider) { tapped, distance  in
                self.apiModel.getData(lat: String(distance), lng: String(distance), range: .first)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
        
        let goIntuitionSelectView = getData.asObservable()
            .filter { $0 != nil }
            .map { data in
                self.apiModel.decodeData(data: data!)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
       
        
        return viewModelOutput(
            comunnicationState: comunnicationState,
            getData: getData,
            goIntuitionSelectView: goIntuitionSelectView
        )
    }
    
}
