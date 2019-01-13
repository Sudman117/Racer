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
    
    var currentHealth:Int = 500
    var healthBar = SKSpriteNode()
    var healthLabel = SKLabelNode()
    
    var gameTimer:Timer!
    var gameTimer2:Timer!
    var gameTimer3:Timer!
    var gameTimer4:Timer!
    var gameTimer5:Timer!
    var gameOver = false
    
    let bikerCategory:UInt32 = 1 << 1
    let carCategory:UInt32 = 1 << 2
    let borderCategory:UInt32 = 1 << 3
    let puddleCategory:UInt32 = 1 << 4
    let speedCategory:UInt32 = 1 << 5
    let resistCategory:UInt32 = 1 << 6
    let healCategory:UInt32 = 1 << 7
    
    //new
    
    var speedUpBiker:Double = 10
    var speedUpNumber:Double = 0
    
    var bikerResistance:Double = 1
    var resistUpNumber:Double = 0
    
    var bikerHealing:Double = 1
    var healUpNumber:Double = 0
    
    var activeNumber:Double = 0
    var pickUpNumber:Double = 0
    var speedUpGame:Double = (-0.3)
    var obstacleFrequency:Double = (-0.5)
    
    //old

    //power-ups start
    
    @objc func addSpeedUp() {
        print("power-up speed")
        let powerUpSpeed = SKShapeNode(circleOfRadius: 40)
        let randomSpeedPosition = GKRandomDistribution(lowestValue: 100, highestValue:980)
        let position = CGFloat(randomSpeedPosition.nextInt())
        
        powerUpSpeed.fillColor = .yellow
        powerUpSpeed.position = CGPoint(x: position, y: self.frame.size.height * 1.5)
        powerUpSpeed.zPosition = 2
        powerUpSpeed.physicsBody = SKPhysicsBody(circleOfRadius: 40)
        powerUpSpeed.physicsBody?.isDynamic = true
        
        powerUpSpeed.physicsBody?.categoryBitMask = speedCategory
        powerUpSpeed.physicsBody?.contactTestBitMask = bikerCategory
        powerUpSpeed.physicsBody?.collisionBitMask = 0
        
        self.addChild(powerUpSpeed)
        
        let animationDuration:TimeInterval = 20
        
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.moveBy(x: 0, y: -frame.size.height * 2, duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        
        powerUpSpeed.run(SKAction.sequence(actionArray))
    
    }
    
    @objc func addResistanceUp() {
        print("power-up resist")
        let powerUpResist = SKShapeNode(circleOfRadius: 40)
        let randomResistPosition = GKRandomDistribution(lowestValue: 100, highestValue:980)
        let position = CGFloat(randomResistPosition.nextInt())
        
        powerUpResist.fillColor = .blue
        powerUpResist.position = CGPoint(x: position, y: self.frame.size.height * 1.5)
        powerUpResist.zPosition = 2
        powerUpResist.physicsBody = SKPhysicsBody(circleOfRadius: 40)
        powerUpResist.physicsBody?.isDynamic = true
        
        powerUpResist.physicsBody?.categoryBitMask = resistCategory
        powerUpResist.physicsBody?.contactTestBitMask = bikerCategory
        powerUpResist.physicsBody?.collisionBitMask = 0
        
        self.addChild(powerUpResist)
        
        let animationDuration:TimeInterval = 20
        
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.moveBy(x: 0, y: -frame.size.height * 2, duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        
        powerUpResist.run(SKAction.sequence(actionArray))

    }
    
    @objc func addHealUp() {
        print("power-up heal")
        let powerUpHeal = SKShapeNode(circleOfRadius: 40)
        let randomHealPosition = GKRandomDistribution(lowestValue: 100, highestValue:980)
        let position = CGFloat(randomHealPosition.nextInt())
        
        powerUpHeal.fillColor = .green
        powerUpHeal.position = CGPoint(x: position, y: self.frame.size.height * 1.5)
        powerUpHeal.zPosition = 2
        powerUpHeal.physicsBody = SKPhysicsBody(circleOfRadius: 40)
        powerUpHeal.physicsBody?.isDynamic = true
        
        powerUpHeal.physicsBody?.categoryBitMask = healCategory
        powerUpHeal.physicsBody?.contactTestBitMask = bikerCategory
        powerUpHeal.physicsBody?.collisionBitMask = 0
        
        self.addChild(powerUpHeal)
        
        let animationDuration:TimeInterval = 20
        
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.moveBy(x: 0, y: -frame.size.height * 2, duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        
        powerUpHeal.run(SKAction.sequence(actionArray))
        
    }
    
    @objc func addPowerUps() {
        
        var powerUpArray = [addHealUp,addSpeedUp,addResistanceUp]
        powerUpArray = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: powerUpArray) as! [() -> ()]
        powerUpArray[0]()
     
    }
    
    var activeArray = [String]()
    
    @objc func readPowerUpArray() {
        var counts: [String: Int] = [:]
        for item in activeArray {
            counts[item] = (counts[item] ?? 0) + 1
        }
        print(counts)
    }
    
    //power-ups end
    
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
        healthBar.position = CGPoint(x: frame.size.width * 0.76, y: frame.size.height * 0.97)
        healthBar.zPosition = 5
        healthBar.color = .red
        healthBar.name = "healthBar"
        addChild(healthBar)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(addObstacleCar), userInfo: nil, repeats: true)
        gameTimer2 = Timer.scheduledTimer(timeInterval: 8, target: self, selector: #selector(addPuddle), userInfo: nil, repeats: true)
        gameTimer3 = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(healthProgress), userInfo: nil, repeats: true)
        gameTimer4 = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(addPowerUps), userInfo: nil, repeats: true)
        gameTimer5 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(readPowerUpArray), userInfo: nil, repeats: true)
}
    
    //cars start
    @objc func addObstacleCar() {
        print("obstaclecar")
        let obstacleCar = SKSpriteNode(imageNamed: "car")
        
        let positionArrayX = [frame.size.width/8,frame.size.width * 0.375, frame.size.width * 0.625,frame.size.width * 0.875]
        let nextPosition = positionArrayX[Int(arc4random_uniform(UInt32(positionArrayX.count)))]
        
        obstacleCar.position = CGPoint(x: nextPosition, y: frame.size.height * 1.5)
        obstacleCar.zPosition = 3
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
        healthLabel.position = CGPoint(x: frame.size.width * 0.76, y: frame.size.height * 0.97)
        healthLabel.text = "HEALTH"
        healthLabel.zPosition = 6
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
            print("biker-car")
            contact.bodyB.node?.removeFromParent()
            currentHealth -= 10
            if currentHealth <= 0 {
                currentHealth = 0
                healthBar.removeFromParent()
                gameTimer3.invalidate()
            }
            
            
        case bikerCategory | puddleCategory:

            contact.bodyB.node?.removeFromParent()
            if activeArray.count >= 1 {
            activeArray.removeLast()
            } else {
                return
            }
            
        case bikerCategory | speedCategory:
 
            contact.bodyB.node?.removeFromParent()
            pickUpNumber += 1
            if activeArray.count < 5 {
                activeArray.append("Speed")
            } else{
                return
            }
            
        case bikerCategory | resistCategory:
 
            contact.bodyB.node?.removeFromParent()
            pickUpNumber += 1
            if activeArray.count < 5{
                activeArray.append("Resist")
            } else{
                return
            }
            
        case bikerCategory | healCategory:

            contact.bodyB.node?.removeFromParent()
            pickUpNumber += 1
            if activeArray.count < 5{
                activeArray.append("Heal")
            } else {
                return
            }
            
        default:
            return
        }
}

    override func update(_ currentTime: TimeInterval){
        return
    }

}
