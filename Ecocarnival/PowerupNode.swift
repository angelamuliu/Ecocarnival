//
//  PowerupNode.swift
//  Ecocarnival
//
//  Created by Angela Liu on 12/3/15.
//  Copyright © 2015 amliu. All rights reserved.
//

import Foundation
import SpriteKit

// For now, there is only 1 powerup (Life)
class PowerupNode:Throwable {
    
    init(location: CGPoint) {
        let asset = TextAssets.lifePowerAsset
        super.init(asset: asset, location: location)
        
        self.name = Constants.powerup
        self.physicsBody!.categoryBitMask = Constants.powerupNodeCategory
        
        // Powerups glow!
        let path = NSBundle.mainBundle().pathForResource("Green_Glow", ofType: "sks")
        let glowParticle = NSKeyedUnarchiver.unarchiveObjectWithFile(path!) as! SKEmitterNode
        glowParticle.position = CGPointMake(0, 0)
        glowParticle.name = Constants.powerup
        self.insertChild(glowParticle, atIndex: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}