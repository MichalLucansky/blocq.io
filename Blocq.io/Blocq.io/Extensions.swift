//
//  Extensions.swift
//  Blocq.io
//
//  Created by Michal Lučanský on 29.7.18.
//  Copyright © 2018 Blocq.io. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func getSubviewsOf<T : UIView>(view:UIView) -> [T] {
        
        var subviews = [T]()
        
        for subview in view.subviews {
            subviews += getSubviewsOf(view: subview) as [T]
            
            if let subview = subview as? T {
                subviews.append(subview)
            }
        }
        
        return subviews
    }
}
