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
    private let resutaurantModel: ResutaurantModel = ResutaurantModel()
}

extension ConditionalInputViewModel: ConditionalInputViewModelType {
   
    
    
    struct viewModelInput {
        // 画面の展開
        let isMadeStoryboard: Observable<[Any]>
        // スライダー
//        let inputDistanceSlider: Observable<Float>
        
        // 自分の位置
//        let myPosition: Observable<>
        
        let myLat: Observable<[Any]>
        let myLng: Observable<[Any]>
        // button
        let tappedSearchButton: Signal<Void>
        // mapView
//        let inputMapView: Signal<Void>
        
        // 電波の状況
        let comunnicationState: Observable<[Any]>
    }
    
    struct viewModelOutput {
        // 通信状況
        let comunnicationState: Driver<networkstate>
        
        let getData: Driver<Data?>
        // 距離
        let lat: Driver<String>
        let lng: Driver<String>
        
        let distance: Driver<(latString: String, lngString: String)>
        // 画面遷移
        let goIntuitionSelectView: Driver<APIDataModel>
        
        // 情報の整理
        let getResutaurantData: Driver<Bool>
    }
    
    
    func transform(input: viewModelInput) -> viewModelOutput {
        
        // 通信状況
        let comunnicationState = input.comunnicationState
            .map { state in
                return state[0] as! networkstate
            }
            .asDriver(onErrorDriveWith: .empty())
        
//        let getData = input.tappedSearchButton.asObservable()
//            .withLatestFrom(input.myPosition) { tapped, distance  in
//                self.apiModel.getData(lat: String(distance.), lng: String(distance), range: .first)
//            }
//            .merge()
//            .asDriver(onErrorDriveWith: .empty())
        
       
        
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
        
        
        let distance = Driver.combineLatest(
            lat,
            lng
        ) { (latString: $0, lngString: $1) }
        
        let getData = input.tappedSearchButton.asObservable()
            .withLatestFrom(distance) { _, distance in
                self.apiModel.getData(lat: distance.latString, lng: distance.lngString, range: .third)
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
        
        let getResutaurantData = goIntuitionSelectView.asObservable()
            .map { data in
                self.resutaurantModel.getData(data: data)
            }
            .merge()
            .asDriver(onErrorDriveWith: .empty())
       
        
        return viewModelOutput(
            comunnicationState: comunnicationState,
            getData: getData,
            lat: lat,
            lng: lng,
            distance: distance,
            goIntuitionSelectView: goIntuitionSelectView,
            getResutaurantData: getResutaurantData
        )
    }
    
}
