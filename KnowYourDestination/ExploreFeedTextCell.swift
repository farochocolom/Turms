//
//  ExploreFeedCell.swift
//  KnowYourDestination
//
//  Created by Fernando on 7/17/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import UIKit

class ExploreFeedTextCell: UITableViewCell {
    
    
    @IBOutlet weak var postTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        postTextLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
//    override func addSubview(_ view: UIView) {
//        view.heightAnchor.constraint(equalToConstant: 200).isActive = true
//        view.topAnchor.constraint(equalTo: postTextLabel.bottomAnchor, constant: 10)
//    }
}
