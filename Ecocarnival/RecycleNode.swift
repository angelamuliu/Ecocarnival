//
//  RecycleNode.swift
//  Ecocarnival
//
//  Created by Angela Liu on 12/3/15.
//  Copyright © 2015 amliu. All rights reserved.
//

import Foundation
import SpriteKit

class RecycleNode:Throwable {
    
    init(location: CGPoint) {
        let asset = Throwable.chooseNode(TextAssets.recycleAssets)
        super.init(asset: asset, location: location)
        
        self.name = Constants.recycle
        self.physicsBody!.categoryBitMask = Constants.recycleNodeCategory
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
