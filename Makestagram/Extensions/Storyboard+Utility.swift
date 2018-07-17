//
//  Storyboard+Utility.swift
//  Makestagram
//
//  Created by Shreyak Godala on 26/06/18.
//  Copyright © 2018 Shreyak Godala. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    
    enum MGtype: String {
        
        case main
        case login
        
        var fileName: String {
            return rawValue.capitalized
        }
        
    }
    
    convenience init(type: MGtype, bundle: Bundle? = nil) {
        self.init(name: type.fileName, bundle: bundle)
    }
    
    static func initialViewController(for type: MGtype) -> UIViewController {
        let storyboard = UIStoryboard(type: type)
        guard let initialViewController = storyboard.instantiateInitialViewController() else {
            fatalError("could not instantiate view controller of \(type.fileName)")
        }
        
        return initialViewController
        }
    }
    

