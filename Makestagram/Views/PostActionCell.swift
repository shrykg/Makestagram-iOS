//
//  PostActionCell.swift
//  Makestagram
//
//  Created by Shreyak Godala on 06/07/18.
//  Copyright © 2018 Shreyak Godala. All rights reserved.
//

import UIKit

protocol PostActionCellDelegate {
    
    func didTapLikeButton(_ likeButton: UIButton, on cell: PostActionCell)
    
    
    
}

class PostActionCell: UITableViewCell {

    
    
    var delegate: PostActionCellDelegate?
    
    static let height: CGFloat = 46
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var likeCountLabel: UILabel!
    
    @IBOutlet weak var timeAgoLabel: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        delegate?.didTapLikeButton(sender, on: self)
        
    }
    
    
    

}
