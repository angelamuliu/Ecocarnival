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
    
    // Generic setup shared for all trash
    func setupTrash(location:CGPoint) {
        self.position = location
        self.zPosition = Constants.zTrash
    }
    // Physics setup that happens after image is chosen
    func setupPhysics() {
        if let physics = self.physicsBody {
            physics.affectedByGravity = true
            physics.allowsRotation = true
            physics.dynamic = true
            physics.linearDamping = 0.75
            physics.angularDamping = 0.75
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
        sprite.setupTrash(location)
        
        sprite.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: imageString), size: sprite.size)
        sprite.setupPhysics()
        
        sprite.physicsBody!.categoryBitMask = Constants.trashNodeCategory
        
        // What the trash node will respond to when touching or colliding
        sprite.physicsBody!.collisionBitMask = Constants.trashBinCategory | Constants.recycleBinCategory | Constants.miscBinCategory
        sprite.physicsBody!.collisionBitMask = ~Constants.trashNodeCategory;  // Trash nodes can overlap with other trash nodes
        
        return sprite
    }
    
//    class func recyclable(location: CGPoint) -> TrashNode {
//
//    }
    
    // ------------------------------------------------------------
    // Helper methods
    class func chooseImage(imageSet:[String]) -> String {
        return imageSet[Int(arc4random_uniform(UInt32(imageSet.count)))]
    }
}