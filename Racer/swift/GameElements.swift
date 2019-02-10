//
//  GameElements.swift
//  bike
//
//  Created by Keegan Tountas on 8/4/18.
//  Copyright © 2018 Keegan Tountas. All rights reserved.
//

import SpriteKit

extension GameScene {
    
    /// Builds the biker's definition.
    func bikerBuild() {
        
        biker.position = CGPoint(x: frame.size.width/2, y: frame.size.height/6)
        biker.size = CGSize(width: 250, height: 300)
        biker.zPosition = 10
        biker.physicsBody = SKPhysicsBody(texture: biker.texture!, size: biker.texture!.size())
        biker.physicsBody?.affectedByGravity = false
        biker.physicsBody?.isDynamic = true
        biker.name = "BIKER"
        biker.physicsBody?.categoryBitMask = bikerCategory
        biker.physicsBody?.contactTestBitMask = carCategory | borderCategory
        biker.physicsBody?.collisionBitMask = borderCategory
        biker.physicsBody?.usesPreciseCollisionDetection = true
        biker.physicsBody?.restitution = 0
        biker.lightingBitMask = 1
        biker.shadowCastBitMask = 0
        biker.shadowedBitMask = 1
        biker.zPosition = 1
        
        biker.addChild(speedBoostEmitter)
        speedBoostEmitter.zPosition = 0
        speedBoostEmitter.position.y -= 120
    }
    
    func moveBikerRight(){
        
        biker.physicsBody?.velocity = CGVector(dx: 300 + (speedUpNumber*speedUpBiker), dy: 0)
        //let bikerRight = SKTexture(imageNamed: "biker right")
        
//        let rotateRight = SKAction.rotate(toAngle: -0.3, duration: 0.5)
//        //let steerRight = SKAction.animate(with: [bikerRight], timePerFrame: 0.1)
//
//        biker.run(rotateRight)
//        biker.run(steerRight)
        
    }
    
    func moveBikerLeft(){
        biker.physicsBody?.velocity = CGVector(dx: -300 - (speedUpNumber*speedUpBiker), dy: 0)
        //let bikerLeft = SKTexture(imageNamed: "biker left")
        
//        let rotateLeft = SKAction.rotate(toAngle: 0.3, duration: 0.5)
//        let steerLeft = SKAction.animate(with: [bikerLeft], timePerFrame: 0.1)
//
//        biker.run(rotateLeft)
//        biker.run(steerLeft)
    
    }
    
    func bikerStop(){
        
        biker.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        
        //let bikerCenter = SKTexture(imageNamed: "biker clean")
        
//        let rotateCenter = SKAction.rotate(toAngle: 0, duration: 0.4)
//        let steerCenter = SKAction.animate(with: [bikerCenter], timePerFrame: 0.1)
//        
//        biker.run(rotateCenter)
//        biker.run(steerCenter)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches{
            let location = t.location(in: self)
            
            if location.x < biker.position.x{
                moveBikerLeft()
            } else {
                moveBikerRight()
            }
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        bikerStop()
    }
        
}

