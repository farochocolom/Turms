//
//  MaterialView.swift
//  MakeSchool Notes
//
//  Created by Fernando on 3/25/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import UIKit

private var materialKey = false

extension UITextView {
    
    @IBInspectable var materialDesign: Bool {
        get {
            return materialKey
        } set {
            materialKey = newValue
            
            if materialKey {
                self.layer.masksToBounds = false
                self.layer.cornerRadius = 3.0
                self.layer.shadowOpacity = 0.8
                self.layer.shadowRadius = 3.0
                self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
                self.layer.shadowColor = UIColor(red: 33/255, green: 41/255, blue: 45/255, alpha: 0.8).cgColor
            } else {
                self.layer.cornerRadius = 0
                self.layer.shadowOpacity = 0
                self.layer.shadowRadius = 0
                self.layer.shadowColor = nil
            }
        }
    }
    
}
