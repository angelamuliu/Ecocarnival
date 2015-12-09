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
 A UIView that contains CAEmitterLayers, allowing it to spew confetti everywhere
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
        // Initialize the first emitter
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
        emitter.emitterCells = [CAEmitterCell]()
        if let texture = UIImage(named: "Confetti") {
            // The emitter cell is what actually emits the particles
            let emitterCell = CAEmitterCell()
            
            emitterCell.contents = texture.CGImage
            emitterCell.name = "confetti"
            emitterCell.birthRate = 30 // How many particles per second
            emitterCell.lifetime = 4 // How long each particle lives for in seconds
            
            // Simulating downwards gravity on the particles
            emitterCell.yAcceleration = 20
            
            emitterCell.spin = 1.0 // Confetti twirls around kinda. Radians
            emitterCell.spinRange = 0.5
            
            emitterCell.alphaSpeed = -1.0/emitterCell.lifetime/2.0 // The fading away effect
            
            emitterCell.velocity = 160 // Base begining velocity of particle
            emitterCell.velocityRange = 40 // Range of velocity -> 160 - 200
            
            emitterCell.scale = 0.5
            emitterCell.scaleRange = 0.3 // The particle will spawn at range of 0.5x to 1.5x the original size
            
            emitterCell.color = Constants.orangeColor.CGColor // The base color
            emitterCell.blueRange = 0.7 // And we can + - 50% blue or green
            emitterCell.greenRange = 0.7
            
            emitterCell.emissionRange = CGFloat(M_PI) // Angle of how particles are emitted. We just do 180 on bottom
            emitter.emitterCells?.append(emitterCell)
        }
        
        if let dotTexture = UIImage(named: "Dot") {
            let emitterCell = CAEmitterCell()
            
            emitterCell.contents = dotTexture.CGImage
            emitterCell.name = "dot"
            emitterCell.birthRate = 50
            emitterCell.lifetime = 4
            emitterCell.yAcceleration = 40
            emitterCell.alphaSpeed = -1.0/emitterCell.lifetime/2.0
            emitterCell.velocity = 180
            emitterCell.velocityRange = 40
            emitterCell.scale = 0.1
            
            emitterCell.redRange = 0.33
            emitterCell.greenRange = 0.33
            
            emitterCell.emissionRange = CGFloat(M_PI) // Angle of how particles are emitted. We just do 180 on bottom
            emitter.emitterCells?.append(emitterCell)
        }
        
        // The confetti doesn't last forever... it disappears in a few seconds
        // First we dispatch a job to disable the emitter
        var delay = Int64(0.1 * Double(NSEC_PER_SEC))
        var delayTime = dispatch_time(DISPATCH_TIME_NOW, delay)
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.disableEmitterCells()
        }
        
        // Then we dispatch a job to remove the emitter from the parent view
        delay = Int64(5 * Double(NSEC_PER_SEC))
        delayTime = dispatch_time(DISPATCH_TIME_NOW, delay)
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.removeFromSuperview()
        }
    }
    
    /**
     Stops the shower of confetti
    */
    func disableEmitterCells() {
        emitter.setValue(0, forKeyPath: "emitterCells.confetti.birthRate")
        emitter.setValue(0, forKeyPath: "emitterCells.dot.birthRate")
    }

}


