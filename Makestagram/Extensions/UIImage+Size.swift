//
//  UIImage+Size.swift
//  Makestagram
//
//  Created by Shreyak Godala on 06/07/18.
//  Copyright © 2018 Shreyak Godala. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    var aspectHeight: CGFloat {
        
        let heightRatio = size.height / 736
        let widthRatio = size.width / 414
        let aspectRatio = fmax(heightRatio, widthRatio)
        
        return size.height / aspectRatio
        
        
        
    }
    
    
    
    
}
