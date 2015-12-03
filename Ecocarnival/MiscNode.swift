//
//  MiscNode.swift
//  Ecocarnival
//
//  Created by Angela Liu on 12/3/15.
//  Copyright © 2015 amliu. All rights reserved.
//

import Foundation
import SpriteKit

class MiscNode:Throwable {
    
    init(location: CGPoint) {
        let asset = Throwable.chooseNode(TextAssets.miscAssets)
        super.init(asset: asset, location: location)
        
        self.name = Constants.misc
        self.physicsBody!.categoryBitMask = Constants.miscNodeCategory
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}