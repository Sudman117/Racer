//
//  GameScene.swift
//  Racer
//  Authors: John Sudduth & Keegan Tountas
//  Copyright 2018
//

import SpriteKit
import GameplayKit
import UIKit
import CoreMotion


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let brick1 = SKSpriteNode(imageNamed: "brick2png")
    let brick2 = SKSpriteNode(imageNamed: "brick2png")
    let biker = SKSpriteNode(imageNamed: "biker clean")
    //var puddlesArray = ["puddle 1","puddle 2","puddle 3","puddle 4","puddle 5","puddle 6","puddle 7"]
    
    var currentHealth:Int = 450
    var healthBar = SKSpriteNode()
    var contactOnce = 0
    
    var gameTimer:Timer!
    var gameTimer2:Timer!
    var gameTimer3:Timer!
    var gameOver = false
    
    let bikerCategory:UInt32 = 1 << 1
    let carCategory:UInt32 = 1 << 2
    let borderCategory:UInt32 = 1 << 3
    let puddleCategory:UInt32 = 1 << 4
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        addChild(brick1)
        addChild(brick2)
        addChild(biker)

        scrollingBackground1()
        scrollingBackground2()
        bikerBuild()
        
        healthBar.size = CGSize(width: currentHealth, height: 40)
        healthBar.position = CGPoint(x: frame.size.width * 0.75, y: frame.size.height * 0.95)
        healthBar.zPosition = 5
        healthBar.color = .red
        healthBar.name = "healthBar"
        addChild(healthBar)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(addObstacleCar), userInfo: nil, repeats: true)
        gameTimer2 = Timer.scheduledTimer(timeInterval: 8, target: self, selector: #selector(addPuddle), userInfo: nil, repeats: true)
        gameTimer3 = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(healthProgress), userInfo: nil, repeats: true)
}

    
    //cars start
    @objc func addObstacleCar() {
        print("obstaclecar")
        let obstacleCar = SKSpriteNode(imageNamed: "car")
        
        let positionArrayX = [frame.size.width/8,frame.size.width * 0.375, frame.size.width * 0.625,frame.size.width * 0.875]
        let nextPosition = positionArrayX[Int(arc4random_uniform(UInt32(positionArrayX.count)))]
        
        obstacleCar.position = CGPoint(x: nextPosition, y: frame.size.height * 1.5)
        obstacleCar.zPosition = 2
        obstacleCar.physicsBody = SKPhysicsBody(texture: obstacleCar.texture!, size: obstacleCar.texture!.size())
        
        obstacleCar.physicsBody?.categoryBitMask = carCategory
        obstacleCar.physicsBody?.contactTestBitMask = bikerCategory
        obstacleCar.physicsBody?.collisionBitMask = 0
        
        self.addChild(obstacleCar)
        
        let animationDuration:TimeInterval = 20
        
        var actionArray = [SKAction]()
        
        if nextPosition > frame.size.width/2 {
            actionArray.append(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 0))
        }
        
        actionArray.append(SKAction.moveBy(x: 0, y: -frame.size.height * 2, duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        
        obstacleCar.run(SKAction.sequence(actionArray))
    }
    
    //cars end
    
    //puddles start
    
    @objc func addPuddle() {
        print("puddle")
        var puddlesArray = ["puddle 1","puddle 2","puddle 3","puddle 4","puddle 5","puddle 6","puddle 7"]
        
        puddlesArray = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: puddlesArray) as! [String]

        let puddle = SKSpriteNode(imageNamed: puddlesArray[0])
        
        let randomPuddlePosition = GKRandomDistribution(lowestValue: 100, highestValue:980)
        let position = CGFloat(randomPuddlePosition.nextInt())
        
        puddle.position = CGPoint(x: position, y: self.frame.size.height * 1.5)
        puddle.zPosition = 1
        
        puddle.physicsBody = SKPhysicsBody(texture:puddle.texture!, size: puddle.texture!.size())
        puddle.physicsBody?.isDynamic = true
        
        puddle.physicsBody?.categoryBitMask = puddleCategory
        puddle.physicsBody?.contactTestBitMask = bikerCategory
        puddle.physicsBody?.collisionBitMask = 0
        
        self.addChild(puddle)
        
        let animationDuration:TimeInterval = 20
        
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.moveBy(x: 0, y: -frame.size.height * 2, duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        
        puddle.run(SKAction.sequence(actionArray))
    }
    
    //puddles end
    
    //health begin
    func healthAnimation() {
        let removeHealth = SKAction.resize(toWidth: CGFloat(currentHealth), duration: 0.1)
        healthBar.run(removeHealth)
        if currentHealth == 0 {
            currentHealth = 0
            print("game over")
            
        }
    }
    @objc func healthProgress() {
        healthAnimation()
    }

    
    //health end
    func didBegin(_ contact: SKPhysicsContact) {
        
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch contactMask {
        case bikerCategory | carCategory:
            
            currentHealth -= 10
            if currentHealth <= 0 {
                currentHealth = 0
                gameTimer3.invalidate()
            }
            if contactOnce == 1{
                break
            }
            
            
        case bikerCategory | puddleCategory:

            currentHealth -= 10
            if currentHealth <= 0 {
                currentHealth = 0
                gameTimer3.invalidate()
            }
            if contactOnce == 1{
                break
            }
            
        default:
            contactOnce = 0
        }
}

    override func update(_ currentTime: TimeInterval){
        return
    }

}
