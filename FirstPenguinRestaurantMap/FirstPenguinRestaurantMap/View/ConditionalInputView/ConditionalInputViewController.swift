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
import CoreLocation

class ConditionalInputViewController: UIViewController {
    
    // MARK: - UIパーツ
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var distanceLabel: UILabel!
    
    // MARK: - 変数
    let viewModel = ConditionalInputViewModel()
    let disposeBag: DisposeBag = DisposeBag()
    let routerModel: RouterModel = RouterModel()
    // 通信エラー検知用
    private let nWPathMonitorModel: NWPathMonitorModel = NWPathMonitorModel()
    
    var userLocation = MKUserLocation()
    var locationManager = CLLocationManager()
    
    //　緯度経度取得用
    var userLat = "" {
        didSet {
            changeLat(lat: userLat)
        }
    }
    var userLng = ""{
        didSet {
            changeLng(lng: userLng)
        }
    }
    
    
    // MARK: - ライフサイクル
   
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        setupUserLocation()
        // viewmodelとの紐付け
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getNetworkState(state: networkstate.successfulCommunication as Any)

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        locationManager.stopUpdatingLocation()
    }
    

    // MARK: - 関数
    
    // 画面展開
    static func makeFromStoryboard() -> ConditionalInputViewController {
        let vc = UIStoryboard.conditionalInputViewController
                
        return vc
    }
    
    // 通信のセットアップ
    private func setupMonitorComunnication() {
        nWPathMonitorModel.monitorComunnication { state  in
             self.getNetworkState(state: state as Any)
         }
         
         nWPathMonitorModel.start()
    }
    
    // 位置情報のセットアップ
    private func setupUserLocation() {
        mapView?.mapType = .standard
        
        locationManager = CLLocationManager()
        CLLocationManager.locationServicesEnabled()
        
//        locationManager.delegate = self
        mapView.delegate = self
        
        let status = CLLocationManager.authorizationStatus()
        
        if status == CLAuthorizationStatus.notDetermined {
            locationManager.requestWhenInUseAuthorization()
           
        }

        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        print("userLocation: \(userLocation)")

        // 縮尺
        var ragion = mapView.region
        
        ragion.span.latitudeDelta = 0.02
        ragion.span.longitudeDelta = 0.02
        
        mapView.setRegion(ragion, animated: true)
    }
    
    // 紐付け
    private func bindViewModel() {
        let isMadeStoryboard = rx.methodInvoked(#selector(viewWillAppear(_:)))
        let comunnicationState = rx.methodInvoked(#selector(getNetworkState))
        let myLat = rx.methodInvoked(#selector(changeLat))
        let myLng = rx.methodInvoked(#selector(changeLng))
        
        
        
        let input = ConditionalInputViewModel.viewModelInput(
            isMadeStoryboard: isMadeStoryboard,
            myLat: myLat,
            myLng: myLng,
            tappedSearchButton: searchButton.rx.tap.asSignal(),
            comunnicationState: comunnicationState
        )
        
        let output = viewModel.transform(input: input)
        
        // 通信状況
        output.comunnicationState
            .drive { [weak self] state in
                
            }
            .disposed(by: disposeBag)
        
        output.lat
            .drive { lat in
                print("lat: \(lat)")
            }
            .disposed(by: disposeBag)
        
        output.lng
            .drive { lng in
                print("lng: \(lng)")
            }
            .disposed(by: disposeBag)
        
        output.distance
            .drive { distance in
                print("distance: \(distance)")
            }
            .disposed(by: disposeBag)
        
        output.getData
            .drive { data in
                print("----------------")
//                self.locationManager.requestWhenInUseAuthorization()
                print("data: \(data)")
                print("userlocation: \(self.userLocation.coordinate.latitude)")
            }
            .disposed(by: disposeBag)
        
        // 画面遷移
        output.goIntuitionSelectView
            .drive { [self] info in
                print("----------------")
                print("info: \(info)")
                
                
                
            }
            .disposed(by: disposeBag)
        
        output.getResutaurantData
            .drive { [self] result in
                
                if result {
                    routerModel.showIntuitionSelectViewController(from: self)
                }
            }
    }
    
}

// MARK: - extension

extension ConditionalInputViewController: MKMapViewDelegate {
    //　自己位置更新
    @objc func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        print("更新")
        userLat = String(userLocation.coordinate.latitude)
        userLng = String(userLocation.coordinate.longitude)
        print("userLat : \(userLat)")
        print("userLng : \(userLng)")
       
    }
}


extension ConditionalInputViewController {
    @objc func getNetworkState(state: Any) {
        // 登録する
    }
}

// 緯度と経度
extension ConditionalInputViewController {
    @objc func changeLat(lat: Any) {
        // 登録する
    }
}

extension ConditionalInputViewController {
    @objc func changeLng(lng: Any) {
        // 登録する
    }
}
