//
//  ExchangeRateTableViewCell.swift
//  CoinRate
//
//  Created by Visarut Tippun on 1/1/21.
//

import UIKit

class ExchangeRateTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var valueLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func configure(item:ExchangeRate, baseValue:Double) {
        self.titleLabel.text = item.assetIdQuote ?? ""
        if let rate = item.rate {
            self.valueLabel.text = String(format: "%.2f", baseValue * rate)
        }
    }

}
