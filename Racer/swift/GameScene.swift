//
//  GameScene.swift
//  Racer
//  Authors: John Sudduth & Keegan Tountas
//  Copyright 2018

import SpriteKit
import GameplayKit
import UIKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let biker = SKSpriteNode(imageNamed: "ship_v1")
    let shield = SKShapeNode(circleOfRadius: 200)
    
    var currentHealth:Int = 500
    
    var speedUpBiker:Int = 100
    var speedUpNumber:Int = 0
    
    var bikerResistance:Int = 2
    var resistUpNumber:Int = 0
    
    var bikerHealing:Int = 1
    var healUpNumber:Int = 0
    
    var pickUpNumber:Double = 0
    var speedUpGame:Double = 5
    var obstacleFrequency:Double = (0.5)
    
    var shieldOn:Bool = false
    
    var healthBar = SKSpriteNode()
    var healthLabel = SKLabelNode()
    var cameraNode = SKCameraNode()
    let speedParticlesRight = SKEmitterNode(fileNamed: "Speed Right.sks")
    let speedParticles = SKEmitterNode(fileNamed: "Speed.sks")
    let resistParticlesRight = SKEmitterNode(fileNamed: "Resist Right.sks")
    let resistParticles = SKEmitterNode(fileNamed: "Resist.sks")
    let healParticlesRight = SKEmitterNode(fileNamed: "Heal Right.sks")
    let healParticles = SKEmitterNode(fileNamed: "Heal.sks")
    let speedBoostEmitter = SKEmitterNode(fileNamed: "speedBoost")!
    
    let rect1 = SKShapeNode(rectOf: CGSize(width: 90, height: 90))
    let rect2 = SKShapeNode(rectOf: CGSize(width: 90, height: 90))
    let rect3 = SKShapeNode(rectOf: CGSize(width: 90, height: 90))
    let rect4 = SKShapeNode(rectOf: CGSize(width: 90, height: 90))
    let rect5 = SKShapeNode(rectOf: CGSize(width: 90, height: 90))
    let rect6 = SKShapeNode(rectOf: CGSize(width: 200, height: 200))
    
    var gameOver = false

    //Categories
    let bikerCategory:UInt32 = 1 << 1
    let carCategory:UInt32 = 1 << 2
    let borderCategory:UInt32 = 1 << 3
    let puddleCategory:UInt32 = 1 << 4
    let speedCategory:UInt32 = 1 << 5
    let resistCategory:UInt32 = 1 << 6
    let healCategory:UInt32 = 1 << 7
    let shieldCategory:UInt32 = 1 << 8
    
    var activeArray = [String]()
    
    override func didMove(to view: SKView) {
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        self.backgroundColor = UIColor.black
        
        //new
        let lightSource = SKLightNode()
        lightSource.categoryBitMask = 1
        lightSource.falloff = 0
        lightSource.ambientColor = SKColor(displayP3Red: 0.3, green: 0.3, blue: 0.3, alpha: 0.8)
        lightSource.lightColor = SKColor(displayP3Red: 0.8, green: 0.8, blue: 0.8, alpha: 0.8)
        lightSource.shadowColor = SKColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.8)
        lightSource.position = CGPoint(x: frame.size.width/2, y: frame.size.height*0.2)
        addChild(lightSource)
        //old
        
        let rightBorder = SKSpriteNode(color: UIColor.red, size: CGSize(width: 100, height: self.frame.height))
        rightBorder.position = CGPoint(x: -frame.size.width, y: self.frame.height / 2)
        rightBorder.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: rightBorder.size.width, height: rightBorder.size.height))
        rightBorder.physicsBody?.restitution = 0
        rightBorder.physicsBody?.categoryBitMask = borderCategory
        rightBorder.physicsBody?.contactTestBitMask = bikerCategory
        rightBorder.physicsBody?.collisionBitMask = bikerCategory
        rightBorder.physicsBody?.isDynamic = false
        rightBorder.physicsBody?.friction = 1
        rightBorder.zPosition = 1
        rightBorder.physicsBody?.affectedByGravity = false
        addChild(rightBorder)
        
        let leftBorder = SKSpriteNode(color: UIColor.red, size: CGSize(width: 100, height: self.frame.height))
        leftBorder.position = CGPoint(x: frame.size.width*2, y: self.frame.height / 2)
        leftBorder.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: leftBorder.size.width, height: leftBorder.size.height))
        leftBorder.physicsBody?.restitution = 0
        leftBorder.physicsBody?.categoryBitMask = borderCategory
        leftBorder.physicsBody?.contactTestBitMask = bikerCategory
        leftBorder.physicsBody?.collisionBitMask = bikerCategory
        leftBorder.physicsBody?.isDynamic = false
        leftBorder.physicsBody?.friction = 1
        leftBorder.zPosition = 1
        leftBorder.physicsBody?.affectedByGravity = false
        addChild(leftBorder)
        
        camera = cameraNode
        cameraNode.position.x = frame.size.width/2
        cameraNode.position.y = frame.size.height/2
        addChild(cameraNode)
        
        addChild(biker)
        bikerBuild()
        
        rect1.zPosition = 5
        rect1.position = CGPoint(x: frame.size.width * 0.585, y: frame.size.height * 0.935)
        rect1.strokeColor = .black
        rect1.isHidden = true
        addChild(rect1)
        
        rect2.zPosition = 5
        rect2.position = CGPoint(x: frame.size.width * 0.67, y: frame.size.height * 0.935)
        rect2.strokeColor = .black
        rect2.isHidden = true
        addChild(rect2)
        
        rect3.zPosition = 5
        rect3.position = CGPoint(x: frame.size.width * 0.755, y: frame.size.height * 0.935)
        rect3.strokeColor = .black
        rect3.isHidden = true
        addChild(rect3)
        
        rect4.zPosition = 5
        rect4.position = CGPoint(x: frame.size.width * 0.84, y: frame.size.height * 0.935)
        rect4.strokeColor = .black
        rect4.isHidden = true
        addChild(rect4)
        
        rect5.zPosition = 5
        rect5.position = CGPoint(x: frame.size.width * 0.925, y: frame.size.height * 0.935)
        rect5.strokeColor = .black
        rect5.isHidden = true
        addChild(rect5)
        
        rect6.zPosition = 5
        rect6.position = CGPoint(x: frame.size.width * 0.093, y: frame.size.height * 0.95)
        rect6.fillColor = .orange
        rect6.isHidden = true
        addChild(rect6)
        
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
        
        let starfield = SKEmitterNode(fileNamed: "Space")!
        starfield.position = CGPoint(x: 0, y: 1472)
        starfield.advanceSimulationTime(10)
        self.addChild(starfield)
        
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(addObstacleCar), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(addPuddle), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(addPowerUps), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runPowerUpCombinations), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateArrayImage), userInfo: nil, repeats: true)
        
    }
    
    func readyArray() {
        
        speedUpNumber = activeArray.filter{ $0 == "Speed"}.count
        resistUpNumber = activeArray.filter{ $0 == "Resist"}.count
        healUpNumber = activeArray.filter{ $0 == "Heal"}.count
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
    
    func healEmitter() {
        let delay1 = SKAction.wait(forDuration: 1.5)
        let remove1 = SKAction.removeFromParent()
        let sequence1 = SKAction.sequence([delay1,remove1])
        addChild(healParticles!)
        healParticles?.run(sequence1)
        
        let delay2 = SKAction.wait(forDuration: 1.5)
        let remove2 = SKAction.removeFromParent()
        let sequence2 = SKAction.sequence([delay2,remove2])
        addChild(healParticlesRight!)
        healParticlesRight?.run(sequence2)
    }
    
    func resistEmitter() {
        let delay1 = SKAction.wait(forDuration: 1.5)
        let remove1 = SKAction.removeFromParent()
        let sequence1 = SKAction.sequence([delay1,remove1])
        addChild(resistParticles!)
        resistParticles?.run(sequence1)
        
        let delay2 = SKAction.wait(forDuration: 1.5)
        let remove2 = SKAction.removeFromParent()
        let sequence2 = SKAction.sequence([delay2,remove2])
        addChild(resistParticlesRight!)
        resistParticlesRight?.run(sequence2)
    }
    
    func speedEmitter() {
        let delay1 = SKAction.wait(forDuration: 1.5)
        let remove1 = SKAction.removeFromParent()
        let sequence1 = SKAction.sequence([delay1,remove1])
        addChild(speedParticles!)
        speedParticles?.run(sequence1)
        
        let delay2 = SKAction.wait(forDuration: 1.5)
        let remove2 = SKAction.removeFromParent()
        let sequence2 = SKAction.sequence([delay2,remove2])
        addChild(speedParticlesRight!)
        speedParticlesRight?.run(sequence2)
    }
    
    @objc func addPowerUps() {
        var powerUpArray = [addSpeedUp,addResistanceUp]
        powerUpArray = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: powerUpArray) as! [() -> ()]
        powerUpArray[0]()
     
    }
    
    @objc func runPowerUpCombinations() {
        powerUpCombinations()
    }

    @objc func updateArrayImage() {
        
        if activeArray.count >= 1 {
            rect1.isHidden = false
            if activeArray[0] == "Speed" {
                rect1.fillColor = .yellow
            } else if activeArray [0] == "Resist" {
                rect1.fillColor = .blue
            } else if activeArray [0] == "Heal" {
                rect1.fillColor = .green
            } else {
                return
            }
        } else {
            rect1.isHidden = true
        }
        
        
        if activeArray.count >= 2 {
            rect2.isHidden = false
            if activeArray[1] == "Speed" {
                rect2.fillColor = .yellow
            } else if activeArray [1] == "Resist" {
                rect2.fillColor = .blue
            } else if activeArray [1] == "Heal" {
                rect2.fillColor = .green
            } else {
                return
            }
        } else {
            rect2.isHidden = true
        }
        
        
        if activeArray.count >= 3 {
            rect3.isHidden = false
            if activeArray[2] == "Speed" {
                rect3.fillColor = .yellow
            } else if activeArray [2] == "Resist" {
                rect3.fillColor = .blue
            } else if activeArray [2] == "Heal" {
                rect3.fillColor = .green
            } else {
                return
            }
        } else {
            rect3.isHidden = true
        }
        
        if activeArray.count >= 4 {
            rect4.isHidden = false
            if activeArray[3] == "Speed" {
                rect4.fillColor = .yellow
            } else if activeArray [3] == "Resist" {
                rect4.fillColor = .blue
            } else if activeArray [3] == "Heal" {
                rect4.fillColor = .green
            } else {
                return
            }
        } else {
            rect4.isHidden = true
        }
        
        if activeArray.count == 5 {
            rect5.isHidden = false
            if activeArray[4] == "Speed" {
                rect5.fillColor = .yellow
            } else if activeArray [4] == "Resist" {
                rect5.fillColor = .blue
            } else if activeArray [4] == "Heal" {
                rect5.fillColor = .green
            } else {
                return
            }
        } else {
            rect5.isHidden = true
        }
        
    }

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
        
        obstacleCar.physicsBody?.velocity = CGVector(dx: 0, dy: -500 - (pickUpNumber*speedUpGame))
        
        if obstacleCar.position.y < -frame.size.height/4 {
            obstacleCar.removeFromParent()
        }
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
    
    func shieldBuild(){
        print("shield")
        shield.strokeColor = .blue
        shield.lineWidth = 2
        shield.glowWidth = 2
        shield.zPosition = 6
        shield.position = (CGPoint(x: biker.position.x, y: biker.position.y))
        shield.physicsBody = SKPhysicsBody(circleOfRadius: 200)
        shield.physicsBody?.isDynamic = true
        shield.physicsBody?.categoryBitMask = shieldCategory
        shield.physicsBody?.contactTestBitMask = carCategory
        shield.physicsBody?.collisionBitMask = 0
    
        self.addChild(shield)
    }
    
    func makeShield() {
        
        if shieldOn == false {
            let delay = SKAction.wait(forDuration: 5)
            let on = SKAction.run({self.shieldBuild()})
            let sequence = SKAction.sequence([delay, on])
            run(sequence)
            shieldOn = true
        }else{
            let follow = SKAction.move(to: CGPoint(x: biker.position.x, y: biker.position.y), duration: 0.1)
            let chase = SKAction.repeatForever(follow)
            shield.run(chase)
        }
    }
    
    func healthAnimation() {
        let removeHealth = SKAction.resize(toWidth: CGFloat(currentHealth), duration: 0.1)
        healthBar.run(removeHealth)
        healthLabel.text = "Health: \((currentHealth)*100/500)"
        
        }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch contactMask {
        case bikerCategory | carCategory:
            
            contact.bodyB.node?.removeFromParent()
            currentHealth -= (10 - (resistUpNumber*bikerResistance))
            print("biker-car")
            if currentHealth <= 0 {
                currentHealth = 0
                healthBar.removeFromParent()
                healthLabel.removeFromParent()
                if currentHealth <= 0 {
                    gameOver = true
                    let reveal = SKTransition.doorsCloseVertical(withDuration: 0.5)
                    let gameOverScene = GameOverScene(size: CGSize(width: 1080, height: 1920))
                    self.view?.presentScene(gameOverScene, transition: reveal)
                }
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
                speedEmitter()
            } else{
                return
            }
            
        case bikerCategory | resistCategory:
 
            contact.bodyB.node?.removeFromParent()
            pickUpNumber += 1
            if activeArray.count < 5{
                activeArray.append("Resist")
                resistEmitter()
            } else{
                return
            }
            
        case bikerCategory | healCategory:

            contact.bodyB.node?.removeFromParent()
            healEmitter()
            pickUpNumber += 1
            if activeArray.count < 5{
                activeArray.append("Heal")
                healEmitter()
            } else {
                return
            }
            
        case shieldCategory | carCategory:
            
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            
            shieldOn = false
            
        case borderCategory | bikerCategory:
            
            return
            
        default:
            return
        }
    }
    
    override func update(_ currentTime: TimeInterval){
        healthLabel.position.x = biker.position.x + frame.size.width*(9/50)
        healthBar.position.x = biker.position.x + frame.size.width/4
        rect1.position.x = biker.position.x + frame.size.width * 0.085
        rect2.position.x = biker.position.x + frame.size.width * 0.17
        rect3.position.x = biker.position.x + frame.size.width * 0.255
        rect4.position.x = biker.position.x + frame.size.width * 0.34
        rect5.position.x = biker.position.x + frame.size.width * 0.425
        rect6.position.x = biker.position.x - frame.size.width * 0.407
        cameraNode.position.x = biker.position.x
        speedParticlesRight?.position.x = biker.position.x + frame.size.width/2
        speedParticlesRight?.position.y = frame.size.height/2
        speedParticles?.position.x = biker.position.x - frame.size.width/2
        speedParticles?.position.y = frame.size.height/2
        resistParticlesRight?.position.x = biker.position.x + frame.size.width/2
        resistParticlesRight?.position.y = frame.size.height/2
        resistParticles?.position.x = biker.position.x - frame.size.width/2
        resistParticles?.position.y = frame.size.height/2
        healParticlesRight?.position.x = biker.position.x + frame.size.width/2
        healParticlesRight?.position.y = frame.size.height/2
        healParticles?.position.x = biker.position.x - frame.size.width/2
        healParticles?.position.y = frame.size.height/2
        healthAnimation()
        if currentHealth < 500 {
            currentHealth += (bikerHealing*healUpNumber)
        }
        readyArray()
        return
    }

}
