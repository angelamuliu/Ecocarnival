//
//  Constants.swift
//  Ecocarnival
//
//  Created by Angela Liu on 11/14/15.
//  Copyright © 2015 amliu. All rights reserved.
//

import Foundation

struct Constants {
    // Different types of trash and bins
    static let trash = "Trash"
    static let recycle = "Recycle"
    
    // Collision categories for bins, trash, and non-collision items
    static let noCollisionCategory = UInt32(0)
    static let trashHitCategory = UInt32(1)
    static let binHitCategory = UInt32(2)
}