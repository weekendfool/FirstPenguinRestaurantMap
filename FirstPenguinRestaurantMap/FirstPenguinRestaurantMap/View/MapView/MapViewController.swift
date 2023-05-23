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
import EMTNeumorphicView

class MapViewController: UIViewController {
    
    // MARK: - UIパーツ
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var finishedButton: EMTNeumorphicButton!
    @IBOutlet weak var baseView: EMTNeumorphicView!
    
    // MARK: - 変数
    
    let viewModel: MapViewModel = MapViewModel()
    
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
    
    var goalLat: Double = 0.0
    var goalLng: Double = 0.0
    // MARK: - ライフサイクル
   
   

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUserLocation()
        
        setupUI()
        
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
    static func makeFromStoryboard() -> MapViewController {
        let vc = UIStoryboard.mapViewController
        
        
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
    
    private func setupUI() {
        
        // baseView
        baseView.neumorphicLayer!.elementBackgroundColor = view.backgroundColor?.cgColor ?? .init(red: 253 / 255, green: 184 / 255, blue: 109 / 255, alpha: 1)
        baseView.neumorphicLayer?.cornerRadius = 24
        baseView.neumorphicLayer?.depthType = .convex
        baseView.neumorphicLayer?.elementDepth = 7
        
        // finishedButton
        finishedButton.neumorphicLayer!.elementBackgroundColor = view.backgroundColor?.cgColor ?? .init(red: 253 / 255, green: 184 / 255, blue: 109 / 255, alpha: 1)
        finishedButton.neumorphicLayer?.cornerRadius = 24
        finishedButton.neumorphicLayer?.depthType = .convex
        finishedButton.neumorphicLayer?.elementDepth = 7
    }
    
    //道案内
    func setRoot(goalLat: Double, goalLng: Double) {
        // ゴール
        let goalLocation = CLLocationCoordinate2D(latitude: goalLat, longitude: goalLng)
        // 自分の位置
        let myLocation = CLLocationCoordinate2D(latitude: Double(userLat)!, longitude: Double(userLng)!)
        
        // ゴール地点のピン
        let anotation = MKPointAnnotation()
        // 位置
        anotation.coordinate = goalLocation
        // メッセージ
        anotation.title = "目的地"
        mapView.addAnnotation(anotation)
        
        let goalPlaceMark = MKPlacemark(coordinate: goalLocation)
        let myPlaceMark = MKPlacemark(coordinate: myLocation)
        
        // ルートのリクエスト
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: goalPlaceMark)
        directionRequest.destination = MKMapItem(placemark: myPlaceMark)
        // 歩き移動
        directionRequest.transportType = .walking
        
        print("pppppppp")
        
        //
        let directions = MKDirections(request: directionRequest)
        directions.calculate { result, error in
            guard let directionResons = result else {
                if let error = error {
                    print("======================")
                    print("error at setRoot(): \(error)")
                }
                return
            }
            
            // ルートの追加
            
            let route = directionResons.routes[0]
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            
        }
        
        
    }
    
    
    // 紐付け
    private func bindViewModel() {
        
        let isMadeStoryboard = rx.methodInvoked(#selector(viewWillAppear(_:)))
        let comunnicationState = rx.methodInvoked(#selector(getNetworkState))
        let myLat = rx.methodInvoked(#selector(changeLat))
        let myLng = rx.methodInvoked(#selector(changeLng))
        
        let input = MapViewModel.mapViewInput(
            isMadeStoryboard: isMadeStoryboard,
            comunnicationState: comunnicationState,
            myLat: myLat,
            myLng: myLng,
            tappedBackButton: finishedButton.rx.tap.asSignal()
        )
        
        let output = viewModel.transform(input: input)
        
        // 通信状況
        output.comunnicationState
            .drive { [weak self] state in
                
            }
            .disposed(by: disposeBag)
        
        // 位置情報
        output.myLat
            .drive { lat in
            }
            .disposed(by: disposeBag)
        
        output.myLng
            .drive { lng in
            }
            .disposed(by: disposeBag)
        
        output.myPosition
            .drive { position in
                print("position: \(position)")
            }
            .disposed(by: disposeBag)
        
        output.gatResutaurantData
            .drive { result in
                
            }
            .disposed(by: disposeBag)
        
        output.goalLat
            .drive { goalLat in
                
            }
            .disposed(by: disposeBag)
        
        output.goalLng
            .drive { goalLat in
                
            }
            .disposed(by: disposeBag)
        
        output.goalPostion
            .drive { goalPostion in
                self.setRoot(goalLat: goalPostion.lat, goalLng: goalPostion.lng)
            }
            .disposed(by: disposeBag)
        
        output.goConditionalInputView
            .drive { result in
                
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - extension

extension MapViewController: MKMapViewDelegate {
    //　自己位置更新
    @objc func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        userLat = String(userLocation.coordinate.latitude)
        userLng = String(userLocation.coordinate.longitude)
        
        
        
    }
}

extension MapViewController {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 4.0
        return renderer
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
