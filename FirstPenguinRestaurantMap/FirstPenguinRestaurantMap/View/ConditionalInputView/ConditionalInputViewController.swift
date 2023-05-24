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
import EMTNeumorphicView

class ConditionalInputViewController: UIViewController {
    
    // MARK: - UIパーツ
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var goCarefullySelectViewButton: EMTNeumorphicButton!
    @IBOutlet weak var mapBaseView: EMTNeumorphicView!
    @IBOutlet weak var goIntuitionSelectViewButton: EMTNeumorphicButton!
    @IBOutlet weak var distanceSegumentedControl: UISegmentedControl!
    
    @IBOutlet weak var sefumentedControlBaseView: EMTNeumorphicView!
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
        
        setupUI()
        // viewmodelとの紐付け
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getNetworkState(state: networkstate.successfulCommunication as Any)

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
            self.locationManager.stopUpdatingLocation()
       
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
    
    // UI設定
    private func setupUI() {
        
        // goCarefullySelectViewButton
        goCarefullySelectViewButton.neumorphicLayer!.elementBackgroundColor = view.backgroundColor?.cgColor ?? .init(red: 253 / 255, green: 184 / 255, blue: 109 / 255, alpha: 1)
        goCarefullySelectViewButton.neumorphicLayer?.cornerRadius = 24
        goCarefullySelectViewButton.neumorphicLayer?.depthType = .convex
        goCarefullySelectViewButton.neumorphicLayer?.elementDepth = 7
        
         // goIntuitionSelectViewButton
        goIntuitionSelectViewButton.neumorphicLayer!.elementBackgroundColor = view.backgroundColor?.cgColor ?? .init(red: 253 / 255, green: 184 / 255, blue: 109 / 255, alpha: 1)
        goIntuitionSelectViewButton.neumorphicLayer?.cornerRadius = 24
        goIntuitionSelectViewButton.neumorphicLayer?.depthType = .convex
        goIntuitionSelectViewButton.neumorphicLayer?.elementDepth = 7
        
        // mapBaseView
        mapBaseView.neumorphicLayer!.elementBackgroundColor = view.backgroundColor?.cgColor ?? .init(red: 253 / 255, green: 184 / 255, blue: 109 / 255, alpha: 1)
        mapBaseView.neumorphicLayer?.cornerRadius = 24
        mapBaseView.neumorphicLayer?.depthType = .convex
        mapBaseView.neumorphicLayer?.elementDepth = 7
        
        // sefumentedControlBaseView
        sefumentedControlBaseView.neumorphicLayer!.elementBackgroundColor = view.backgroundColor?.cgColor ?? .init(red: 253 / 255, green: 184 / 255, blue: 109 / 255, alpha: 1)
        sefumentedControlBaseView.neumorphicLayer?.cornerRadius = 24
        sefumentedControlBaseView.neumorphicLayer?.depthType = .convex
        sefumentedControlBaseView.neumorphicLayer?.elementDepth = 7
        
        // distanceSegumentedControl
        distanceSegumentedControl.selectedSegmentIndex = 2
        
        // ボタンの無効化
        goCarefullySelectViewButton.isEnabled = false
        goIntuitionSelectViewButton.isEnabled = false
        
    }
    
    // 位置情報のセットアップ
    private func setupUserLocation() {
        
            
            mapView?.mapType = .standard
            
            locationManager = CLLocationManager()
            
            CLLocationManager.locationServicesEnabled()
            
            mapView.delegate = self
            
            let status = CLLocationManager.authorizationStatus()
            
            if status == CLAuthorizationStatus.notDetermined {
                locationManager.requestWhenInUseAuthorization()
               
            }
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .follow
            

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
        
        
        let input = ConditionalInputViewModel.conditionalInputViewInput(
            isMadeStoryboard: isMadeStoryboard,
            myLat: myLat,
            myLng: myLng,
            selectedRange: distanceSegumentedControl.rx.selectedSegmentIndex.asObservable(),
            tappedGoCarefullySelectViewButton: goCarefullySelectViewButton.rx.tap.asSignal(), tappedGoIntuitionSelectViewButton: goIntuitionSelectViewButton.rx.tap.asSignal(),
            comunnicationState: comunnicationState
        )
        
        let output = viewModel.transform(input: input)
        
        // 通信状況
        output.comunnicationState
            .drive { [self] state in
                if state == .failureCommunication {
                    showCommunicationAlert()
                }
                
            }
            .disposed(by: disposeBag)
        
        output.resetRestaurantData
            .drive { [self] result in
                if result {
                    // ボタンの有効化
                    goCarefullySelectViewButton.isEnabled = true
                    goIntuitionSelectViewButton.isEnabled = true
                }
                
            }
            .disposed(by: disposeBag)
        
        // 位置情報
        output.lat
            .drive { lat in
            }
            .disposed(by: disposeBag)
        
        output.lng
            .drive { lng in
            }
            .disposed(by: disposeBag)
        
        output.myPosition
            .drive { position in
            }
            .disposed(by: disposeBag)
        
        // 検索条件
        output.searchingRange
            .drive { range in
            }
            .disposed(by: disposeBag)
        
        // api通信
        
        output.fetchApiDataByGoCarefullySelectViewButton
            .drive { data in
            
            }
            .disposed(by: disposeBag)
        
        output.fetchApiDataByGoIntuitionSelectViewButton
            .drive { data in

            }
            .disposed(by: disposeBag)
        
        // デコード
        output.decodingApiDataByGoCarefullySelectViewButton
            .drive { reuslt in
                
            }
            .disposed(by: disposeBag)
        
        output.decodingApiDataByGoIntuitionSelectViewButton
            .drive { reuslt in
                
            }
            .disposed(by: disposeBag)
        
        // レストランの情報
        output.setRestaurantDataByGoCarefullySelectViewButton
            .drive { reuslt in
                
            }
            .disposed(by: disposeBag)
        
        output.setRestaurantDataByGoIntuitionSelectViewButton
            .drive { reuslt in
                
            }
            .disposed(by: disposeBag)
        
        
        // 画面遷移
        output.goIntuitionSelectView
            .drive { [self] result in
                routerModel.showIntuitionSelectViewController(from: self)
            }
            .disposed(by: disposeBag)
        
        output.goCarefullySelectView
            .drive { [self] result in
                
                if result {
                    routerModel.showCarefullySelectViewController(from: self)
                }
            }
    }
    
    // MARK: - アラート
    //　通信エラー
    func showCommunicationAlert() {
         let alert = UIAlertController(
             title: "通信環境が不安定です",
             message: "通信環境が良い場所で操作してください",
             preferredStyle: .alert
         )
         
         let noAction = UIAlertAction(title: "OK", style: .cancel)
         
         alert.addAction(noAction)
         
         present(alert, animated: true)
         
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
