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
    
    func getCurrencyList(url: String? = "https://api.blocq.io//ticker?perPage=1568&target=eur&page=1" , completion: @escaping (Currencies?, Error?)->()) {
//        let url = Constants.baseUrl + "/ticker?perPage=30&target=eur"

        Alamofire.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Constants.headers).responseData { (data) in
            do {
                let currencies = try JSONDecoder().decode(Currencies.self, from: data.data!)
                completion(currencies,nil)
            } catch {
                completion(nil,data.error)
                print(data.error?.localizedDescription)
            }
        }
    }
    
    func getHistory(url: String? = "https://api.blocq.io/history/bitcoin/lastHour" , completion: @escaping ([GraphData]?, Error?)->()) {
        
        Alamofire.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Constants.headers).responseData { (data) in
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
