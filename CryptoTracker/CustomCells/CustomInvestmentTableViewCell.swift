//
//  CustomInvestmentTableViewCell.swift
//  CryptoTracker
//
//  Created by yash pindiwala on 2023-10-29.
//

import UIKit

class CustomInvestmentTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    
    @IBOutlet var coinSymbolLabel: UILabel!
    @IBOutlet var coinQuantityLabel: UILabel!
    @IBOutlet var marketValueLabel: UILabel!
    @IBOutlet var investmentValueLabel: UILabel!
    @IBOutlet var differenceValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
