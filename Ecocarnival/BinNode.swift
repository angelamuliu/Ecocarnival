//
//  BinNode.swift
//  Ecocarnival
//
//  Created by Angela Liu on 11/13/15.
//  Copyright © 2015 amliu. All rights reserved.
//

import Foundation
import SpriteKit

/**
All Bin nodes that take in certain types of trash nodes.
*/
class BinNode: SKSpriteNode {
    static let binHitCategory = 2;
    
    class func trashbin(location: CGPoint) -> BinNode {
//        let sprite = BinNode(color: UIColor.redColor(), size: CGSize(width: 50, height: 200))
        let sprite = BinNode(imageNamed: "TN_trashbin.png")
        sprite.name = "Trash"
        sprite.position = location
        
//        sprite.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "TN_trashbin.png"), size: sprite.size)
        sprite.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width:50, height: 200))
        if let physics = sprite.physicsBody {
            physics.affectedByGravity = false;
            physics.allowsRotation = false;
            physics.dynamic = false;
            
            sprite.physicsBody!.categoryBitMask = UInt32(binHitCategory);
            sprite.physicsBody!.contactTestBitMask = UInt32(TrashNode.trashHitCategory);
            sprite.physicsBody!.collisionBitMask = UInt32(TrashNode.trashHitCategory);
        }
        
        return sprite;
    }
}
