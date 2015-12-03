//
//  Throwable.swift
//  Ecocarnival
//
//  Created by Angela Liu on 12/3/15.
//  Copyright © 2015 amliu. All rights reserved.
//

import Foundation
import SpriteKit

/**
 Any object that is throwable/touchable in our game. This includes trash, recyclables, animals, and powerups.
 All throwables has a hit category of 1.
*/
class Throwable:SKSpriteNode {
    
    var rarity = Constants.common
    var desc = "Missing description"
    
    init(asset:[String:String], location: CGPoint) {
        let texture = SKTexture(imageNamed: asset["imageNamed"]!)
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        
        self.rarity = asset["rarity"]!
        self.desc = asset["desc"]!
        
        self.position = location
        self.zPosition = Constants.zTrash
        
        self.physicsBody = SKPhysicsBody(texture: texture, size: self.size)
        if let physics = self.physicsBody {
            physics.affectedByGravity = true
            physics.allowsRotation = true
            physics.dynamic = true
            physics.linearDamping = 0.75
            physics.angularDamping = 0.75
            physics.mass = 0.5 // Assign a constant mass so all sized trash are affected by forces equally
            
            // Throwables can overlap with everything
            physics.collisionBitMask = 0
        }
    }
    
    // The point value of the throwable is based on its rarity
    var value: Int {
        if self.name == Constants.powerup {
            return 0
        }
        switch self.rarity {
        case Constants.common:
            return Constants.common_worth
        case Constants.uncommon:
            return Constants.uncommon_worth
        case Constants.rare:
            return Constants.rare_worth
        default:
            return 0
        }
    }
    
    // ------------------------------------------------------------------
    // Class Functions

    
    /**
     Given an array of dictionaries representing sets of image names and descriptions, chooses a random dictionary
     */
    class func chooseNode(imageSet:[[String:String]]) -> [String:String] {
        return imageSet[Int(arc4random_uniform(UInt32(imageSet.count)))]
    }
    
    /**
     Creates a random trash node (trash, recyclable, misc, or powerup) given a location to create it in.
     */
    class func generateRandomTrash(location: CGPoint) -> Throwable {
        let category = arc4random_uniform(UInt32(5))
        if category == Constants.trashNodeCategory { return TrashNode(location: location) }
        if category == Constants.recycleNodeCategory { return RecycleNode(location: location) }
        if category == Constants.powerupNodeCategory { return PowerupNode(location: location) }
        return MiscNode(location: location)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}