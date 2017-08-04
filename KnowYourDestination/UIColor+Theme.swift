//
//  UIColor+Theme.swift
//  KnowYourDestination
//
//  Created by Fernando on 8/2/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import UIKit


extension UIColor {
    
    
    static var TWBlue: UIColor {
        return UIColor(red: 27/255, green: 170/255, blue: 255/255, alpha: 1.0)
    }
    
    static var TWPurple: UIColor {
        return UIColor(red: 125/255, green: 85/255, blue: 251/255, alpha: 1.0)
    }
    
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}
