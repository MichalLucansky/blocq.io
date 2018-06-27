//
//  CurrencyProfileCell.swift
//  Blocq.io
//
//  Created by Michal Lučanský on 26.6.18.
//  Copyright © 2018 Blocq.io. All rights reserved.
//

import UIKit
import Kingfisher

class CurrencyProfileCell: UITableViewCell {

    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var picture: UIImageView!
    
    @IBOutlet weak var currencyId: UILabel!
    @IBOutlet weak var currencyName: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var priceChange: UILabel!
    
    func configure(currency: CurrencyProfile) {
       
        if let rank = currency.rank {
            self.rank.text = "\(rank)"
        }
        
        if let imageUrl = currency.imageUrl {
            if let url = URL(string: imageUrl) {
                self.picture.kf.setImage(with: url)
            }
        }
        
        if let symbol = currency.symbol{
            self.currencyId.text = symbol
        }
        
        if let name = currency.name {
            self.currencyName.text = name
        }
        
        if let price = currency.price {
            self.price.text = currency.target! + "\(price)"
        }
        if let priceChange = currency.percentChange1h {
            self.priceChange.text = "\(priceChange)"
        }

    }
    
}
