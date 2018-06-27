//
//  Constants.swift
//  Blocq.io
//
//  Created by Michal Lučanský on 26.6.18.
//  Copyright © 2018 Blocq.io. All rights reserved.
//

import Foundation
import Alamofire


enum Constants {
    
    static let baseUrl = "https://api.blocq.io/"
    
    static let headers: HTTPHeaders = [
        "Accept": "application/json",
        "Content-Type": "application/json"
    ]
}
