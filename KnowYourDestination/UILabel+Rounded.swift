//
//  UILabel+Border.swift
//  KnowYourDestination
//
//  Created by Fernando on 8/3/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import UIKit

private var roundedCorner = false

extension UILabel {
    
    @IBInspectable var rounded: Bool {
        get {
            return roundedCorner
        } set {
            roundedCorner = newValue
            
            if roundedCorner {
                self.layer.cornerRadius = self.layer.bounds.height / 2
                self.clipsToBounds = true
                self.layer.masksToBounds = true

            } else {
                self.layer.cornerRadius = 0
            }
        }
    }
    
}

extension UIButton {
    
    @IBInspectable var rounded: Bool {
        get {
            return roundedCorner
        } set {
            roundedCorner = newValue
            
            if roundedCorner {
                self.layer.cornerRadius = self.layer.bounds.height / 2
                self.clipsToBounds = true
                self.layer.masksToBounds = true
                
            } else {
                self.layer.cornerRadius = 0
            }
        }
    }
    
}
