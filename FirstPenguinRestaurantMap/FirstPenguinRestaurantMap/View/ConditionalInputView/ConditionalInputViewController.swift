//
//  ConditionalInputViewController.swift
//  FirstPenguinRestaurantMap
//
//  Created by Oh!ara on 2023/05/13.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa

class ConditionalInputViewController: UIViewController {
    
    // MARK: - UIパーツ
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var distanceLabel: UILabel!
    
    // MARK: - 変数
    let viewModel = ConditionalInputViewModel()
    let disposeBag: DisposeBag = DisposeBag()
    // 通信エラー検知用
    private let nWPathMonitorModel: NWPathMonitorModel = NWPathMonitorModel()
    
    var userLocation = MKUserLocation()
    
    
    // MARK: - ライフサイクル
   
   
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView?.mapType = .standard
        
        var locationManager = CLLocationManager()
        CLLocationManager.locationServicesEnabled()
        
        
        let status = CLLocationManager.authorizationStatus()
        
        if status == CLAuthorizationStatus.notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        print("userLocation: \(userLocation)")
        
        let x = userLocation.coordinate.latitude
        // 祝作
        var ragion = mapView.region
        
//        ragion.center = userLocation
        ragion.span.latitudeDelta = 0.02
        ragion.span.longitudeDelta = 0.02
        
        mapView.setRegion(ragion, animated: true)

        // viewmodelとの紐付け
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getNetworkState(state: networkstate.successfulCommunication as Any)

    }
    

    // MARK: - 関数
    
    // 通信のセットアップ
    func setupMonitorComunnication() {
        nWPathMonitorModel.monitorComunnication { state  in
             self.getNetworkState(state: state as Any)
         }
         
         nWPathMonitorModel.start()
    }
    
    // 紐付け
    func bindViewModel() {
        let isMadeStoryboard = rx.methodInvoked(#selector(viewWillAppear(_:)))
        let comunnicationState = rx.methodInvoked(#selector(getNetworkState))
        let myPosition = rx.methodInvoked(#selector(getter: mapView))
        
        let input = ConditionalInputViewModel.viewModelInput(
            isMadeStoryboard: isMadeStoryboard,
            myPosition: myPosition,
            tappedSearchButton: searchButton.rx.tap.asSignal(),
            comunnicationState: comunnicationState
        )
        
        let output = viewModel.transform(input: input)
        
        // 通信状況
        output.comunnicationState
            .drive { [weak self] state in
                
            }
            .disposed(by: disposeBag)
        
        output.getData
            .drive { data in
                print("----------------")
                print("data: \(data)")
            }
            .disposed(by: disposeBag)
        
        // 画面遷移
        output.goIntuitionSelectView
            .drive { info in
                print("----------------")
                print("info: \(info)")
            }
            .disposed(by: disposeBag)
    }
    
}

// MARK: - extension

extension ConditionalInputViewController: MKMapViewDelegate {
    //　自己位置更新
    @objc func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        print("更新")
    }
}

extension ConditionalInputViewController {
    @objc func getNetworkState(state: Any) {
        // 登録する
    }
}
