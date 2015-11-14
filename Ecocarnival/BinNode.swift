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
    static let binHitCategory = UInt32(2);
    
    class func trashbin(location: CGPoint) -> BinNode {
        let sprite = BinNode(imageNamed: "TN_trashbin.png")
        sprite.name = Constants.trash
        sprite.position = location
        sprite.zPosition = 10
        
        sprite.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width:50, height: 200))
        if let physics = sprite.physicsBody {
            physics.affectedByGravity = false;
            physics.allowsRotation = false;
            physics.dynamic = false;
            
            sprite.physicsBody!.categoryBitMask = Constants.binHitCategory;
            sprite.physicsBody!.contactTestBitMask = Constants.trashHitCategory;
            sprite.physicsBody!.collisionBitMask = Constants.trashHitCategory;
        }
        
        return sprite;
    }
    
    class func recyclebin(location: CGPoint) -> BinNode {
        let sprite = BinNode(imageNamed: "TN_recyclebin.png")
        sprite.name = Constants.recycle
        sprite.position = location
        sprite.zPosition = 10
        
        sprite.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width:50, height: 200))
        if let physics = sprite.physicsBody {
            physics.affectedByGravity = false;
            physics.allowsRotation = false;
            physics.dynamic = false;
            
            sprite.physicsBody!.categoryBitMask = Constants.binHitCategory;
            sprite.physicsBody!.contactTestBitMask = Constants.trashHitCategory;
            sprite.physicsBody!.collisionBitMask = Constants.trashHitCategory;
        }
        
        return sprite;
    }
}
