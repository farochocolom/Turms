//
//  UIButton+Border.swift
//  KnowYourDestination
//
//  Created by Fernando on 8/2/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import UIKit

public enum UIButtonBorderSide {
    case Top, Bottom, Left, Right
}

extension UIButton {
    
    public func addBorder(side: UIButtonBorderSide, color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        
        switch side {
        case .Top:
            border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: width)
        case .Bottom:
            border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        case .Left:
            border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        case .Right:
            border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        }
        
        self.layer.addSublayer(border)
    }
    
    public func addAllBorders(color: UIColor, width: CGFloat){
        addBorder(side: .Top, color: color, width: width)
        addBorder(side: .Bottom, color: color, width: width)
        addBorder(side: .Left, color: color, width: width)
        addBorder(side: .Right, color: color, width: width)
    }
}
