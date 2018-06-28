//
//  CustomSearchBar.swift
//  Blocq.io
//
//  Created by Michal Lučanský on 27.6.18.
//  Copyright © 2018 Blocq.io. All rights reserved.
//

import UIKit

class CustomSearchBar: UISearchBar {

    var preferredFont: UIFont!
    var preferredTextColor: UIColor!

    init(frame: CGRect, font: UIFont, textColor: UIColor) {
        super.init(frame: frame)
        
        self.frame = frame
        preferredFont = font
        preferredTextColor = textColor
        searchBarStyle = UISearchBarStyle.prominent
        isTranslucent = false
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func indexOfSearchFieldInSubviews() -> Int! {
        var index: Int!
        let searchBarView = subviews[0]
        
        for i in 0..<(searchBarView.subviews.count - 1) {
            if searchBarView.subviews[i] is UITextField {
                index = i
                break
            }
        }
        
        return index
    }
    
    override func draw(_ rect: CGRect) {
        // Find the index of the search field in the search bar subviews.
        if let index = indexOfSearchFieldInSubviews() {
            // Access the search field
            let searchField: UITextField = (subviews[0]).subviews[index] as! UITextField
            
            // Set its frame.
            searchField.frame = CGRect(x: CGFloat(5.0), y: CGFloat(5.0), width: CGFloat(frame.size.width) - CGFloat(10.0), height: CGFloat(frame.size.height) - CGFloat(10.0))
            
            // Set the font and text color of the search field.
            searchField.font = preferredFont
            searchField.textColor = preferredTextColor
            
            // Set the background color of the search field.
            searchField.backgroundColor = barTintColor
        }
        
        super.draw(rect)
    }
    
}
