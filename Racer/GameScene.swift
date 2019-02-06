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
    
    let biker = SKSpriteNode(imageNamed: "biker clean")
    let shield = SKShapeNode(circleOfRadius: 200)
    let button = SKShapeNode(rectOf: CGSize(width: 1080, height: 110))
    
    var currentHealth:Int = 500
    var movementValue:Float = 0
    var velocityDy:Double = -100
    
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
    var buttonOn:Bool = false
    var bombBoxOn:Bool = false
    var bombFire:Bool = false
    var teleportOn:Bool = false
    var bCar:Bool = false
    var bPuddle:Bool = false
    var bHeal:Bool = false
    var bResist:Bool = false
    var bSpeed:Bool = false
    var moveRight:Bool = true
    var moveLeft:Bool = false
    
    var healthBar = SKSpriteNode()
    var healthLabel = SKLabelNode()
    var cameraNode = SKCameraNode()
    let speedParticlesRight = SKEmitterNode(fileNamed: "Speed Right.sks")
    let speedParticles = SKEmitterNode(fileNamed: "Speed.sks")
    let resistParticlesRight = SKEmitterNode(fileNamed: "Resist Right.sks")
    let resistParticles = SKEmitterNode(fileNamed: "Resist.sks")
    let healParticlesRight = SKEmitterNode(fileNamed: "Heal Right.sks")
    let healParticles = SKEmitterNode(fileNamed: "Heal.sks")
    let starfieldNode = SKSpriteNode(imageNamed: "starfield")
    let starfieldNode2 = SKSpriteNode(imageNamed: "starfield")
    
    var rect1 = SKSpriteNode()
    var rect2 = SKSpriteNode()
    var rect3 = SKSpriteNode()
    var rect4 = SKSpriteNode()
    var rect5 = SKSpriteNode()
    var rect6 = SKSpriteNode()
    
    var bombBox = SKSpriteNode(imageNamed: "reticule")
    
    var gameTimer:Timer!
    var gameTimer2:Timer!
    var gameTimer4:Timer!
    var gameTimer7:Timer!
    var gameTimer8:Timer!
    var gameOver = false
    
    let bikerCategory:UInt32 = 1 << 1
    let carCategory:UInt32 = 1 << 2
    let borderCategory:UInt32 = 1 << 3
    let puddleCategory:UInt32 = 1 << 4
    let speedCategory:UInt32 = 1 << 5
    let resistCategory:UInt32 = 1 << 6
    let healCategory:UInt32 = 1 << 7
    let shieldCategory:UInt32 = 1 << 8
    let bombCategory:UInt32 = 1 << 9
    
    var activeArray = [String]()
    
    func readyArray() {
        
        speedUpNumber = activeArray.filter{ $0 == "Speed"}.count
        resistUpNumber = activeArray.filter{ $0 == "Resist"}.count
        healUpNumber = activeArray.filter{ $0 == "Heal"}.count
    }
    
    func makeButton() {
        button.position = CGPoint(x: frame.size.width/2, y: frame.size.width/20)
        button.fillColor = UIColor.red
    }
    
    var doubleTapRecognizer: UITapGestureRecognizer {
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubleTapDetected))
        
        tapRecognizer.numberOfTapsRequired = 2
        
        return tapRecognizer
    }
    
    @objc func doubleTapDetected() {
        print("double tap")
    }
    
    @objc func addSpeedUp() {
        
        let powerUpSpeed = SKSpriteNode(imageNamed: "speed pickup")
        powerUpSpeed.size = CGSize(width: 300, height: 300)
        let randomSpeedPosition = GKRandomDistribution(lowestValue: 100, highestValue:980)
        let position = CGFloat(randomSpeedPosition.nextInt())
        
        powerUpSpeed.position = CGPoint(x: position, y: self.frame.size.height * 1.5)
        powerUpSpeed.zPosition = 2
        powerUpSpeed.physicsBody = SKPhysicsBody(texture: powerUpSpeed.texture!, size: powerUpSpeed.size)
        powerUpSpeed.physicsBody?.isDynamic = true
        powerUpSpeed.physicsBody?.linearDamping = 0
        
        powerUpSpeed.physicsBody?.categoryBitMask = speedCategory
        powerUpSpeed.physicsBody?.contactTestBitMask = bikerCategory
        powerUpSpeed.physicsBody?.collisionBitMask = 0
        
        self.addChild(powerUpSpeed)
        
        powerUpSpeed.physicsBody?.velocity = CGVector(dx: 0, dy: velocityDy)
        
        if powerUpSpeed.position.y < -frame.size.height/4 {
            powerUpSpeed.removeFromParent()
        }
    }
    
    @objc func addResistanceUp() {
        
        let powerUpResist = SKSpriteNode(imageNamed: "resist pickup")
        powerUpResist.size = CGSize(width: 300, height: 300)
        let randomResistPosition = GKRandomDistribution(lowestValue: 100, highestValue:980)
        let position = CGFloat(randomResistPosition.nextInt())
        
        powerUpResist.position = CGPoint(x: position, y: self.frame.size.height * 1.5)
        powerUpResist.zPosition = 2
        powerUpResist.physicsBody = SKPhysicsBody(texture: powerUpResist.texture!, size: powerUpResist.size)
        powerUpResist.physicsBody?.isDynamic = true
        powerUpResist.physicsBody?.linearDamping = 0
        
        powerUpResist.physicsBody?.categoryBitMask = resistCategory
        powerUpResist.physicsBody?.contactTestBitMask = bikerCategory
        powerUpResist.physicsBody?.collisionBitMask = 0
        
        self.addChild(powerUpResist)
        
        powerUpResist.physicsBody?.velocity = CGVector(dx: 0, dy: velocityDy)
        
        if powerUpResist.position.y < -frame.size.height/4 {
            powerUpResist.removeFromParent()
        }

    }
    
    @objc func addHealUp() {
        
        let powerUpHeal = SKSpriteNode(imageNamed: "heal pickup")
        powerUpHeal.size = CGSize(width: 250, height: 250)
        let randomHealPosition = GKRandomDistribution(lowestValue: 100, highestValue:980)
        let position = CGFloat(randomHealPosition.nextInt())
        
        powerUpHeal.position = CGPoint(x: position, y: self.frame.size.height * 1.5)
        powerUpHeal.zPosition = 2
        powerUpHeal.physicsBody = SKPhysicsBody(texture: powerUpHeal.texture!, size: powerUpHeal.size)
        powerUpHeal.physicsBody?.isDynamic = true
        powerUpHeal.physicsBody?.linearDamping = 0
        
        powerUpHeal.physicsBody?.categoryBitMask = healCategory
        powerUpHeal.physicsBody?.contactTestBitMask = bikerCategory
        powerUpHeal.physicsBody?.collisionBitMask = 0
        
        self.addChild(powerUpHeal)
        
        powerUpHeal.physicsBody?.velocity = CGVector(dx: 0, dy: velocityDy)
        
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
        
        var powerUpArray = [addHealUp,addSpeedUp,addResistanceUp]
        powerUpArray = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: powerUpArray) as! [() -> ()]
        powerUpArray[0]()
     
    }
    
    func starField() {

        starfieldNode.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        starfieldNode.size = CGSize(width: frame.size.width, height: frame.size.height)
        starfieldNode2.position = CGPoint(x: frame.size.width/2, y: frame.size.height*1.5)
        starfieldNode2.size = CGSize(width: frame.size.width, height: frame.size.height)
        let move = SKAction.moveBy(x: 0, y: -frame.size.height, duration: 25)
        let reset = SKAction.move(to: CGPoint(x: frame.size.width/2, y: frame.size.height/2), duration: 0)
        let sequence = SKAction.sequence([move, reset])
        let rep = SKAction.repeatForever(sequence)
        let move2 = SKAction.moveBy(x: 0, y: -frame.size.height, duration: 25)
        let reset2 = SKAction.move(to: CGPoint(x: frame.size.width/2, y: frame.size.height*1.5), duration: 0)
        let sequence2 = SKAction.sequence([move2, reset2])
        let rep2 = SKAction.repeatForever(sequence2)
        starfieldNode.run(rep)
        starfieldNode2.run(rep2)
        addChild(starfieldNode)
        addChild(starfieldNode2)
    }
    
    func powerUpCombinations() {
        if currentHealth < 500 {
            currentHealth += (bikerHealing*healUpNumber)
        }
        
        if teleportOn == false {
            let delay = SKAction.wait(forDuration: 3)
            let on = SKAction.run {self.teleportOn = true}
            let sequence = SKAction.sequence([delay,on])
            self.run(sequence)
        }
        
        if speedUpNumber == 5 {
            if teleportOn == false {
                let delay = SKAction.wait(forDuration: 3)
                let on = SKAction.run {self.teleportOn = true}
                let sequence = SKAction.sequence([delay,on])
                self.run(sequence)
            }
            rect6.isHidden = false
        } else if healUpNumber == 5 {
            rect6.isHidden = false
        } else if resistUpNumber == 5 {
            makeShield()
            rect6.texture = SKTexture(imageNamed: "resist icon")
            rect6.isHidden = false
        }
        else if speedUpNumber == 4 && resistUpNumber == 1{
            rect6.isHidden = false
        } else if speedUpNumber == 4 && healUpNumber == 1{
            rect6.isHidden = false
        } else if speedUpNumber == 3 && resistUpNumber == 2{
            rect6.isHidden = false
        } else if speedUpNumber == 3 && healUpNumber == 2{
            rect6.isHidden = false
        } else if speedUpNumber == 3 && resistUpNumber == 1 && healUpNumber == 1 {
            rect6.isHidden = false
        } else if speedUpNumber == 2 && resistUpNumber == 3 {
            rect6.isHidden = false
        } else if speedUpNumber == 2 && resistUpNumber == 2 && healUpNumber == 1 {
            //throw bomb
            //add cooldown timer
            //add rect 6 image
            
            if bombBoxOn == false {
                let delay = SKAction.wait(forDuration: 5)
                let on = SKAction.run {self.bombBoxOn = true}
                let sequence = SKAction.sequence([delay,on])
                self.run(sequence)
                bombBox.isHidden = true
            } else if bombBoxOn == true {
                bombBox.isHidden = false
            }
            
            rect6.isHidden = false
        } else if speedUpNumber == 2 && resistUpNumber == 1 && healUpNumber == 2 {
            rect6.isHidden = false
        }else if speedUpNumber == 2 && healUpNumber == 3 {
            rect6.isHidden = false
        } else if speedUpNumber == 1 && resistUpNumber == 4{
            rect6.isHidden = false
        } else if speedUpNumber == 1 && resistUpNumber == 3 && healUpNumber == 1 {
            rect6.isHidden = false
        } else if speedUpNumber == 1 && resistUpNumber == 2 && healUpNumber == 2 {
            rect6.isHidden = false
        } else if speedUpNumber == 1 && resistUpNumber == 1 && healUpNumber == 3 {
            rect6.isHidden = false
        } else if speedUpNumber == 1 && healUpNumber == 4 {
            rect6.isHidden = false
        } else if healUpNumber == 2 && resistUpNumber == 3 {
            rect6.isHidden = false
        } else if healUpNumber == 3 && resistUpNumber == 2 {
            rect6.isHidden = false
        } else if healUpNumber == 4 && resistUpNumber == 1 {
            rect6.isHidden = false
        } else if resistUpNumber == 4 && healUpNumber == 1 {
            rect6.isHidden = false
        } else {
            rect6.isHidden = true
        }
        bombFire = false

    }
    
    @objc func runPowerUpCombinations() {
        powerUpCombinations()
    }

    @objc func updateArrayImage() {
        
        if activeArray.count >= 1 {
            rect1.isHidden = false
            if activeArray[0] == "Speed" {
                rect1.texture = SKTexture(imageNamed: "speed icon")
            } else if activeArray [0] == "Resist" {
                rect1.texture = SKTexture(imageNamed: "resist icon 3")
            } else if activeArray [0] == "Heal" {
                rect1.texture = SKTexture(imageNamed: "heal icon 2")
            } else {
                return
            }
        } else {
            rect1.isHidden = true
        }
        
        
        if activeArray.count >= 2 {
            rect2.isHidden = false
            if activeArray[1] == "Speed" {
                rect2.texture = SKTexture(imageNamed: "speed icon")
            } else if activeArray [1] == "Resist" {
                rect2.texture = SKTexture(imageNamed: "resist icon 3")
            } else if activeArray [1] == "Heal" {
                rect2.texture = SKTexture(imageNamed: "heal icon 2")
            } else {
                return
            }
        } else {
            rect2.isHidden = true
        }
        
        
        if activeArray.count >= 3 {
            rect3.isHidden = false
            if activeArray[2] == "Speed" {
                rect3.texture = SKTexture(imageNamed: "speed icon")
            } else if activeArray [2] == "Resist" {
                rect3.texture = SKTexture(imageNamed: "resist icon 3")
            } else if activeArray [2] == "Heal" {
                rect3.texture = SKTexture(imageNamed: "heal icon 2")
            } else {
                return
            }
        } else {
            rect3.isHidden = true
        }
        
        if activeArray.count >= 4 {
            rect4.isHidden = false
            if activeArray[3] == "Speed" {
                rect4.texture = SKTexture(imageNamed: "speed icon")
            } else if activeArray [3] == "Resist" {
                rect4.texture = SKTexture(imageNamed: "resist icon 3")
            } else if activeArray [3] == "Heal" {
                rect4.texture = SKTexture(imageNamed: "heal icon 2")
            } else {
                return
            }
        } else {
            rect4.isHidden = true
        }
        
        if activeArray.count == 5 {
            rect5.isHidden = false
            if activeArray[4] == "Speed" {
                rect5.texture = SKTexture(imageNamed: "speed icon")
            } else if activeArray [4] == "Resist" {
                rect5.texture = SKTexture(imageNamed: "resist icon 3")
            } else if activeArray [4] == "Heal" {
                rect5.texture = SKTexture(imageNamed: "heal icon 2")
            } else {
                return
            }
        } else {
            rect5.isHidden = true
        }
        
    }
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        //new
        //let lightSource = SKLightNode()
        //lightSource.categoryBitMask = 1
        //lightSource.falloff = 0
        //lightSource.ambientColor = SKColor(displayP3Red: 0.3, green: 0.3, blue: 0.3, alpha: 0.8)
        //lightSource.lightColor = SKColor(displayP3Red: 0.8, green: 0.8, blue: 0.8, alpha: 0.8)
        //lightSource.shadowColor = SKColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.8)
        //lightSource.position = CGPoint(x: frame.size.width/2, y: frame.size.height*0.2)
        //addChild(lightSource)
        //old
        
        let rightBorder = SKSpriteNode(color: UIColor.red, size: CGSize(width: 100, height: self.frame.height))
        rightBorder.position = CGPoint(x: -frame.size.width/2, y: self.frame.height / 2)
        rightBorder.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: rightBorder.size.width, height: rightBorder.size.height))
        rightBorder.physicsBody?.restitution = 0
        rightBorder.physicsBody?.categoryBitMask = borderCategory
        rightBorder.physicsBody?.collisionBitMask = bikerCategory
        rightBorder.physicsBody?.contactTestBitMask = bikerCategory
        rightBorder.physicsBody?.isDynamic = false
        rightBorder.physicsBody?.friction = 1
        rightBorder.physicsBody?.affectedByGravity = false
        addChild(rightBorder)
        
        let leftBorder = SKSpriteNode(color: UIColor.red, size: CGSize(width: 100, height: self.frame.height))
        leftBorder.position = CGPoint(x: frame.size.width*1.5, y: self.frame.height / 2)
        leftBorder.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: leftBorder.size.width, height: leftBorder.size.height))
        leftBorder.physicsBody?.restitution = 0
        leftBorder.physicsBody?.categoryBitMask = borderCategory
        leftBorder.physicsBody?.collisionBitMask = bikerCategory
        leftBorder.physicsBody?.contactTestBitMask = bikerCategory
        leftBorder.physicsBody?.isDynamic = false
        leftBorder.physicsBody?.friction = 1
        leftBorder.physicsBody?.affectedByGravity = false
        addChild(leftBorder)
        
        camera = cameraNode
        cameraNode.position.x = frame.size.width/2
        cameraNode.position.y = frame.size.height/2
        addChild(cameraNode)
        
        addChild(biker)
        bikerBuild()
        
        addChild(button)
        makeButton()
        
        starField()
        
        bombBox.physicsBody = SKPhysicsBody(texture: bombBox.texture!, size: bombBox.size)
        bombBox.position = CGPoint(x: frame.size.width/2, y: frame.size.height*(5.5/10))
        bombBox.physicsBody?.categoryBitMask = bombCategory
        bombBox.physicsBody?.contactTestBitMask = carCategory
        bombBox.physicsBody?.collisionBitMask = 0
        bombBox.isHidden = true
        addChild(bombBox)
        
        rect1.zPosition = 5
        rect1.position = CGPoint(x: frame.size.width * 0.58, y: frame.size.height * 0.9335)
        rect1.size = CGSize(width: 97, height: 97)
        rect1.isHidden = true
        addChild(rect1)
        
        rect2.zPosition = 5
        rect2.position = CGPoint(x: frame.size.width * 0.66, y: frame.size.height * 0.9335)
        rect2.size = CGSize(width: 97, height: 97)
        rect2.isHidden = true
        addChild(rect2)
        
        rect3.zPosition = 5
        rect3.position = CGPoint(x: frame.size.width * 0.76, y: frame.size.height * 0.9335)
        rect3.size = CGSize(width: 97, height: 97)
        rect3.isHidden = true
        addChild(rect3)
        
        rect4.zPosition = 5
        rect4.position = CGPoint(x: frame.size.width * 0.85, y: frame.size.height * 0.9335)
        rect4.size = CGSize(width: 97, height: 97)
        rect4.isHidden = true
        addChild(rect4)
        
        rect5.zPosition = 5
        rect5.position = CGPoint(x: frame.size.width * 0.93, y: frame.size.height * 0.9335)
        rect5.size = CGSize(width: 97, height: 97)
        rect5.isHidden = true
        addChild(rect5)
        
        rect6.zPosition = 5
        rect6.position = CGPoint(x: frame.size.width * 0.093, y: frame.size.height * 0.95)
        rect6.size = CGSize(width: 200, height: 200)
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
        
        gameTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(addObstacleCar), userInfo: nil, repeats: true)
        gameTimer2 = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(addPuddle), userInfo: nil, repeats: true)
        gameTimer4 = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(addPowerUps), userInfo: nil, repeats: true)
        gameTimer7 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runPowerUpCombinations), userInfo: nil, repeats: true)
        gameTimer8 = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateArrayImage), userInfo: nil, repeats: true)

}
    
    @objc func addObstacleCar() {

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
        
        obstacleCar.physicsBody?.velocity = CGVector(dx: 0, dy: velocityDy)
        
        if obstacleCar.position.y < -frame.size.height/4 {
            obstacleCar.removeFromParent()
        }
    }
    
    @objc func addPuddle() {
        
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
        
        puddle.physicsBody?.velocity = CGVector(dx: 0, dy: velocityDy)
        
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
        }
    }
    
    func fireBomb() {
        let bombNode = SKSpriteNode(imageNamed: "bomb")
        bombNode.position = biker.position
        bombNode.zPosition = 4
        let move = SKAction.move(to: bombBox.position, duration: 1)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([move, remove])
        
        if bombBoxOn == true {
        bombBoxOn = false
        addChild(bombNode)
        bombNode.run(sequence)
        }
    }
    
    func bikerCar() {

        if bCar == true {
            currentHealth -= (10 - (resistUpNumber*bikerResistance))
            bCar = false
            print("biker-car")
        } else{
            return
        }
    }
    
    func bikerPuddle() {

        if bPuddle == true {
            if activeArray.count >= 1 {
                activeArray.removeLast()
                bPuddle = false
            } else {
                return
            }
        }
    }
    
    func bikerSpeed() {
        
        if bSpeed == true {
            if activeArray.count < 5 {
                activeArray.append("Speed")
                speedEmitter()
                pickUpNumber += 1
                velocityDy -= 5
                bSpeed = false
            } else{
                return
            }
        }
        
    }
    
    func bikerResist() {
        
        if bResist == true {
            if activeArray.count < 5 {
                activeArray.append("Resist")
                resistEmitter()
                pickUpNumber += 1
                velocityDy -= 5
                bResist = false
            } else{
                return
            }
        }
    }
    
    func bikerHeal() {
        
        if bHeal == true {
            if activeArray.count < 5 {
                activeArray.append("Heal")
                healEmitter()
                pickUpNumber += 1
                velocityDy -= 5
                bHeal = false
            } else{
                return
            }
        }
    }
    
    func emitterPositions() {
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
    }
    
    func rectanglePositions() {
        rect1.position.x = biker.position.x + frame.size.width * 0.066
        rect2.position.x = biker.position.x + frame.size.width * 0.156
        rect3.position.x = biker.position.x + frame.size.width * 0.246
        rect4.position.x = biker.position.x + frame.size.width * 0.336
        rect5.position.x = biker.position.x + frame.size.width * 0.426
        rect6.position.x = biker.position.x - frame.size.width * 0.407
    }
    
    func bombBoxPositions() {

        if moveRight == true {
            movementValue += 5
            bombBox.position.x = (biker.position.x + CGFloat(movementValue))
        }
        
        if moveLeft == true {
            movementValue -= 5
            bombBox.position.x = (biker.position.x + CGFloat(movementValue))
        }
        
        if bombBox.position.x > (biker.position.x + frame.size.width/2) {
            moveRight = false
            moveLeft = true
        }
        
        if bombBox.position.x < (biker.position.x - frame.size.width/2) {
            moveLeft = false
            moveRight = true
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
            bCar = true
            
        case bikerCategory | puddleCategory:

            contact.bodyB.node?.removeFromParent()
            bPuddle = true
            
        case bikerCategory | speedCategory:
 
            contact.bodyB.node?.removeFromParent()
            bSpeed = true
            
        case bikerCategory | resistCategory:
 
            contact.bodyB.node?.removeFromParent()
            bResist = true
            
        case bikerCategory | healCategory:

            contact.bodyB.node?.removeFromParent()
            bHeal = true
            
        case shieldCategory | carCategory:
            
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            
            shieldOn = false
            
        case borderCategory | bikerCategory:
            
            return
            
        case bombCategory | carCategory:
            
            if bombFire == true {
                let delay = SKAction.wait(forDuration: 1)
                let remove = SKAction.run {contact.bodyB.node?.removeFromParent()}
                let sequence = SKAction.sequence([delay, remove])

                self.run(sequence)
            }
            
        default:
            return
            
        }
    }
    
    func bikerBuild() {
        
        biker.position = CGPoint(x: frame.size.width/2, y: frame.size.height/6)
        biker.zPosition = 10
        biker.physicsBody = SKPhysicsBody(texture: biker.texture!, size: biker.texture!.size())
        biker.physicsBody?.affectedByGravity = false
        biker.physicsBody?.isDynamic = true
        biker.name = "BIKER"
        biker.physicsBody?.categoryBitMask = bikerCategory
        biker.physicsBody?.contactTestBitMask = carCategory | borderCategory
        biker.physicsBody?.collisionBitMask = borderCategory
        biker.physicsBody?.usesPreciseCollisionDetection = true
        //new
        //biker.lightingBitMask = 1
        //biker.shadowCastBitMask = 0
        //biker.shadowedBitMask = 1
        //old
    }
    
    func moveBikerRight(){

        biker.physicsBody?.velocity = CGVector(dx: 300 + (speedUpNumber*speedUpBiker), dy: 0)
        let bikerRight = SKTexture(imageNamed: "biker right")
        
        let rotateRight = SKAction.rotate(toAngle: -0.3, duration: 0.5)
        let steerRight = SKAction.animate(with: [bikerRight], timePerFrame: 0.1)
        
        biker.run(rotateRight)
        biker.run(steerRight)
        
    }
    
    func moveBikerLeft(){
        biker.physicsBody?.velocity = CGVector(dx: -300 - (speedUpNumber*speedUpBiker), dy: 0)
        let bikerLeft = SKTexture(imageNamed: "biker left")
        
        let rotateLeft = SKAction.rotate(toAngle: 0.3, duration: 0.5)
        let steerLeft = SKAction.animate(with: [bikerLeft], timePerFrame: 0.1)
        
        biker.run(rotateLeft)
        biker.run(steerLeft)
        
    }
    
    func bikerStop(){
        
        biker.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        
        let bikerCenter = SKTexture(imageNamed: "biker clean")
        
        let rotateCenter = SKAction.rotate(toAngle: 0, duration: 0.4)
        let steerCenter = SKAction.animate(with: [bikerCenter], timePerFrame: 0.1)
        
        biker.run(rotateCenter)
        biker.run(steerCenter)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches{
            let location = t.location(in: self)
            
            if button.contains(location){
                if bombBoxOn == true {
                bombFire = true
                fireBomb()
                bombBoxOn = false
                
                }
                
            } else if location.x < biker.position.x{
                moveBikerLeft()
                
            } else {
                moveBikerRight()
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        bikerStop()
    }
    
    override func update(_ currentTime: TimeInterval){
        healthLabel.position.x = biker.position.x + frame.size.width*(9/50)
        healthBar.position.x = biker.position.x + frame.size.width/4
        shield.position.x = biker.position.x
        button.position.x = biker.position.x
        cameraNode.position.x = biker.position.x
        starfieldNode.position.x = biker.position.x
        starfieldNode2.position.x = biker.position.x
        emitterPositions()
        rectanglePositions()
        bombBoxPositions()
        healthAnimation()
        readyArray()
        bikerCar()
        bikerPuddle()
        bikerSpeed()
        bikerResist()
        bikerHeal()
        return
    }

}
