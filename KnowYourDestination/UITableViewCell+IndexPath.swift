//
//  UITableViewCell+IndexPath.swift
//  KnowYourDestination
//
//  Created by Fernando on 7/27/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import UIKit

extension UITableViewCell {
    
    var indexPath: IndexPath? {
        return (superview as? UITableView)?.indexPath(for: self)
    }
}
