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
import EMTNeumorphicView

class RestaurantInfoViewController: UIViewController {
    // MARK: - UIパーツ
    
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantAdressLabel: UILabel!
    @IBOutlet weak var restaurantBusinessHoursLabel: UILabel!
    @IBOutlet weak var creditCardLabel: UILabel!
    @IBOutlet weak var restaurantImageView: UIImageView!
    
    @IBOutlet weak var baseView: EMTNeumorphicView!
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
                restaurantImageView.image = image
            }
        }
    }
    
    // UI設定
    private func setupUI() {
        
        // label設定
        restaurantNameLabel.sizeToFit()
        restaurantAdressLabel.sizeToFit()
        restaurantBusinessHoursLabel.sizeToFit()
        creditCardLabel.sizeToFit()
        
    
        
        // baseView
        baseView.neumorphicLayer!.elementBackgroundColor = view.backgroundColor?.cgColor ?? .init(red: 253 / 255, green: 184 / 255, blue: 109 / 255, alpha: 1)
        baseView.neumorphicLayer?.cornerRadius = 24
        baseView.neumorphicLayer?.depthType = .convex
        baseView.neumorphicLayer?.elementDepth = 7
    }
    
    // 紐付け
    func bindViewModel() {
        
        let isMadeStoryboard = rx.methodInvoked(#selector(viewWillAppear(_:)))
        let comunnicationState = rx.methodInvoked(#selector(getNetworkState))
        
        let input = RestaurantInfoViewModel.restaurantInfoViewInput(
            isMadeStoryboard: isMadeStoryboard,
            comunnicationState: comunnicationState
        )
        
        let output = viewModel.transform(input: input)
        
        //　通信状況
        output.comunnicationState
            .drive { [self] state in
                if state == .failureCommunication {
                    showCommunicationAlert()
                }
            }
            .disposed(by: disposeBag)
        
        output.reloadRestaurantData
            .drive { result in
                
            }
            .disposed(by: disposeBag)
        
        output.restaurantName
            .drive { [self] name in
                restaurantNameLabel.text = name
            }
            .disposed(by: disposeBag)
        
        output.restaurantAdress
            .drive { [self] adress in
                restaurantAdressLabel.text = "住所:\(adress)"
            }
            .disposed(by: disposeBag)
        
        output.restaurantBusinessHours
            .drive { [self] businessHours in
                restaurantBusinessHoursLabel.text = "営業時間:\(businessHours)"
            }
            .disposed(by: disposeBag)
        
        output.creditCard
            .drive { [self] creditCard in
                creditCardLabel.text = "クレジットカード:\(creditCard)"
            }
            .disposed(by: disposeBag)
        
        output.restaurantImageUrlString
            .drive { [self] restaurantImageUrlString in
                setImage(url: restaurantImageUrlString)
            }
            .disposed(by: disposeBag)
        
        
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

extension RestaurantInfoViewController {
    @objc func getNetworkState(state: Any) {
        // 登録する
    }
}
