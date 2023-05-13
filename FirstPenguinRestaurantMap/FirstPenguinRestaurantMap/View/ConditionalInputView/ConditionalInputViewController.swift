//
//  ConditionalInputViewController.swift
//  FirstPenguinRestaurantMap
//
//  Created by Oh!ara on 2023/05/13.
//

import UIKit
import MapKit

class ConditionalInputViewController: UIViewController {
    
    // MARK: - UIパーツ
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var distanceLabel: UILabel!
    
    // MARK: - 変数
    // MARK: - ライフサイクル
   
   
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView?.mapType = .standard
        
        var locationManager = CLLocationManager()
        CLLocationManager.locationServicesEnabled()
        
        var userLocation = MKUserLocation()
        let status = CLLocationManager.authorizationStatus()
        
        if status == CLAuthorizationStatus.notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        print("userLocation: \(userLocation)")
        
        // 祝作
        var ragion = mapView.region
        
//        ragion.center = userLocation
        ragion.span.latitudeDelta = 0.02
        ragion.span.longitudeDelta = 0.02
        
        mapView.setRegion(ragion, animated: true)

        // Do any additional setup after loading the view.
    }
    

    // MARK: - 関数
}

// MARK: - extension

extension ConditionalInputViewController: MKMapViewDelegate {
   
}
