//
//  TrashNode.swift
//  Ecocarnival
//
//  Created by Angela Liu on 11/13/15.
//  Copyright © 2015 amliu. All rights reserved.
//


import Foundation
import SpriteKit

class TrashNode: Throwable {
    
    init(location: CGPoint) {
        let asset = Throwable.chooseNode(TextAssets.trashAssets)
        super.init(asset: asset, location: location)
        
        self.name = Constants.trash
        self.physicsBody!.categoryBitMask = Constants.trashNodeCategory
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}