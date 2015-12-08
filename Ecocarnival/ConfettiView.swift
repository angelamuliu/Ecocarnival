//
//  ConfettiView.swift
//  Ecocarnival
//
//  Created by Angela Liu on 12/8/15.
//  Copyright © 2015 amliu. All rights reserved.
//

import UIKit

// Adapted from: http://www.raywenderlich.com/77983/make-letter-word-game-uikit-swift-part-33
/**
 A UIView that contains a CAEmitterLayer, allowing it to spew confetti everywhere
*/
class ConfettiView: UIView {
    private var emitter:CAEmitterLayer!
    
    // Configure the UIView to have an emitter layer
    override class func layerClass() -> AnyClass {
        return CAEmitterLayer.self
    }
    
    required init(coder aDecoder:NSCoder) {
        fatalError("use init(frame:")
    }
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        //initialize the emitter
        emitter = self.layer as! CAEmitterLayer
        emitter.emitterPosition = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)
        emitter.emitterSize = self.bounds.size
        emitter.emitterMode = kCAEmitterLayerAdditive
        emitter.emitterShape = kCAEmitterLayerRectangle
    }
    
    // Called when the confetti view is added to some parent view
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if self.superview == nil {
            return
        }
        if let texture = UIImage(named: "spark") {
            // The emitter cell is what actually emits the particles
            let emitterCell = CAEmitterCell()
            
            emitterCell.contents = texture.CGImage
            emitterCell.name = "cell"
            emitterCell.birthRate = 50 // How many particles per second
            emitterCell.lifetime = 4 // How long each particle lives for in seconds
            
            // Simulating downwards gravity on the particles
            emitterCell.yAcceleration = 10
            
            emitterCell.velocity = 160 // Base begining velocity of particle
            emitterCell.velocityRange = 40 // Range of velocity -> 160 - 200
            
            emitterCell.scaleRange = 0.8 // The particle will spawn at range of 0.5x to 1.5x the original size
            
            emitterCell.color = Constants.orangeColor.CGColor // The base color
            emitterCell.blueRange = 0.5 // And we can + - 50% blue or green
            emitterCell.greenRange = 0.5
            
            emitterCell.emissionRange = CGFloat(M_PI) // Angle of how particles are emitted. We just do 180 on bottom
            emitter.emitterCells = [emitterCell]
            
            // The confetti doesn't last forever... it disappears in a few seconds
            // First we dispatch a job to disable the emitter
            var delay = Int64(0.1 * Double(NSEC_PER_SEC))
            var delayTime = dispatch_time(DISPATCH_TIME_NOW, delay)
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.disableEmitterCell()
            }
            
            // Then we dispatch a job to remove the emitter from the parent view
            delay = Int64(5 * Double(NSEC_PER_SEC))
            delayTime = dispatch_time(DISPATCH_TIME_NOW, delay)
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.removeFromSuperview()
            }
        }
    }
    
    /**
     Stops the shower of confetti
    */
    func disableEmitterCell() {
        emitter.setValue(0, forKeyPath: "emitterCells.cell.birthRate")
    }

}


