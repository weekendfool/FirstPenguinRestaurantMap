//
//  RestaurantInfoViewController.swift
//  FirstPenguinRestaurantMap
//
//  Created by Oh!ara on 2023/05/13.
//

import UIKit
import RxSwift
import RxCocoa
import AlamofireImage
import Alamofire

class RestaurantInfoViewController: UIViewController {
    // MARK: - UIパーツ
    
    @IBOutlet weak var resutaurantNameLabel: UILabel!
    @IBOutlet weak var resutaurantAdressLabel: UILabel!
    @IBOutlet weak var resutaurantBusinessHoursLabel: UILabel!
    @IBOutlet weak var creditCardLabel: UILabel!
    @IBOutlet weak var resutaurantImageView: UIImageView!
    @IBOutlet weak var goMapButton: UIButton!
    
    // MARK: - 変数
    var viewModel: RestaurantInfoViewModel = RestaurantInfoViewModel()
    
    var disposeBag: DisposeBag = DisposeBag()
    let routerModel: RouterModel = RouterModel()
    // 通信エラー検知用
    private let nWPathMonitorModel: NWPathMonitorModel = NWPathMonitorModel()
    
    
    // MARK: - ライフサイクル
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getNetworkState(state: networkstate.successfulCommunication as Any)
    }
    
    
    // MARK: - 関数
    // 画面展開
    static func makeFromStoryboard() -> RestaurantInfoViewController {
        let vc = UIStoryboard.restaurantInfoViewController
                
        return vc
    }
    
    // 通信のセットアップ
    func setupMonitorComunnication() {
        nWPathMonitorModel.monitorComunnication { state  in
             self.getNetworkState(state: state as Any)
         }
         
         nWPathMonitorModel.start()
    }
    
    private func setImage(url: String) {
        AF.request(url).responseImage { [self] result in
            
            if case .success(let image) = result.result {
                resutaurantImageView.image = image
            }
        }
    }
    
    // UI設定
    private func setupUI() {
        resutaurantNameLabel.sizeToFit()
        resutaurantAdressLabel.sizeToFit()
        resutaurantBusinessHoursLabel.sizeToFit()
        creditCardLabel.sizeToFit()
    }
    
    // 紐付け
    func bindViewModel() {
        
        let isMadeStoryboard = rx.methodInvoked(#selector(viewWillAppear(_:)))
        let comunnicationState = rx.methodInvoked(#selector(getNetworkState))
        
        let input = RestaurantInfoViewModel.restaurantInfoViewInput(
            isMadeStoryboard: isMadeStoryboard,
            comunnicationState: comunnicationState,
            tappedGoMapView: goMapButton.rx.tap.asSignal()
        )
        
        let output = viewModel.transform(input: input)
        
        //　通信状況
        output.comunnicationState
            .drive { result in
                
            }
            .disposed(by: disposeBag)
        
        output.reloadRestaurantData
            .drive { result in
                
            }
            .disposed(by: disposeBag)
        
        output.resutaurantName
            .drive { [self] name in
                resutaurantNameLabel.text = name
            }
            .disposed(by: disposeBag)
        
        output.resutaurantAdress
            .drive { [self] adress in
                resutaurantAdressLabel.text = adress
            }
            .disposed(by: disposeBag)
        
        output.resutaurantBusinessHours
            .drive { [self] businessHours in
                resutaurantBusinessHoursLabel.text = businessHours
            }
            .disposed(by: disposeBag)
        
        output.creditCard
            .drive { [self] creditCard in
                creditCardLabel.text = creditCard
            }
            .disposed(by: disposeBag)
        
        output.resutaurantImageUrlString
            .drive { [self] resutaurantImageUrlString in
                setImage(url: resutaurantImageUrlString)
            }
            .disposed(by: disposeBag)
        
        output.goMapView
            .drive { [self] result in
                routerModel.showMapViewController(from: self)
            }
            .disposed(by: disposeBag)
    }
    
}




// MARK: - extension

extension RestaurantInfoViewController {
    @objc func getNetworkState(state: Any) {
        // 登録する
    }
}
