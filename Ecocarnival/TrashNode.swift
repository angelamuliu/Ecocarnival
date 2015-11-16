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
    static let trashHitCategory = UInt32(1);
    static let imageAssets = ["TN_trash1.png"]
    
    // ------------------------------------------------------------
    // Base trash initialize methods for trash, recyclables, and misc items
    class func trash(location: CGPoint) -> TrashNode {
        let imageString = chooseImage()
        let sprite = TrashNode(imageNamed: imageString)
        sprite.name = Constants.trash
        sprite.position = location
        sprite.zPosition = Constants.zTrash
        
        
        sprite.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: imageString), size: sprite.size)
        if let physics = sprite.physicsBody {
            physics.affectedByGravity = true
            physics.allowsRotation = true
            physics.dynamic = true
            physics.linearDamping = 0.75
            physics.angularDamping = 0.75
            
            sprite.physicsBody!.categoryBitMask = Constants.trashNodeCategory
            // What the trash node will respond to when touching or colliding
//            sprite.physicsBody!.contactTestBitMask = Constants.trashBinCategory | Constants.recycleBinCategory | Constants.miscBinCategory
            sprite.physicsBody!.collisionBitMask = Constants.trashBinCategory | Constants.recycleBinCategory | Constants.miscBinCategory
            sprite.physicsBody!.collisionBitMask = ~Constants.trashNodeCategory;  // Trash nodes can overlap with other trash nodes
        }
        
        return sprite
    }
    
    // ------------------------------------------------------------
    // Helper methods
    class func chooseImage() -> String {
        return imageAssets[Int(arc4random_uniform(UInt32(imageAssets.count)))]
    }
}