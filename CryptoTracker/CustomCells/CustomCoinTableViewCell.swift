//
//  CustomCoinTableViewCell.swift
//  CryptoTracker
//
//  Created by yash pindiwala on 2023-10-08.
//

import UIKit

class CustomCoinTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    
    @IBOutlet var coinImageView: UIImageView!
    @IBOutlet var coinNameLabel: UILabel!
    @IBOutlet var coin24ChangeLabel: UILabel!
    @IBOutlet var coinSymbolLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
