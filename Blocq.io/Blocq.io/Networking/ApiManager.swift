//
//  ApiManager.swift
//  Blocq.io
//
//  Created by Michal Lučanský on 26.6.18.
//  Copyright © 2018 Blocq.io. All rights reserved.
//

import Foundation
import Alamofire

class ApiManager {
//    22
    static let instance:ApiManager = ApiManager()
    
    func getCurrencyList(completion: @escaping (Currencies?, Error?)->()) {
        let currency = UserDefaults.standard
        var currencyValue = ""
        if let curr = currency.value(forKey: "settingscurrency") as? String{
            currencyValue = curr
        }
        let url = "https://api.blocq.io//ticker?perPage=1568&target=\(currencyValue)&page=1"

        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Constants.headers).responseData { (data) in
            do {
                let currencies = try JSONDecoder().decode(Currencies.self, from: data.data!)
                completion(currencies,nil)
            } catch {
                completion(nil,data.error)
                print(data.error?.localizedDescription)
            }
        }
    }
    
    func getHistory(name: String , completion: @escaping ([GraphData]?, Error?)->()) {
        let timeInterval = UserDefaults.standard
        var timeParameter = ""
        if let time = timeInterval.value(forKey: "settingsTimeInterval") as? String{
            timeParameter = time
        }
        let url = "https://api.blocq.io/history/\(name.replacingOccurrences(of: " ", with: ""))/\(timeParameter)?target=eur"
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Constants.headers).responseData { (data) in
            do {
                let graphData = try JSONDecoder().decode([GraphData].self, from: data.data!)
                completion(graphData,nil)
            } catch {
                completion(nil,data.error)
                print(data.error?.localizedDescription)
            }
        }
    }
}
