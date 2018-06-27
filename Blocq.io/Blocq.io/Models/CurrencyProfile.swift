//
//  CurrencyProfile.swift
//  Blocq.io
//
//  Created by Michal Lučanský on 26.6.18.
//  Copyright © 2018 Blocq.io. All rights reserved.
//

import Foundation


struct Currencies:Decodable {
    var data:[CurrencyProfile]
    var links:Paging
}

struct Paging:Decodable {
    var next:String
}

struct CurrencyProfile:Decodable {
    
    var rank:Int?
    var name:String?
    var symbol:String?
    var price:Double?
    var dayVolume:Double?
    var marketCap:Int?
    var percentChange1h:Double?
    var percentChange24h:Double?
    var percentChange7d:Double?
    var availableSupply:Int?
    var totalSupply:Int?
    var priceBtc:Double?
    var imageUrl:String?
    var target:String?
    var currencyId:String?
    var lastUpdate:Int?

    enum CodingKeys: String, CodingKey {
        case rank
        case name
        case symbol
        case price
        case dayVolume = "24h_volume"
        case marketCap = "market_cap"
        case percentChange1h = "percent_change_1h"
        case percentChange24h = "percent_change_24h"
        case percentChange7d = "percent_change_7d"
        case availableSupply = "available_supply"
        case totalSupply = "total_supply"
        case priceBtc = "price_btc"
        case imageUrl = "image_url"
        case target
        case currencyId = "currency_id"
        case lastUpdate = "last_updated"
    }
}
