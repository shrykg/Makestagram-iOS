//
//  PostHeaderCell.swift
//  Makestagram
//
//  Created by Shreyak Godala on 06/07/18.
//  Copyright © 2018 Shreyak Godala. All rights reserved.
//

import UIKit

class PostHeaderCell: UITableViewCell {
    
    static let height: CGFloat = 54

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBAction func optionsButtonTapped(_ sender: UIButton) {
    }
    
}
