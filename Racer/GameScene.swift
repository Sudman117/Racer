//
//  GameScene.swift
//  Racer
//  Authors: John Sudduth & Keegan Tountas
//  Copyright 2018
// shield, gun, roar

import SpriteKit
import GameplayKit
import UIKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let biker = SKSpriteNode(imageNamed: "biker clean")
    
    var currentHealth:Int = 500
    
    var speedUpBiker:Int = 100
    var speedUpNumber:Int = 0
    
    var bikerResistance:Int = 2
    var resistUpNumber:Int = 0
    
    var bikerHealing:Int = 1
    var healUpNumber:Int = 0
    
    var pickUpNumber:Double = 0
    var speedUpGame:Double = (5)
    var obstacleFrequency:Double = (0.5)
    
    var healthBar = SKSpriteNode()
    var healthLabel = SKLabelNode()
    
    var gameTimer:Timer!
    var gameTimer2:Timer!
    var gameTimer3:Timer!
    var gameTimer4:Timer!
    var gameTimer5:Timer!
    var gameTimer6:Timer!
    var gameOver = false
    
    let bikerCategory:UInt32 = 1 << 1
    let carCategory:UInt32 = 1 << 2
    let borderCategory:UInt32 = 1 << 3
    let puddleCategory:UInt32 = 1 << 4
    let speedCategory:UInt32 = 1 << 5
    let resistCategory:UInt32 = 1 << 6
    let healCategory:UInt32 = 1 << 7
    
    var activeArray = [String]()
    
    func readyArray() {
        
        speedUpNumber = activeArray.filter{ $0 == "Speed"}.count
        resistUpNumber = activeArray.filter{ $0 == "Resist"}.count
        healUpNumber = activeArray.filter{ $0 == "Heal"}.count
    }

    @objc func powerUpUpdates() {
        if currentHealth < 500 {
        currentHealth += (bikerHealing*healUpNumber)
        }
        readyArray()
    }
    
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
        powerUpSpeed.physicsBody?.linearDamping = 0
        
        powerUpSpeed.physicsBody?.categoryBitMask = speedCategory
        powerUpSpeed.physicsBody?.contactTestBitMask = bikerCategory
        powerUpSpeed.physicsBody?.collisionBitMask = 0
        
        self.addChild(powerUpSpeed)
        
        powerUpSpeed.physicsBody?.velocity = CGVector(dx: 0, dy: -100 - (pickUpNumber*speedUpGame))
        
        if powerUpSpeed.position.y < -frame.size.height/4 {
            powerUpSpeed.removeFromParent()
        }
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
        powerUpResist.physicsBody?.linearDamping = 0
        
        powerUpResist.physicsBody?.categoryBitMask = resistCategory
        powerUpResist.physicsBody?.contactTestBitMask = bikerCategory
        powerUpResist.physicsBody?.collisionBitMask = 0
        
        self.addChild(powerUpResist)
        
        powerUpResist.physicsBody?.velocity = CGVector(dx: 0, dy: -100 - (pickUpNumber*speedUpGame))
        
        if powerUpResist.position.y < -frame.size.height/4 {
            powerUpResist.removeFromParent()
        }

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
        powerUpHeal.physicsBody?.linearDamping = 0
        
        powerUpHeal.physicsBody?.categoryBitMask = healCategory
        powerUpHeal.physicsBody?.contactTestBitMask = bikerCategory
        powerUpHeal.physicsBody?.collisionBitMask = 0
        
        self.addChild(powerUpHeal)
        
        powerUpHeal.physicsBody?.velocity = CGVector(dx: 0, dy: -100 - (pickUpNumber*speedUpGame))
        
        if powerUpHeal.position.y < -frame.size.height/4 {
            powerUpHeal.removeFromParent()
        }
    }
    
    @objc func addPowerUps() {
        
        var powerUpArray = [addHealUp,addSpeedUp,addResistanceUp]
        powerUpArray = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: powerUpArray) as! [() -> ()]
        powerUpArray[0]()
     
    }
    
    //power-ups end
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        addChild(biker)
        bikerBuild()
        
        healthLabel.color = .white
        healthLabel.position = CGPoint(x: frame.size.width * 0.68, y: frame.size.height * 0.962)
        healthLabel.zPosition = 6
        healthLabel.fontName = "AmericanTypewriter-bold"
        healthLabel.fontSize = 40
        
        healthBar.size = CGSize(width: currentHealth, height: 40)
        healthBar.position = CGPoint(x: frame.size.width * 0.76, y: frame.size.height * 0.97)
        healthBar.zPosition = 5
        healthBar.color = .red
        healthBar.name = "healthBar"
        addChild(healthBar)
        addChild(healthLabel)
        
 
        gameTimer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(addObstacleCar), userInfo: nil, repeats: true)
        gameTimer2 = Timer.scheduledTimer(timeInterval: 25, target: self, selector: #selector(addPuddle), userInfo: nil, repeats: true)
        gameTimer3 = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(healthProgress), userInfo: nil, repeats: true)
        gameTimer4 = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(addPowerUps), userInfo: nil, repeats: true)
        gameTimer5 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(powerUpUpdates), userInfo: nil, repeats: true)
        gameTimer6 = Timer.scheduledTimer(timeInterval: 1 - (pickUpNumber*obstacleFrequency), target: self, selector: #selector(createRoadStrip), userInfo: nil, repeats: true)
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
        obstacleCar.physicsBody?.linearDamping = 0
        
        obstacleCar.physicsBody?.categoryBitMask = carCategory
        obstacleCar.physicsBody?.contactTestBitMask = bikerCategory
        obstacleCar.physicsBody?.collisionBitMask = 0
        
        self.addChild(obstacleCar)
        
        obstacleCar.physicsBody?.velocity = CGVector(dx: 0, dy: -100 - (pickUpNumber*speedUpGame))
        
        if obstacleCar.position.y < -frame.size.height/4 {
            obstacleCar.removeFromParent()
        }
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
        puddle.physicsBody?.linearDamping = 0
        
        puddle.physicsBody?.categoryBitMask = puddleCategory
        puddle.physicsBody?.contactTestBitMask = bikerCategory
        puddle.physicsBody?.collisionBitMask = 0
        
        self.addChild(puddle)
        
        puddle.physicsBody?.velocity = CGVector(dx: 0, dy: -100 - (pickUpNumber*speedUpGame))
        
        if puddle.position.y < -frame.size.height/4 {
            puddle.removeFromParent()
        }
    }
    //puddles end
    
    @objc func createRoadStrip() {
        let strip = SKShapeNode(rectOf: CGSize(width: 10, height: 40))
        strip.fillColor = SKColor.white
        strip.strokeColor = SKColor.white
        strip.alpha = 0.4
        strip.name = "road strip"
        strip.position.x = frame.width / 2
        strip.position.y = frame.height
        strip.zPosition = 0
        strip.physicsBody = SKPhysicsBody()
        strip.physicsBody?.linearDamping = 0
        addChild(strip)
        
        strip.physicsBody?.velocity = CGVector(dx: 0, dy: -100 - (pickUpNumber*speedUpGame))
        if strip.position.y < 0 {
            strip.removeFromParent()
        }
    }
    
    //health begin
    func healthAnimation() {
        let removeHealth = SKAction.resize(toWidth: CGFloat(currentHealth), duration: 0.1)
        healthBar.run(removeHealth)
        healthLabel.text = "Health: \((currentHealth)*100/500)"
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
            currentHealth -= (10 - (resistUpNumber*bikerResistance))
            if currentHealth <= 0 {
                currentHealth = 0
                healthBar.removeFromParent()
                healthLabel.removeFromParent()
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
