//
//  TrashNode.swift
//  Ecocarnival
//
//  Created by Angela Liu on 11/13/15.
//  Copyright © 2015 amliu. All rights reserved.
//


import Foundation
import SpriteKit

/**
 All trash nodes, including compost, trash, and recyclables.
 All trash has a trash hit category of 1.
*/
class TrashNode: SKSpriteNode {
    static let trashImageAssets = ["TN_trash1.png"]
    static let recycleImageAssets = ["TN_recycle1.png"]
    static let miscImageAssets = ["TN_misc1.png"]
    
    // Generic setup shared for all trash
    func setupTrash(location:CGPoint, imageString:String) {
        self.position = location
        self.zPosition = Constants.zTrash
        
        self.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: imageString), size: self.size)
        if let physics = self.physicsBody {
            physics.affectedByGravity = true
            physics.allowsRotation = true
            physics.dynamic = true
            physics.linearDamping = 0.75
            physics.angularDamping = 0.75
            physics.mass = 0.5 // Assign a constant mass so all sized trash are affected by forces equally
            
            // What the trash node will respond to when touching or colliding
            physics.collisionBitMask = 0
//            physics.collisionBitMask = Constants.trashBinCategory | Constants.recycleBinCategory | Constants.miscBinCategory
            // Trash nodes can overlap with other trash nodes
            //physics.collisionBitMask = ~Constants.trashNodeCategory | ~Constants.recycleNodeCategory | ~Constants.miscNodeCategory | ~Constants.powerupNodeCategory;
        }
    }
    
    // ------------------------------------------------------------
    
    /**
     Trash node for stuff that goes in the trash can
    */
    class func trash(location: CGPoint) -> TrashNode {
        let imageString = chooseImage(trashImageAssets)
        let sprite = TrashNode(imageNamed: imageString)
        sprite.name = Constants.trash
        sprite.setupTrash(location, imageString: imageString)
        
        sprite.physicsBody!.categoryBitMask = Constants.trashNodeCategory
        return sprite
    }
    
    /**
     Recyclable trash belongs in the recycle bin
    */
    class func recyclable(location: CGPoint) -> TrashNode {
        let imageString = chooseImage(recycleImageAssets)
        let sprite = TrashNode(imageNamed: imageString)
        sprite.name = Constants.recycle
        sprite.setupTrash(location, imageString: imageString)
        
        sprite.physicsBody!.categoryBitMask = Constants.recycleNodeCategory
        return sprite
    }
    
    /**
     Misc trash belongs to the offscreen misc bin (e.g. don't sort it)
     */
    class func misc(location: CGPoint) -> TrashNode {
        let imageString = chooseImage(miscImageAssets)
        let sprite = TrashNode(imageNamed: imageString)
        sprite.name = Constants.misc
        sprite.setupTrash(location, imageString: imageString)
        
        sprite.physicsBody!.categoryBitMask = Constants.miscNodeCategory
        return sprite
    }
    
    /**
     A "powerup" type that does not reduce life if it is not sorted, but on touch gives a powerup
    */
    class func powerup(location: CGPoint) -> TrashNode {
        let imageString = "TN_lifeorb.png"
        let sprite = TrashNode(imageNamed: imageString)
        sprite.name = Constants.powerup
        sprite.setupTrash(location, imageString: imageString)
        
        // Powerups glow!
        let path = NSBundle.mainBundle().pathForResource("Green_Glow", ofType: "sks")
        let glowParticle = NSKeyedUnarchiver.unarchiveObjectWithFile(path!) as! SKEmitterNode
        glowParticle.position = CGPointMake(0, 0)
        glowParticle.name = Constants.powerup
        sprite.insertChild(glowParticle, atIndex: 0)
        
        sprite.physicsBody!.categoryBitMask = Constants.powerupNodeCategory
        return sprite
    }
    
    
    
    
    
    // ------------------------------------------------------------
    // Helper methods
    
    class func chooseImage(imageSet:[String]) -> String {
        return imageSet[Int(arc4random_uniform(UInt32(imageSet.count)))]
    }
    
    /**
     Creates a random trash node (trash, recyclable, or misc) given a location to create it in.
    */
    class func generateRandomTrash(location: CGPoint) -> TrashNode {
        let category = arc4random_uniform(UInt32(5))
        if category == Constants.trashNodeCategory { return TrashNode.trash(location) }
        if category == Constants.recycleNodeCategory { return TrashNode.recyclable(location) }
        if category == Constants.powerupNodeCategory { return TrashNode.powerup(location) }
        return TrashNode.misc(location)
    }

}