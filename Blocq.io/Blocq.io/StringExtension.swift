//
//  StringExtension.swift
//  Blocq.io
//
//  Created by Michal Lučanský on 7.7.18.
//  Copyright © 2018 Blocq.io. All rights reserved.
//

import Foundation

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
}
