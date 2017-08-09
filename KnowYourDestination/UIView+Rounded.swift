//
//  UIView+Rounded.swift
//  KnowYourDestination
//
//  Created by Fernando on 8/9/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import UIKit

private var round = false

extension UIView {
    
    @IBInspectable var roundCorners: Bool {
        get {
            return round
        } set {
            round = newValue
            
            if round {
                self.layer.cornerRadius = 3
            } else {
                self.layer.cornerRadius = 0
            }
        }
        
    }
    
}

