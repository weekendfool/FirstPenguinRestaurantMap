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

class CarefullySelectViewController: UIViewController {
    // MARK: - UIパーツ
    
    @IBOutlet weak var resutaurantTableView: UITableView!
    
    // MARK: - 変数
    let viewModel: CarefullySelectViewModel = CarefullySelectViewModel()
    var disposeBag: DisposeBag = DisposeBag()
    let routerModel: RouterModel = RouterModel()
    // 通信エラー検知用
    private let nWPathMonitorModel: NWPathMonitorModel = NWPathMonitorModel()
    
    // レストランデータ
    var resutaurantDataArray: [RestaurantDataModel] = [] {
        didSet {
            setImage()
        }
    }
    var imageArray: [UIImage] = []
    
    
    
    // MARK: - ライフサイクル
   
    

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        
        resutaurantTableView.delegate = self
        resutaurantTableView.dataSource = self
        
//        resutaurantTableView.reloadData()
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
        resutaurantTableView.delegate = self
        resutaurantTableView.dataSource = self
        
    }
    
    private func setImage() {
        
        for data in resutaurantDataArray {
            AF.request(data.imageULR).responseImage { [self] result in
                
                if case .success(let image) = result.result {
                    imageArray.append(image)
                    resutaurantTableView.reloadData()
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
            goMapView: tappedCell
        )
        
        let output = viewModel.transform(input: input)
        
        output.comunnicationState
            .drive { resurt in
                
            }
            .disposed(by: disposeBag)
        
        output.reloadRestaurantData
            .drive { result in
            }
            .disposed(by: disposeBag)
        
        output.restaurantData
            .drive { [self] data in
                resutaurantDataArray = data
                
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

extension CarefullySelectViewController: UITableViewDelegate  {
    
    
}

extension CarefullySelectViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resutaurantDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RestaurantInfoTableViewCell
        cell.resutaurantNameLabel.text = resutaurantDataArray[indexPath.row].name
        cell.resutaurantAccessLabel.text = resutaurantDataArray[indexPath.row].access
//        DispatchQueue.main.async { [self] in
//            let imageUrl = resutaurantDataArray[indexPath.row].imageULR
//            cell.setImage(url: imageUrl)
        if imageArray.count != 0 {
            cell.resutaurantImageView.image = imageArray[indexPath.row]
        }
        
//        }
        
        return cell
    }
    
   
}

extension CarefullySelectViewController {
    @objc func getNetworkState(state: Any) {
        // 登録する
    }
}

extension CarefullySelectViewController {
    @objc func tappedCell() {
        // 登録する
    }
}

