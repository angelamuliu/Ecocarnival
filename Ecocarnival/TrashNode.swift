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
    static let trashHitCategory = 1;
    
    class func trash(location: CGPoint) -> TrashNode {
        let sprite = TrashNode(imageNamed: "Player.png")
        sprite.name = "Trash"
        sprite.position = location
        
        sprite.xScale = 2
        sprite.yScale = 2
        
        sprite.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Player.png"), size: sprite.size)
        if let physics = sprite.physicsBody {
            physics.affectedByGravity = true
            physics.allowsRotation = true
            physics.dynamic = true;
            physics.linearDamping = 0.75
            physics.angularDamping = 0.75
            
            sprite.physicsBody!.categoryBitMask = UInt32(trashHitCategory);
            sprite.physicsBody!.contactTestBitMask = UInt32(BinNode.binHitCategory);
            sprite.physicsBody!.collisionBitMask = UInt32(BinNode.binHitCategory);
        }
        
        return sprite
    }
}