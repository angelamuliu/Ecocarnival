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
    
    // Collision categories for bins, trash, and non-collision items
    static let noCollisionCategory = UInt32(0)
    
    static let trashNodeCategory = UInt32(1)
    static let recycleNodeCategory = UInt32(2)
    static let miscNodeCategory = UInt32(3)
    
    static let trashBinCategory = UInt32(1)
    static let recycleBinCategory = UInt32(2)
    static let miscBinCategory = UInt32(3)
    
}