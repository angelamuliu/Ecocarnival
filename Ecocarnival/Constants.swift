//
//  Constants.swift
//  Ecocarnival
//
//  Created by Angela Liu on 11/14/15.
//  Copyright © 2015 amliu. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    // Z Indexes of different types to ensure consistent layering
    static let zTrash = CGFloat(5)
    static let zBin = CGFloat(10)
    static let zUI = CGFloat(100)
    
    // Different types of trash and bins
    static let trash = "Trash"
    static let recycle = "Recycle"
    static let misc = "Misc"
    static let powerup = "Powerup"
    
    // Collision categories for bins, trash, and non-collision items
    static let noCollisionCategory = UInt32(0)
    
    static let trashNodeCategory = UInt32(1)
    static let recycleNodeCategory = UInt32(2)
    static let miscNodeCategory = UInt32(3)
    static let powerupNodeCategory = UInt32(4)
    
    static let trashBinCategory = UInt32(5)
    static let recycleBinCategory = UInt32(6)
    static let miscBinCategory = UInt32(7)
    
    
    // Consistent colors we use throughout the application
    static let orangeColor = UIColor(red: 255.0/255.0, green: 122.0/255.0, blue: 64.0/255.0, alpha: 1.0)
    static let bloodOrangeColor = UIColor(red: 240.0/255.0, green: 64.0/255.0, blue: 20.0/255.0, alpha: 1.0)
    static let lightBlueColor = UIColor(red: 239.0/255.0, green: 251.0/255.0, blue: 255.0 / 255.0, alpha: 1.0)
    static let navyColor = UIColor(red: 88.0/255.0, green: 129.0/255.0, blue: 146.0/255.0, alpha: 1.0)
    static let lightGreyColor = UIColor(red: 175.0/255.0, green: 175.0/255.0, blue: 175.0/255.0, alpha: 1.0)
    static let greyColor = UIColor(red: 150.0/255.0, green: 150.0/255.0, blue: 150.0/255.0, alpha: 1.0)
    
}