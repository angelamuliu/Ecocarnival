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
    
    // Generic setup shared for all bins
    func setupBin(location:CGPoint, physicsSize:CGSize) {
        self.position = location
        self.zPosition = Constants.zBin
        
        self.physicsBody = SKPhysicsBody(rectangleOfSize: physicsSize)
        if let physics = self.physicsBody {
            physics.affectedByGravity = false;
            physics.allowsRotation = false;
            physics.dynamic = false;
        }
    }
    
    /**
     Trash bin for all trash nodes
    */
    class func trashbin(location: CGPoint) -> BinNode {
        let sprite = BinNode(imageNamed: "TN_trashbin.png")
        sprite.name = Constants.trash
        sprite.setupBin(location, physicsSize: CGSize(width:10, height: sprite.size.height))
        
        sprite.physicsBody!.categoryBitMask = Constants.trashBinCategory
        sprite.physicsBody!.contactTestBitMask = Constants.trashNodeCategory | Constants.recycleNodeCategory | Constants.miscNodeCategory
        sprite.physicsBody!.collisionBitMask = Constants.trashNodeCategory | Constants.recycleNodeCategory | Constants.miscNodeCategory;
        
        return sprite;
    }
    
    /**
     Recycle bin for all trash nodes with name "Recycle"
    */
    class func recyclebin(location: CGPoint) -> BinNode {
        let sprite = BinNode(imageNamed: "TN_recyclebin.png")
        sprite.name = Constants.recycle
        sprite.setupBin(location, physicsSize: CGSize(width:10, height: sprite.size.height))
        
        sprite.physicsBody!.categoryBitMask = Constants.recycleBinCategory
        sprite.physicsBody!.contactTestBitMask = Constants.trashNodeCategory | Constants.recycleNodeCategory | Constants.miscNodeCategory
        sprite.physicsBody!.collisionBitMask = Constants.trashNodeCategory | Constants.recycleNodeCategory | Constants.miscNodeCategory;
        
        return sprite;
    }
    
    /**
     Offscreen 'bin' for all trash nodes that should not go in either bin, located at bottom of screen
     */
    class func miscbin(location: CGPoint, width: CGFloat) -> BinNode {
        let sprite = BinNode(color: UIColor.blueColor(), size: CGSizeMake(width, 50))
        sprite.name = Constants.misc
        sprite.setupBin(location, physicsSize: CGSize(width:width, height: 50))
        
        sprite.physicsBody!.categoryBitMask = Constants.miscBinCategory
        sprite.physicsBody!.contactTestBitMask = Constants.trashNodeCategory | Constants.recycleNodeCategory | Constants.miscNodeCategory
        sprite.physicsBody!.collisionBitMask = Constants.trashNodeCategory | Constants.recycleNodeCategory | Constants.miscNodeCategory;
        
        return sprite;
    }
}
