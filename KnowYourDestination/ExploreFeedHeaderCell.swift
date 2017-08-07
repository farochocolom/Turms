//
//  ExploreFeedHeaderCell.swift
//  KnowYourDestination
//
//  Created by Fernando on 8/6/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import UIKit

protocol ExploreFeedHeaderCellDelegate: class {
    func didTapFlagButton(_ flagButton: UIButton, on cell: ExploreFeedHeaderCell)
}

class ExploreFeedHeaderCell: UITableViewCell {
    
    var didTapFlagButtonForCell: ((ExploreFeedHeaderCell) -> Void)?
    
    @IBOutlet weak var flagButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func flagButtonTapped(_ sender: UIButton) {
        didTapFlagButtonForCell?(self)
    }

}
