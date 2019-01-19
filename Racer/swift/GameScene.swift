//
//  GameScene.swift
//  Racer
//  Authors: John Sudduth & Keegan Tountas
//  Copyright 2018
//

import SpriteKit
import GameplayKit
import UIKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let brick1 = SKSpriteNode(imageNamed: "brick2png")
    let brick2 = SKSpriteNode(imageNamed: "brick2png")
    let biker = SKSpriteNode(imageNamed: "biker clean")
    let speedEmitter = SKEmitterNode(fileNamed: "speed")!
    
    var currentHealth:Int = 10
    var healthBar = SKSpriteNode()
    var contactOnce = 0
    var xAcceleration:CGFloat = 0
    var initialBikerPosition: CGPoint!
    var obstacles = ["car"]
    var gameTimer:Timer!
    var gameTimer2:Timer!
    var gameTimer3:Timer!
    var gameTimer4:Timer!
    var gameTimer5:Timer!
    var gameOver = false
    
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
    
    override func didMove(to view: SKView) {
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        //Border definitions
        let rightBorder = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 1, height: self.frame.height))
        rightBorder.position = CGPoint(x: 0, y: self.frame.height / 2)
        rightBorder.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: rightBorder.frame.width, height: rightBorder.frame.height))
        rightBorder.physicsBody?.restitution = 0
        rightBorder.physicsBody?.categoryBitMask = Categories.right_border
        rightBorder.physicsBody?.isDynamic = false
        rightBorder.physicsBody?.friction = 1
        rightBorder.physicsBody?.affectedByGravity = false
        addChild(rightBorder)
        
        let leftBorder = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 1, height: self.frame.height))
        leftBorder.position = CGPoint(x: self.frame.width, y: self.frame.height / 2)
        leftBorder.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: leftBorder.frame.width, height: leftBorder.frame.height))
        leftBorder.physicsBody?.restitution = 0
        leftBorder.physicsBody?.categoryBitMask = Categories.left_boder
        leftBorder.physicsBody?.isDynamic = false
        leftBorder.physicsBody?.friction = 1
        leftBorder.physicsBody?.affectedByGravity = false
        addChild(leftBorder)
        
        //Health definition
        healthBar.size = CGSize(width: currentHealth, height: 40)
        healthBar.position = CGPoint(x: frame.size.width * 0.75, y: frame.size.height * 0.95)
        healthBar.zPosition = 5
        healthBar.color = .red
        healthBar.name = "healthBar"
        addChild(healthBar)
    
        //Biker definition
        biker.position = CGPoint(x: frame.size.width/2, y: frame.size.height/6)
        biker.zPosition = 10
        biker.physicsBody = SKPhysicsBody(texture: biker.texture!, size: biker.texture!.size())
        biker.physicsBody?.affectedByGravity = false
        biker.physicsBody?.isDynamic = true
        biker.name = "BIKER"
        biker.physicsBody?.categoryBitMask = Categories.biker
        biker.physicsBody?.contactTestBitMask = Categories.car
        biker.physicsBody?.collisionBitMask = 0
        biker.physicsBody?.usesPreciseCollisionDetection = true
        addChild(biker)
        
        addChild(speedEmitter)
        
        setup()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        print("didBegan called")
        
        switch contactMask  		 {
        case Categories.biker | Categories.car:
            print("biker-car")
            contact.bodyB.node?.removeFromParent()
            currentHealth -= 10
            if currentHealth <= 0 {
                let reveal = SKTransition.doorsCloseVertical(withDuration: 0.5)
                let gameOverScene = GameOverScene(size: CGSize(width: 1080, height: 1920))
                self.view?.presentScene(gameOverScene, transition: reveal)
            }
            
            
        case Categories.biker | Categories.puddle:
            
            contact.bodyB.node?.removeFromParent()
            if activeArray.count >= 1 {
                activeArray.removeLast()
            } else {
                return
            }
            
        case Categories.biker | Categories.speedBuff:
            
            contact.bodyB.node?.removeFromParent()
            pickUpNumber += 1
            speedEmitter.particleBirthRate += 25
            if activeArray.count < 5 {
                activeArray.append("Speed")
            } else{
                return
            }
            
        case Categories.biker | Categories.resistBuff:
            
            contact.bodyB.node?.removeFromParent()
            pickUpNumber += 1
            if activeArray.count < 5{
                activeArray.append("Resist")
            } else{
                return
            }
            
        case Categories.biker | Categories.healthBuff:
            
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
    
    override func update(_ currentTime: CFTimeInterval) {
        showRoadStrip()
        speedEmitter.position = CGPoint(x: biker.position.x, y: biker.position.y - 10)
    }
    
    @objc func setup() {
        Timer.scheduledTimer(timeInterval: TimeInterval(0.25), target: self, selector: #selector(GameScene.createRoadStrip), userInfo: nil, repeats: true)
        gameTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(addObstacleCar), userInfo: nil, repeats: true)
        gameTimer2 = Timer.scheduledTimer(timeInterval: 8, target: self, selector: #selector(addPuddle), userInfo: nil, repeats: true)
        gameTimer3 = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(healthProgress), userInfo: nil, repeats: true)
        gameTimer4 = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(addPowerUps), userInfo: nil, repeats: true)
        gameTimer5 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(readPowerUpArray), userInfo: nil, repeats: true)
    }
    
    func showRoadStrip() {
        enumerateChildNodes(withName: "road strip", using: { (roadStrip, stop) in
            let strip = roadStrip as! SKShapeNode
            strip.position.y -= 30
            if strip.position.y < 0 {
                strip.removeFromParent()
            }
        })

    }
    
    @objc func createRoadStrip() {
        let roadStrip = SKShapeNode(rectOf: CGSize(width: 10, height: 40))
        roadStrip.fillColor = SKColor.white
        roadStrip.strokeColor = SKColor.white
        roadStrip.alpha = 0.4
        roadStrip.name = "road strip"
        roadStrip.position.x = frame.width / 2
        roadStrip.position.y = frame.height
        addChild(roadStrip)
    }

    @objc func createCarObstacle() {
        let car = SKSpriteNode(fileNamed: "car")
        car?.position.x = frame.width / 4
    }
    
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
        
        puddle.physicsBody?.categoryBitMask = Categories.puddle
        puddle.physicsBody?.contactTestBitMask = Categories.biker
        puddle.physicsBody?.collisionBitMask = 0
        
        self.addChild(puddle)
        
        let animationDuration:TimeInterval = 20
        
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.moveBy(x: 0, y: -frame.size.height * 2, duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        
        puddle.run(SKAction.sequence(actionArray))
    }
    
    @objc func addObstacleCar() {
        print("obstaclecar")
        let obstacleCar = SKSpriteNode(imageNamed: "car")
        
        let positionArrayX = [frame.size.width/8,frame.size.width * 0.375, frame.size.width * 0.625,frame.size.width * 0.875]
        let nextPosition = positionArrayX[Int(arc4random_uniform(UInt32(positionArrayX.count)))]
        
        obstacleCar.position = CGPoint(x: nextPosition, y: frame.size.height * 1.5)
        obstacleCar.zPosition = 2
        obstacleCar.physicsBody = SKPhysicsBody(texture: obstacleCar.texture!, size: obstacleCar.texture!.size())
        
        obstacleCar.physicsBody?.categoryBitMask = Categories.car
        obstacleCar.physicsBody?.contactTestBitMask = Categories.biker
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
        
        powerUpSpeed.physicsBody?.categoryBitMask = Categories.speedBuff
        powerUpSpeed.physicsBody?.contactTestBitMask = Categories.biker
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
        
        powerUpResist.physicsBody?.categoryBitMask = Categories.resistBuff
        powerUpResist.physicsBody?.contactTestBitMask = Categories.biker
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
        
        powerUpHeal.physicsBody?.categoryBitMask = Categories.healthBuff
        powerUpHeal.physicsBody?.contactTestBitMask = Categories.biker
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
}
