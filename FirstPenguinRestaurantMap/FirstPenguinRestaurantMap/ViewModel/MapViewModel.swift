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
    private let resutaurantModel: ResutaurantModel = ResutaurantModel()
}

extension MapViewModel: MapViewModelType {
    
    struct mapViewInput {
        // 画面の展開
        let isMadeStoryboard: Observable<[Any]>
        // 電波の状況
        let comunnicationState: Observable<[Any]>
        
        let myLat: Observable<[Any]>
        let myLng: Observable<[Any]>
        
        let tappedBackButton: Observable<[Any]>
    }
    
    struct mapViewOutput {
        
        // 通信状況
        let comunnicationState: Driver<networkstate>
        // 距離
        let lat: Driver<String>
        let lng: Driver<String>
        let myPosition: Driver<(latString: String, lngString: String)>
        
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
        let lat = input.myLat.asObservable()
            .map { lat in
                return lat.first as! String
            }
            .asDriver(onErrorDriveWith: .empty())
        
        let lng = input.myLng.asObservable()
            .map { lng in
                return lng.first as! String
            }
            .asDriver(onErrorDriveWith: .empty())
        
        
        let myPosition = Driver.combineLatest(
            lat,
            lng
        ) { (latString: $0, lngString: $1) }
        
        let goConditionalInputView = input.tappedBackButton.asObservable()
            .map { _ in
                return true
            }
            .asDriver(onErrorDriveWith: .empty())
        
        return mapViewOutput(
            comunnicationState: comunnicationState,
            lat: lat,
            lng: lng,
            myPosition: myPosition,
            goConditionalInputView: goConditionalInputView
        )
    }
}


