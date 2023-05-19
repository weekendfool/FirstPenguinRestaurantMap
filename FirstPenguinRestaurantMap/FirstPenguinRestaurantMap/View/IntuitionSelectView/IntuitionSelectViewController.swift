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

class IntuitionSelectViewController: UIViewController {
    // MARK: - UIパーツ
    
    @IBOutlet weak var numberOfRestaurantsLabel: UILabel!
    @IBOutlet weak var resutaurantNameLabel: UILabel!
    @IBOutlet weak var accessLabel: UILabel!
    @IBOutlet weak var resutaurantImageView: UIImageView!
    @IBOutlet weak var badButton: UIButton!
    @IBOutlet weak var goodButton: UIButton!
    @IBOutlet weak var goMapViewButton: UIButton!
    @IBOutlet weak var resutaurantInfoView: UIView!
    
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
        resutaurantNameLabel.sizeToFit()
        accessLabel.sizeToFit()
        
        // ジェスチャーの設定
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedResutaurantInfoView))
        
        resutaurantInfoView.addGestureRecognizer(tapGesture)
        
        
    }
    
    private func setImage(url: String) {
        AF.request(url).responseImage { [self] result in
            
            if case .success(let image) = result.result {
                resutaurantImageView.image = image
            }
        }
    }
    
    // 紐付け
    func bindViewModel() {
        let isMadeStoryboard = rx.methodInvoked(#selector(viewWillAppear(_:)))
        let comunnicationState = rx.methodInvoked(#selector(getNetworkState))
        let tappedResutaurantInfoView = rx.methodInvoked(#selector(tappedResutaurantInfoView))
        
        
        let input = IntuitionSelectViewModel.intuitionSelectViewInput(
            isMadeStoryboard: isMadeStoryboard,
            comunnicationState: comunnicationState,
            tappedBadButton: badButton.rx.tap.asSignal(),
            tappedGoodButton: goodButton.rx.tap.asSignal(),
            tappedResutaurantInfoView: tappedResutaurantInfoView,
            goMapView: goMapViewButton.rx.tap.asSignal()
        )
        
        let output = viewModel.transform(input: input)
        
        // 通信状況
        output.comunnicationState
            .drive { [weak self] state in
                
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
                self?.numberOfRestaurantsLabel.text = numberOfRestaurants
            }
            .disposed(by: disposeBag)
        
        // レストランの名前
        output.firstResutaurantNameLabel
            .drive { [weak self] resutaurantName in
                self?.resutaurantNameLabel.text = resutaurantName
            }
            .disposed(by: disposeBag)
        
        // アクセス
        output.firstAccessLabel
            .drive { [weak self] access in
                self?.accessLabel.text = access
//                self?.accessLabel.sizeToFit()
            }
            .disposed(by: disposeBag)
        
        output.getURL
            .drive { [self] url in
                print("url: \(url)")
            }
            .disposed(by: disposeBag)
        
        //　image
        output.firstResutaurantImageView
            .drive { [self] imageString in
               setImage(url: imageString)
            }
            .disposed(by: disposeBag)
        
        // ボタン
        output.changeCounterByBadButton
            .drive { [weak self] result in
               
            }
            .disposed(by: disposeBag)
        
        output.changeCounterByGoodButton
            .drive { [weak self] result in
                
            }
            .disposed(by: disposeBag)
        
        // 表示
        output.numberOfRestaurantsLabelByBadButton
            .drive { [weak self] numberOfRestaurants in
                self?.numberOfRestaurantsLabel.text = numberOfRestaurants
            }
            .disposed(by: disposeBag)
        
        output.resutaurantNameLabelByBadButton
            .drive { [weak self] resutaurantName in
                self?.resutaurantNameLabel.text = resutaurantName
            }
            .disposed(by: disposeBag)
        
        output.accessLabelByBadButton
            .drive { [weak self] access in
                self?.accessLabel.text = access
            }
            .disposed(by: disposeBag)
        
        output.resutaurantImageViewByBadButton
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
        
        output.resutaurantNameLabelByGoodButton
            .drive { [weak self] resutaurantName in
                self?.resutaurantNameLabel.text = resutaurantName
            }
            .disposed(by: disposeBag)
        
        output.accessLabelByGoodButton
            .drive { [weak self] access in
                self?.accessLabel.text = access
            }
            .disposed(by: disposeBag)
        
        output.resutaurantImageViewByGoodButton
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
    
    
}

// MARK: - extension

extension IntuitionSelectViewController {
    @objc func getNetworkState(state: Any) {
        // 登録する
    }
}

extension IntuitionSelectViewController {
    @objc func tappedResutaurantInfoView() {
        print("tapされたよ")
    }
}
