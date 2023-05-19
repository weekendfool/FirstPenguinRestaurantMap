//
//  RestaurantInfoTableTableViewCell.swift
//  FirstPenguinRestaurantMap
//
//  Created by Oh!ara on 2023/05/20.
//

import UIKit

class RestaurantInfoTableViewCell: UITableViewCell {
    
    
    // MARK: - UI
    
    @IBOutlet weak var resutaurantNameLabel: UILabel!
    @IBOutlet weak var resutaurantAccessLabel: UILabel!
    @IBOutlet weak var resutaurantImageView: UIImageView!
    
    // MARK: - ライフサイクル
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: - 関数

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
