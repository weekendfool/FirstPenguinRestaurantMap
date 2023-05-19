//
//  MapViewController.swift
//  FirstPenguinRestaurantMap
//
//  Created by Oh!ara on 2023/05/13.
//

import UIKit
import MapKit
import CoreLocation
import RxCocoa
import RxSwift

class MapViewController: UIViewController {
    
    // MARK: - UIパーツ
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var finishedButton: UIButton!
    
    // MARK: - 変数
    
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

        // Do any additional setup after loading the view.
        setupUserLocation()
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
    static func makeFromStoryboard() -> MapViewController {
        let vc = UIStoryboard.mapViewController
        
        print("ttttttttttttttttttt")
        
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
}

// MARK: - extension

extension MapViewController: MKMapViewDelegate {
    //　自己位置更新
    @objc func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        print("更新")
        userLat = String(userLocation.coordinate.latitude)
        userLng = String(userLocation.coordinate.longitude)
        print("userLat : \(userLat)")
        print("userLng : \(userLng)")
        
    }
}

extension MapViewController {
    @objc func getNetworkState(state: Any) {
        // 登録する
    }
}

// 緯度と経度
extension MapViewController {
    @objc func changeLat(lat: Any) {
        // 登録する
    }
}

extension MapViewController {
    @objc func changeLng(lng: Any) {
        // 登録する
    }
}
