//
//  ExploreFeedFooterCell.swift
//  KnowYourDestination
//
//  Created by Fernando on 7/17/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import UIKit

protocol ExploreFeedFooterCellDelegate: class {
    func didTapUpvoteButton(_ likeButton: UIButton, on cell: ExploreFeedFooterCell)
    
    func didTapDownvoteButton(_ likeButton: UIButton, on cell: ExploreFeedFooterCell)
    
    func updateSingleCell(on cell: ExploreFeedFooterCell)
}

class ExploreFeedFooterCell: UITableViewCell {
    
    @IBOutlet weak var postedByLabel: UILabel!
    @IBOutlet weak var upvoteButton: UIButton!
    @IBOutlet weak var downvoteButton: UIButton!
    @IBOutlet weak var downvoteLabel: UILabel!
    @IBOutlet weak var upvoteCountLabel: UILabel!
    @IBOutlet weak var firstTag: UILabel!
    @IBOutlet weak var secondTag: UILabel!
    @IBOutlet weak var thirdTag: UILabel!
    
    weak var delegate: ExploreFeedFooterCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        firstTag.layer.cornerRadius = firstTag.layer.bounds.height / 2
        secondTag.layer.cornerRadius = secondTag.layer.bounds.height / 2
        thirdTag.layer.cornerRadius = thirdTag.layer.bounds.height / 2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        delegate?.didTapUpvoteButton(sender, on: self)
        delegate?.updateSingleCell(on: self)
    }
    
    @IBAction func DownvoteButtonTapped(_ sender: UIButton) {
        delegate?.didTapDownvoteButton(sender, on: self)
        delegate?.updateSingleCell(on: self)
    }
}
