//
//  Color.swift
//  Blocq.io
//
//  Created by Michal Lučanský on 27.6.18.
//  Copyright © 2018 Blocq.io. All rights reserved.
//

import UIKit


 private extension UIColor {
    
    
    
    convenience init(r: UInt, g: Int, b: Int, a: Int = 255) {
        self.init(red: min(CGFloat(r), 255.0)/255.0, green: min(CGFloat(g),255.0)/255.0, blue: min(CGFloat(b),255.0)/255.0, alpha: CGFloat(a)/255.0)
    }
    
    convenience init(r: UInt, g: Int, b: Int, alpha: Double) {
        self.init(red: min(CGFloat(r), 255.0)/255.0, green: min(CGFloat(g),255.0)/255.0, blue: min(CGFloat(b),255.0)/255.0, alpha: CGFloat(alpha))
    }
}
//183
struct Color {
    static let mainBlue = UIColor(r: 55, g: 100, b: 183)
    static let mainGreen = UIColor(r: 75, g: 193, b: 12)
}
