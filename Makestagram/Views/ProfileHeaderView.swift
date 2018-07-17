//
//  ProfileHeaderView.swift
//  Makestagram
//
//  Created by Shreyak Godala on 16/07/18.
//  Copyright © 2018 Shreyak Godala. All rights reserved.
//

import UIKit

class ProfileHeaderView: UICollectionReusableView {
   
    
    @IBOutlet weak var postCountLabel: UILabel!
    
    @IBOutlet weak var followerCountLabel: UILabel!
    
    
    @IBOutlet weak var followingCountLabel: UILabel!
    
    
    @IBOutlet weak var settingsButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        settingsButton.layer.cornerRadius = 6
        settingsButton.layer.borderWidth = 1
        settingsButton.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    
    
    
    @IBAction func settingsButtonTapped(_ sender: UIButton) {
    }
    
    
    
    
    
    
    
    
    
}
