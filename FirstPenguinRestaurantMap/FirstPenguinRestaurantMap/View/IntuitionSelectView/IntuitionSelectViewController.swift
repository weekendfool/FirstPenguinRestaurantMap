//
//  IntuitionSelectViewController.swift
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

class IntuitionSelectViewController: UIViewController {
    // MARK: - UIパーツ
    
    @IBOutlet weak var numberOfRestaurantsLabel: UILabel!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var accessLabel: UILabel!
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var badButton: EMTNeumorphicButton!
    @IBOutlet weak var goodButton: EMTNeumorphicButton!
    @IBOutlet weak var goMapViewButton: EMTNeumorphicButton!
    @IBOutlet weak var restaurantInfoView: EMTNeumorphicView!
    
    // MARK: - 変数

    
    var viewModel: IntuitionSelectViewModel = IntuitionSelectViewModel()
    var disposeBag: DisposeBag = DisposeBag()
    let routerModel: RouterModel = RouterModel()
    // 通信エラー検知用
    private let nWPathMonitorModel: NWPathMonitorModel = NWPathMonitorModel()
    
    // MARK: - ライフサイクル

    override func viewDidLoad() {
        super.viewDidLoad()

        
        bindViewModel()
        
        setupUI()

       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getNetworkState(state: networkstate.successfulCommunication as Any)
    }
    
   
    

    // MARK: - 関数
    // 画面展開
    static func makeFromStoryboard() -> IntuitionSelectViewController {
        let vc = UIStoryboard.intuitionSelectViewController
                
        return vc
    }
    
    // 通信のセットアップ
    func setupMonitorComunnication() {
        nWPathMonitorModel.monitorComunnication { state  in
             self.getNetworkState(state: state as Any)
         }
         
         nWPathMonitorModel.start()
    }
    
    // ui設定
    func setupUI() {
        
        // ラベルの設定
        restaurantNameLabel.sizeToFit()
        accessLabel.sizeToFit()
        
        // ジェスチャーの設定
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedRestaurantInfoView))
        restaurantInfoView.addGestureRecognizer(tapGesture)
        
        // EMTNeumorphicViewの設定
        // badButton
        badButton.neumorphicLayer!.elementBackgroundColor = view.backgroundColor?.cgColor ?? .init(red: 253 / 255, green: 184 / 255, blue: 109 / 255, alpha: 1)
        badButton.neumorphicLayer?.cornerRadius = 24
        badButton.neumorphicLayer?.depthType = .convex
        badButton.neumorphicLayer?.elementDepth = 7
        
        // goodButton
        goodButton.neumorphicLayer!.elementBackgroundColor = view.backgroundColor?.cgColor ?? .init(red: 253 / 255, green: 184 / 255, blue: 109 / 255, alpha: 1)
        goodButton.neumorphicLayer?.cornerRadius = 24
        goodButton.neumorphicLayer?.depthType = .convex
        goodButton.neumorphicLayer?.elementDepth = 7
        
        // goMapViewButton
        goMapViewButton.neumorphicLayer!.elementBackgroundColor = view.backgroundColor?.cgColor ?? .init(red: 253 / 255, green: 184 / 255, blue: 109 / 255, alpha: 1)
        goMapViewButton.neumorphicLayer?.cornerRadius = 24
        goMapViewButton.neumorphicLayer?.depthType = .convex
        goMapViewButton.neumorphicLayer?.elementDepth = 7
       
       // restaurantInfoView
        restaurantInfoView.neumorphicLayer!.elementBackgroundColor = view.backgroundColor?.cgColor ?? .init(red: 253 / 255, green: 184 / 255, blue: 109 / 255, alpha: 1)
        restaurantInfoView.neumorphicLayer?.cornerRadius = 24
        restaurantInfoView.neumorphicLayer?.depthType = .convex
        restaurantInfoView.neumorphicLayer?.elementDepth = 7
        
    }
    
    private func setImage(url: String) {
        AF.request(url).responseImage { [self] result in
            
            if case .success(let image) = result.result {
                restaurantImageView.image = image
            }
        }
    }
    
    // 紐付け
    func bindViewModel() {
        let isMadeStoryboard = rx.methodInvoked(#selector(viewWillAppear(_:)))
        let comunnicationState = rx.methodInvoked(#selector(getNetworkState))
        let tappedRestaurantInfoView = rx.methodInvoked(#selector(tappedRestaurantInfoView))
        
        
        let input = IntuitionSelectViewModel.intuitionSelectViewInput(
            isMadeStoryboard: isMadeStoryboard,
            comunnicationState: comunnicationState,
            tappedBadButton: badButton.rx.tap.asSignal(),
            tappedGoodButton: goodButton.rx.tap.asSignal(),
            tappedRestaurantInfoView: tappedRestaurantInfoView,
            tappedGoMapViewButton: goMapViewButton.rx.tap.asSignal()
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
        
        output.reloadRestaurantData
            .drive { result in
                
            }
            .disposed(by: disposeBag)
        
        // 初期表示
        // 件数の表示
        output.firstNumberOfRestaurantsLabel
            .drive { [weak self] numberOfRestaurants in
                self?.numberOfRestaurantsLabel.text = "全\(numberOfRestaurants)件"
            }
            .disposed(by: disposeBag)
        
        // レストランの名前
        output.firstRestaurantNameLabel
            .drive { [weak self] restaurantName in
                self?.restaurantNameLabel.text = restaurantName
            }
            .disposed(by: disposeBag)
        
        // アクセス
        output.firstAccessLabel
            .drive { [weak self] access in
                self?.accessLabel.text = "アクセス:\(access)"
            }
            .disposed(by: disposeBag)
        
        output.gatImageUrl
            .drive { [self] url in
            }
            .disposed(by: disposeBag)
        
        //　image
        output.firstRestaurantImageView
            .drive { [self] imageString in
               setImage(url: imageString)
            }
            .disposed(by: disposeBag)
        
        // ボタン
        output.changeCounterByBadButton
            .drive { [self] result in
                UIView.transition(with: restaurantInfoView, duration: 0.5, options: [.transitionCurlUp], animations: nil)
            }
            .disposed(by: disposeBag)
        
        output.changeCounterByGoodButton
            .drive { [self] result in
                UIView.transition(with: restaurantInfoView, duration: 0.5, options: [.transitionCrossDissolve], animations: nil)
            }
            .disposed(by: disposeBag)
        
        // 表示
        output.numberOfRestaurantsLabelByBadButton
            .drive { [weak self] numberOfRestaurants in
                self?.numberOfRestaurantsLabel.text = numberOfRestaurants
            }
            .disposed(by: disposeBag)
        
        output.restaurantNameLabelByBadButton
            .drive { [weak self] restaurantName in
                self?.restaurantNameLabel.text = restaurantName
            }
            .disposed(by: disposeBag)
        
        output.accessLabelByBadButton
            .drive { [weak self] access in
                self?.accessLabel.text = access
            }
            .disposed(by: disposeBag)
        
        output.restaurantImageViewByBadButton
            .drive { [self] imageString in
                setImage(url: imageString)
            }
            .disposed(by: disposeBag)
        
        output.goMapViewByBadButton
            .drive { [self] restut in
                routerModel.showMapViewController(from: self)
            }
            .disposed(by: disposeBag)
        
        output.numberOfRestaurantsLabelByGoodButton
            .drive { [weak self] numberOfRestaurants in
                self?.numberOfRestaurantsLabel.text = numberOfRestaurants
            }
            .disposed(by: disposeBag)
        
        output.restaurantNameLabelByGoodButton
            .drive { [weak self] restaurantName in
                self?.restaurantNameLabel.text = restaurantName
            }
            .disposed(by: disposeBag)
        
        output.accessLabelByGoodButton
            .drive { [weak self] access in
                self?.accessLabel.text = access
            }
            .disposed(by: disposeBag)
        
        output.restaurantImageViewByGoodButton
            .drive { [self] imageString in
                setImage(url: imageString)
            }
            .disposed(by: disposeBag)
        
        output.goMapViewByGoodButton
            .drive { [self] result in
                routerModel.showMapViewController(from: self)
            }
            .disposed(by: disposeBag)
        
        output.goRestaurantInfoView
            .drive { [self] result in
                routerModel.showRestaurantInfoViewController(from: self)
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

extension IntuitionSelectViewController {
    @objc func getNetworkState(state: Any) {
        // 登録する
    }
}

extension IntuitionSelectViewController {
    @objc func tappedRestaurantInfoView() {
        print("tapされたよ")
    }
}
