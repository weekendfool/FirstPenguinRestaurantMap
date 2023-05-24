//
//  CarefullySelectViewController.swift
//  FirstPenguinRestaurantMap
//
//  Created by Oh!ara on 2023/05/13.
//

import UIKit
import RxCocoa
import RxSwift
import AlamofireImage
import Alamofire
import EMTNeumorphicView

class CarefullySelectViewController: UIViewController {
    // MARK: - UIパーツ
    
    @IBOutlet weak var restaurantTableView: UITableView!
   
    // MARK: - 変数
    let viewModel: CarefullySelectViewModel = CarefullySelectViewModel()
    var disposeBag: DisposeBag = DisposeBag()
    let routerModel: RouterModel = RouterModel()
    // 通信エラー検知用
    private let nWPathMonitorModel: NWPathMonitorModel = NWPathMonitorModel()
    
    // レストランデータ
    var restaurantDataArray: [RestaurantDataModel] = [] {
        didSet {
            setImage()
        }
    }
    var imageArray: [UIImage] = []
    
    
    
    // MARK: - ライフサイクル
   
    

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        restaurantTableView.delegate = self
        restaurantTableView.dataSource = self
        
        setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getNetworkState(state: networkstate.successfulCommunication as Any)
        
        
    }
    

    // MARK: - 関数
    // 画面展開
    static func makeFromStoryboard() -> CarefullySelectViewController {
        let vc = UIStoryboard.carefullySelectViewController
        
        return vc
    }
    
    // 通信のセットアップ
    func setupMonitorComunnication() {
        nWPathMonitorModel.monitorComunnication { state  in
             self.getNetworkState(state: state as Any)
         }
         
         nWPathMonitorModel.start()
    }
    
    private func setupUI() {
        restaurantTableView.delegate = self
        restaurantTableView.dataSource = self
        
        restaurantTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            restaurantTableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            restaurantTableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
        ])
       
        restaurantTableView.backgroundColor = UIColor.clear
        restaurantTableView.separatorStyle = .none
        restaurantTableView.clipsToBounds = false
        
        restaurantTableView.rowHeight = UITableView.automaticDimension
        
       
    }
    
    private func setImage() {
        
        for data in restaurantDataArray {
            AF.request(data.imageULR).responseImage { [self] result in
                
                if case .success(let image) = result.result {
                    let resizedImage = image.resaize(image: image, width: 100)
                    imageArray.append(resizedImage)
                    restaurantTableView.reloadData()
                }
            }
        }
        
        
       
    }
    
    func bindViewModel() {
        let isMadeStoryboard = rx.methodInvoked(#selector(viewWillAppear(_:)))
        let comunnicationState = rx.methodInvoked(#selector(getNetworkState))
        let tappedCell = rx.methodInvoked(#selector(tappedCell))
        
        let input = CarefullySelectViewModel.carefullySelectViewInput(
            isMadeStoryboard: isMadeStoryboard,
            comunnicationState: comunnicationState,
            tappedCell: tappedCell
        )
        
        let output = viewModel.transform(input: input)
        
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
        
        output.restaurantData
            .drive { [self] data in
                restaurantDataArray = data
                
            }
            .disposed(by: disposeBag)
        
        output.goMapView
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

extension CarefullySelectViewController: UITableViewDelegate  {
    
    
}

extension CarefullySelectViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return restaurantDataArray.count
     }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 2
    }
    
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type: EMTNeumorphicLayerCornerType = .all
        let cellId = String(format: "cell%d", type.rawValue)
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        
        cell = EMTNeumorphicTableCell(style: .subtitle, reuseIdentifier: cellId) //毎回セルを作る
        if cell == nil {
            cell = EMTNeumorphicTableCell(style: .subtitle, reuseIdentifier: cellId)
            
           
        }
        
        if let cell = cell as? EMTNeumorphicTableCell {
           
            cell.neumorphicLayer?.cornerType = type
            cell.selectionStyle = .none;
            cell.neumorphicLayer?.elementBackgroundColor = view.backgroundColor!.cgColor
            cell.neumorphicLayer?.cornerRadius = 24

            
        }
        
       
        
        if imageArray.count != 0 {
            
            let restaurant = restaurantDataArray[indexPath.section]
            
            
            
           // label設定
            var context = cell?.defaultContentConfiguration()
            context?.text = restaurantDataArray[indexPath.section].name
            context?.textProperties.font = UIFont.systemFont(ofSize: 20)
            context?.textProperties.numberOfLines = 0
            context?.textProperties.lineBreakMode = .byClipping
            
            context?.secondaryText = restaurantDataArray[indexPath.section].access
            context?.secondaryTextProperties.font = UIFont.systemFont(ofSize: 15)
            context?.secondaryTextProperties.numberOfLines = 0
            context?.secondaryTextProperties.lineBreakMode = .byClipping
            
            
            
            context?.image = imageArray[indexPath.section]
        
            context?.imageProperties
            
            cell?.contentConfiguration = context
            
            
        }
        
        
        return cell!
    }
    
    // タップされた時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 画面遷移
        tappedCell(index: indexPath.section)
        
        
    }
    
    // セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
   
}

extension CarefullySelectViewController {
    @objc func getNetworkState(state: Any) {
        // 登録する
    }
}

extension CarefullySelectViewController {
    @objc func tappedCell(index: Int) {
        // 登録する
    }
}

extension CarefullySelectViewController {
    @objc func longTappedCell(index: Int) {
        // 登録する
    }
}

