//
//  UITableView+Utility.swift
//  KnowYourDestination
//
//  Created by Fernando on 8/10/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import UIKit

protocol CellIdentifiable {
    static var cellIdentifier: String { get }
}

extension CellIdentifiable where Self: UITableViewCell {
    // 2
    static var cellIdentifier: String {
        return String(describing: self)
    }
}

// 3
extension UITableViewCell: CellIdentifiable { }

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T where T: CellIdentifiable {
        // 2
        guard let cell = dequeueReusableCell(withIdentifier: T.cellIdentifier) as? T else {
            // 3
            fatalError("Error dequeuing cell for identifier \(T.cellIdentifier)")
        }
        
        return cell
    }
}
