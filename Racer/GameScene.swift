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
    
    let obOval1Fade = SKShapeNode(ellipseOf: CGSize(width: 1800, height: 200))
    let obOval1Real = SKShapeNode(ellipseOf: CGSize(width: 1800, height: 180))
    let obOval2Fade = SKShapeNode(ellipseOf: CGSize(width: 1800, height: 200))
    let obOval2Real = SKShapeNode(ellipseOf: CGSize(width: 1800, height: 180))
    let obOval3Fade = SKShapeNode(ellipseOf: CGSize(width: 1800, height: 200))
    let obOval3Real = SKShapeNode(ellipseOf: CGSize(width: 1800, height: 180))
    
    let obShip1 = SKShapeNode(rectOf: CGSize(width: 250, height: 250))
    let obShip2 = SKShapeNode(rectOf: CGSize(width: 250, height: 250))
    let obShip3 = SKShapeNode(rectOf: CGSize(width: 250, height: 250))
    let obShip4 = SKShapeNode(rectOf: CGSize(width: 250, height: 250))
    
    var difficulty2:Bool = false
    var difficulty3:Bool = false
    var difficulty4:Bool = false
    var difficulty5:Bool = false
    
    var currentHealth:Int = 500
    var movementValue:Float = 0
    var velocityDy:Double = -100
    var velocityBiker:Double = 300

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
    var phaseOutOn:Bool = false
    
    var bCar:Bool = false
    var bPuddle:Bool = false
    var bHeal:Bool = false
    var bResist:Bool = false
    var bSpeed:Bool = false
    var bObNode:Bool = false
    var bObOval:Bool = false
    var bObRock:Bool = false
    var bObBullet:Bool = false
    var bObLanded:Bool = false
    
    var moveRight:Bool = true
    var moveLeft:Bool = false
    
    var healthBar = SKSpriteNode()
    var healthLabel = SKLabelNode()
    var cameraNode = SKCameraNode()
    var rectBoundary = SKShapeNode()
    let speedParticlesRight = SKEmitterNode(fileNamed: "Speed Right.sks")
    let speedParticles = SKEmitterNode(fileNamed: "Speed.sks")
    let resistParticlesRight = SKEmitterNode(fileNamed: "Resist Right.sks")
    let resistParticles = SKEmitterNode(fileNamed: "Resist.sks")
    let healParticlesRight = SKEmitterNode(fileNamed: "Heal Right.sks")
    let healParticles = SKEmitterNode(fileNamed: "Heal.sks")
    let starfieldNode = SKSpriteNode(imageNamed: "starfield")
    let starfieldNode2 = SKSpriteNode(imageNamed: "starfield")
    var bombBox = SKSpriteNode(imageNamed: "reticule")
    
    var rect1 = SKSpriteNode()
    var rect2 = SKSpriteNode()
    var rect3 = SKSpriteNode()
    var rect4 = SKSpriteNode()
    var rect5 = SKSpriteNode()
    var rect6 = SKSpriteNode()
    
    var gameTimer2:Timer!
    var gameTimer3:Timer!
    var gameTimer4:Timer!
    var gameTimer7:Timer!
    var gameTimer8:Timer!
    var gameOver = false
    
    let bikerCategory:UInt32 = 1 << 1
    let carCategory:UInt32 = 1 << 2
    let boundaryCategory:UInt32 = 1 << 3
    let puddleCategory:UInt32 = 1 << 4
    let speedCategory:UInt32 = 1 << 5
    let resistCategory:UInt32 = 1 << 6
    let healCategory:UInt32 = 1 << 7
    let shieldCategory:UInt32 = 1 << 8
    let bombCategory:UInt32 = 1 << 9
    let obNodeCategory:UInt32 = 1 << 10
    let obOvalCategory:UInt32 = 1 << 11
    let obRockCategory:UInt32 = 1 << 12
    let obBulletCategory:UInt32 = 1 << 13
    let obLandedCategory:UInt32 = 1 << 14
    
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
        //does not work :p
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
        
        if phaseOutOn == false {
            let delay = SKAction.wait(forDuration: 3)
            let on = SKAction.run {self.phaseOutOn = true}
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
            //var bikercategory, alpha value
            if phaseOutOn == false {
                let delay = SKAction.wait(forDuration: 3)
                let on = SKAction.run {self.teleportOn = true}
                let sequence = SKAction.sequence([delay,on])
                self.run(sequence)
            }
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
        
        if pickUpNumber >= 5 {
            difficulty2 = true
        } else if pickUpNumber >= 10 {
            difficulty2 = false
            difficulty3 = true
        } else if pickUpNumber >= 15 {
            difficulty2 = false
            difficulty3 = false
            difficulty4 = true
        } else if pickUpNumber >= 20 {
            difficulty2 = false
            difficulty3 = false
            difficulty4 = false
            difficulty5 = true
        }
        
        
        //let lightSource = SKLightNode()
        //lightSource.categoryBitMask = 1
        //lightSource.falloff = 0
        //lightSource.ambientColor = SKColor(displayP3Red: 0.3, green: 0.3, blue: 0.3, alpha: 0.8)
        //lightSource.lightColor = SKColor(displayP3Red: 0.8, green: 0.8, blue: 0.8, alpha: 0.8)
        //lightSource.shadowColor = SKColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.8)
        //lightSource.position = CGPoint(x: frame.size.width/2, y: frame.size.height*0.2)
        //addChild(lightSource)

        
        camera = cameraNode
        cameraNode.position.x = frame.size.width/2
        cameraNode.position.y = frame.size.height/2
        addChild(cameraNode)
        
        let boundaryRect = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        rectBoundary = SKShapeNode(rect: boundaryRect)
        rectBoundary.physicsBody = SKPhysicsBody(edgeLoopFrom: boundaryRect)
        rectBoundary.strokeColor = .yellow
        rectBoundary.lineWidth = 10
        rectBoundary.physicsBody?.categoryBitMask = boundaryCategory
        rectBoundary.physicsBody?.contactTestBitMask = bikerCategory
        rectBoundary.physicsBody?.collisionBitMask = bikerCategory
        rectBoundary.physicsBody?.isDynamic = false
        rectBoundary.physicsBody?.friction = 1
        rectBoundary.physicsBody?.affectedByGravity = false
        rectBoundary.physicsBody?.restitution = 0
        //addChild(rectBoundary)
        
        addChild(biker)
        bikerBuild()
        
        addChild(button)
        makeButton()
        
        //starField()
        
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
        

        gameTimer2 = Timer.scheduledTimer(timeInterval: 1200, target: self, selector: #selector(addPuddle), userInfo: nil, repeats: true)
        gameTimer3 = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(callObstacleArray), userInfo: nil, repeats: true)
        gameTimer4 = Timer.scheduledTimer(timeInterval: 700, target: self, selector: #selector(addPowerUps), userInfo: nil, repeats: true)
        gameTimer7 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runPowerUpCombinations), userInfo: nil, repeats: true)
        gameTimer8 = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateArrayImage), userInfo: nil, repeats: true)
        
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
    
    //new
    
    func obstacle1() {
        
        let ob1Node = SKShapeNode(circleOfRadius: 100)
        let ob2Node = SKShapeNode(circleOfRadius: 100)
        let ob3Node = SKShapeNode(circleOfRadius: 100)
        let ob4Node = SKShapeNode(circleOfRadius: 100)
        let ob5Node = SKShapeNode(circleOfRadius: 100)
        
        ob1Node.position = CGPoint(x: CGFloat(biker.position.x) - frame.size.width*(3/8), y: CGFloat(biker.position.y) + frame.size.height*0.4)
        ob2Node.position = CGPoint(x: CGFloat(biker.position.x) - frame.size.width*0.187, y: CGFloat(biker.position.y) + frame.size.height*0.4)
        ob3Node.position = CGPoint(x: CGFloat(biker.position.x), y: CGFloat(biker.position.y) + frame.size.height*0.4)
        ob4Node.position = CGPoint(x: CGFloat(biker.position.x) + frame.size.width*0.187, y: CGFloat(biker.position.y) + frame.size.height*0.4)
        ob5Node.position = CGPoint(x: CGFloat(biker.position.x) + frame.size.width*(3/8), y: CGFloat(biker.position.y) + frame.size.height*0.4)
        
        ob1Node.physicsBody = SKPhysicsBody(circleOfRadius: 100)
        ob2Node.physicsBody = SKPhysicsBody(circleOfRadius: 100)
        ob3Node.physicsBody = SKPhysicsBody(circleOfRadius: 100)
        ob4Node.physicsBody = SKPhysicsBody(circleOfRadius: 100)
        ob5Node.physicsBody = SKPhysicsBody(circleOfRadius: 100)
        
        ob1Node.physicsBody?.categoryBitMask = obNodeCategory
        ob2Node.physicsBody?.categoryBitMask = obNodeCategory
        ob3Node.physicsBody?.categoryBitMask = obNodeCategory
        ob4Node.physicsBody?.categoryBitMask = obNodeCategory
        ob5Node.physicsBody?.categoryBitMask = obNodeCategory
        
        ob1Node.physicsBody?.collisionBitMask = 0
        ob2Node.physicsBody?.collisionBitMask = 0
        ob3Node.physicsBody?.collisionBitMask = 0
        ob4Node.physicsBody?.collisionBitMask = 0
        ob5Node.physicsBody?.collisionBitMask = 0
        
        ob1Node.physicsBody?.contactTestBitMask = bikerCategory
        ob2Node.physicsBody?.contactTestBitMask = bikerCategory
        ob3Node.physicsBody?.contactTestBitMask = bikerCategory
        ob4Node.physicsBody?.contactTestBitMask = bikerCategory
        ob5Node.physicsBody?.contactTestBitMask = bikerCategory
        
        ob1Node.fillColor = .yellow
        ob2Node.fillColor = .yellow
        ob3Node.fillColor = .yellow
        ob4Node.fillColor = .yellow
        ob5Node.fillColor = .yellow
        
        ob1Node.alpha = 0.0
        ob2Node.alpha = 0.0
        ob3Node.alpha = 0.0
        ob4Node.alpha = 0.0
        ob5Node.alpha = 0.0
        
        addChild(ob1Node)
        addChild(ob2Node)
        addChild(ob3Node)
        addChild(ob4Node)
        addChild(ob5Node)
        
        let fadeIn = SKAction.fadeIn(withDuration: 2)
        
        ob1Node.run(fadeIn)
        ob2Node.run(fadeIn)
        ob3Node.run(fadeIn)
        ob4Node.run(fadeIn)
        ob5Node.run(fadeIn)

        self.run(SKAction.wait(forDuration: 2)) {
            
            let randomNumber1 = Int.random(in: -400...400)
            let randomNumber2 = Int.random(in: -400...400)
            let randomNumber3 = Int.random(in: -400...400)
            let randomNumber4 = Int.random(in: -400...400)
            let randomNumber5 = Int.random(in: -400...400)
            
            ob1Node.physicsBody?.velocity = CGVector(dx: randomNumber1, dy: -400)
            ob2Node.physicsBody?.velocity = CGVector(dx: randomNumber2, dy: -400)
            ob3Node.physicsBody?.velocity = CGVector(dx: randomNumber3, dy: -400)
            ob4Node.physicsBody?.velocity = CGVector(dx: randomNumber4, dy: -400)
            ob5Node.physicsBody?.velocity = CGVector(dx: randomNumber5, dy: -400)
            
            let delay = SKAction.wait(forDuration: 6)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([delay,remove])
            
            ob1Node.run(sequence)
            ob2Node.run(sequence)
            ob3Node.run(sequence)
            ob4Node.run(sequence)
            ob5Node.run(sequence)
            
        }
    
        print("obstacle1")
        
    }
    
    func obstacle2() {

        let randomRotate:Int = Int.random(in: -70...70)
        let randomRotate2:Int = Int.random(in: -70...70)
        let randomRotate3:Int = Int.random(in: -70...70)
        
        var randomY:Int = Int.random(in: -(Int(frame.size.height/2))...(Int(frame.size.height/2)))
        var randomX:Int = Int.random(in: -(Int(frame.size.width/2))...(Int(frame.size.width/2)))
        var randomY2:Int = Int.random(in: -(Int(frame.size.height/2))...(Int(frame.size.height/2)))
        var randomX2:Int = Int.random(in: -(Int(frame.size.width/2))...(Int(frame.size.width/2)))
        var randomY3:Int = Int.random(in: -(Int(frame.size.height/2))...(Int(frame.size.height/2)))
        var randomX3:Int = Int.random(in: -(Int(frame.size.width/2))...(Int(frame.size.width/2)))
        
        if (frame.size.height/2 - CGFloat(randomY)) > frame.size.height/2 && ((frame.size.height/2)-abs(CGFloat(randomY)) < (frame.size.width/2 - abs(CGFloat(randomX)))) {
            randomY = Int(-frame.size.height/2)
        } else if (frame.size.height/2 - CGFloat(randomY)) < frame.size.height/2 && ((frame.size.height/2)-abs(CGFloat(randomY)) < (frame.size.width/2 - abs(CGFloat(randomX)))) {
            randomY = Int(frame.size.height/2)
        }
        
        if (frame.size.height/2 - CGFloat(randomY2)) > frame.size.height/2 && ((frame.size.height/2)-abs(CGFloat(randomY2)) < (frame.size.width/2 - abs(CGFloat(randomX2)))) {
            randomY2 = Int(-frame.size.height/2)
        } else if (frame.size.height/2 - CGFloat(randomY2)) < frame.size.height/2 && ((frame.size.height/2)-abs(CGFloat(randomY2)) < (frame.size.width/2 - abs(CGFloat(randomX2)))) {
            randomY2 = Int(frame.size.height/2)
        }
        
        if (frame.size.height/2 - CGFloat(randomY3)) > frame.size.height/2 && ((frame.size.height/2)-abs(CGFloat(randomY3)) < (frame.size.width/2 - abs(CGFloat(randomX3)))) {
            randomY3 = Int(-frame.size.height/2)
        } else if (frame.size.height/2 - CGFloat(randomY3)) < frame.size.height/2 && ((frame.size.height/2)-abs(CGFloat(randomY3)) < (frame.size.width/2 - abs(CGFloat(randomX3)))) {
            randomY3 = Int(frame.size.height/2)
        }
        
        
        if (frame.size.width/2 - CGFloat(randomX)) > frame.size.width/2 && ((frame.size.width/2)-abs(CGFloat(randomX)) < (frame.size.height/2 - abs(CGFloat(randomY)))) {
            randomX = Int(-frame.size.width/2)
        } else if (frame.size.width/2 - CGFloat(randomX)) < frame.size.width/2 && ((frame.size.width/2)-abs(CGFloat(randomX)) < (frame.size.height/2 - abs(CGFloat(randomY)))) {
            randomX = Int(frame.size.width/2)
        }
        
        if (frame.size.width/2 - CGFloat(randomX2)) > frame.size.width/2 && ((frame.size.width/2)-abs(CGFloat(randomX2)) < (frame.size.height/2 - abs(CGFloat(randomY2)))) {
            randomX2 = Int(-frame.size.width/2)
        } else if (frame.size.width/2 - CGFloat(randomX2)) < frame.size.width/2 && ((frame.size.width/2)-abs(CGFloat(randomX2)) < (frame.size.height/2 - abs(CGFloat(randomY2)))) {
            randomX2 = Int(frame.size.width/2)
        }
        
        if (frame.size.width/2 - CGFloat(randomX3)) > frame.size.width/2 && ((frame.size.width/2)-abs(CGFloat(randomX3)) < (frame.size.height/2 - abs(CGFloat(randomY3)))) {
            randomX3 = Int(-frame.size.width/2)
        } else if (frame.size.width/2 - CGFloat(randomX3)) < frame.size.width/2 && ((frame.size.width/2)-abs(CGFloat(randomX3)) < (frame.size.height/2 - abs(CGFloat(randomY3)))) {
            randomX3 = Int(frame.size.width/2)
        }
        
        obOval1Fade.position = CGPoint(x: Int(biker.position.x) + randomX, y: Int(biker.position.y) + randomY)
        obOval1Fade.zPosition = -2
        obOval1Fade.alpha = 0
        obOval1Fade.fillColor = .red
        
        obOval1Real.position = CGPoint(x: Int(biker.position.x) + randomX, y: Int(biker.position.y) + randomY)
        obOval1Real.fillColor = .white
        obOval1Real.zPosition = -1
        //physicsbody broken get texture
        obOval1Real.physicsBody = SKPhysicsBody()
        obOval1Real.physicsBody?.categoryBitMask = obOvalCategory
        obOval1Real.physicsBody?.collisionBitMask = 0
        obOval1Real.physicsBody?.contactTestBitMask = bikerCategory
        
        obOval2Fade.position = CGPoint(x: Int(biker.position.x) + randomX2, y: Int(biker.position.y) + randomY2)
        obOval2Fade.zPosition = -2
        obOval2Fade.alpha = 0
        obOval2Fade.fillColor = .red
        
        obOval2Real.position = CGPoint(x: Int(biker.position.x) + randomX2, y: Int(biker.position.y) + randomY2)
        obOval2Real.fillColor = .white
        obOval2Real.zPosition = -1
        obOval2Real.physicsBody = SKPhysicsBody()
        obOval2Real.physicsBody?.categoryBitMask = obOvalCategory
        obOval2Real.physicsBody?.collisionBitMask = 0
        obOval2Real.physicsBody?.contactTestBitMask = bikerCategory
        
        obOval3Fade.position = CGPoint(x: Int(biker.position.x) + randomX3, y: Int(biker.position.y) + randomY3)
        obOval3Fade.zPosition = -2
        obOval3Fade.alpha = 0
        obOval3Fade.fillColor = .red
        
        obOval3Real.position = CGPoint(x: Int(biker.position.x) + randomX3, y: Int(biker.position.y) + randomY3)
        obOval3Real.fillColor = .white
        obOval3Real.zPosition = -1
        obOval3Real.physicsBody = SKPhysicsBody()
        obOval3Real.physicsBody?.categoryBitMask = obOvalCategory
        obOval3Real.physicsBody?.collisionBitMask = 0
        obOval3Real.physicsBody?.contactTestBitMask = bikerCategory
        
        let rotate = SKAction.rotate(byAngle: CGFloat(randomRotate), duration: 0)
        let rotate2 = SKAction.rotate(byAngle: CGFloat(randomRotate2), duration: 0)
        let rotate3 = SKAction.rotate(byAngle: CGFloat(randomRotate3), duration: 0)
        let fadeIn = SKAction.fadeIn(withDuration: 2)
        let spawnDelay = SKAction.wait(forDuration: 2)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([rotate,fadeIn,spawnDelay,remove])
        let sequence2 = SKAction.sequence([rotate2,fadeIn,spawnDelay,remove])
        let sequence3 = SKAction.sequence([rotate3,fadeIn,spawnDelay,remove])
        
        self.run(SKAction.wait(forDuration: 2)) {
            self.addChild(self.obOval1Real)
            let rotate4 = SKAction.rotate(byAngle:CGFloat(randomRotate), duration:0)
            let spawnDelayA = SKAction.wait(forDuration: 2)
            let removeA = SKAction.removeFromParent()
            let sequenceA = SKAction.sequence([rotate4,spawnDelayA,removeA])
            
            self.obOval1Real.run(sequenceA)
        }
        
        self.run(SKAction.wait(forDuration: 2)) {
            self.addChild(self.obOval2Real)
            let rotate5 = SKAction.rotate(byAngle:CGFloat(randomRotate2), duration:0)
            let spawnDelayA = SKAction.wait(forDuration: 2)
            let removeA = SKAction.removeFromParent()
            let sequenceA = SKAction.sequence([rotate5,spawnDelayA,removeA])
            
            self.obOval2Real.run(sequenceA)
        }
        
        self.run(SKAction.wait(forDuration: 2)) {
            self.addChild(self.obOval3Real)
            let rotate6 = SKAction.rotate(byAngle:CGFloat(randomRotate3), duration:0)
            let spawnDelayA = SKAction.wait(forDuration: 2)
            let removeA = SKAction.removeFromParent()
            let sequenceA = SKAction.sequence([rotate6,spawnDelayA,removeA])
            
            self.obOval3Real.run(sequenceA)
        }
        
        addChild(obOval1Fade)
        addChild(obOval2Fade)
        addChild(obOval3Fade)
        
        obOval1Fade.run(sequence)
        obOval2Fade.run(sequence2)
        obOval3Fade.run(sequence3)
        
        print("obstacle2")
    
    }
    
    func obstacle3() {
  
        let obRock1 = SKShapeNode(rectOf: CGSize(width: 300, height: 300))
        let obRock2 = SKShapeNode(rectOf: CGSize(width: 300, height: 300))
        let obRock3 = SKShapeNode(rectOf: CGSize(width: 300, height: 300))
        
        let randomY:Int = Int.random(in: -(Int(frame.size.height/2))...(Int(frame.size.height/2)))
        let positivePositionX:CGFloat = CGFloat(frame.size.width)
        let negativePositionX:CGFloat = -CGFloat(frame.size.width)
        let spawnXArray = [positivePositionX,negativePositionX]
        let randomSpawnX:Int = Int.random(in: 0...1)
        
        let randomY2:Int = Int.random(in: -(Int(frame.size.height/2))...(Int(frame.size.height/2)))
        let positivePositionX2:CGFloat = CGFloat(frame.size.width)
        let negativePositionX2:CGFloat = -CGFloat(frame.size.width)
        let spawnXArray2 = [positivePositionX2,negativePositionX2]
        let randomSpawnX2:Int = Int.random(in: 0...1)
        
        let randomY3:Int = Int.random(in: -(Int(frame.size.height/2))...(Int(frame.size.height/2)))
        let positivePositionX3:CGFloat = CGFloat(frame.size.width)
        let negativePositionX3:CGFloat = -CGFloat(frame.size.width)
        let spawnXArray3 = [positivePositionX3,negativePositionX3]
        let randomSpawnX3:Int = Int.random(in: 0...1)
        
        let randomVelocity1:Int = Int.random(in: 800...1200)
        let randomVelocity2:Int = Int.random(in: 800...1200)
        let randomVelocity3:Int = Int.random(in: 800...1200)
        
        obRock1.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 300, height: 300))
        obRock2.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 300, height: 300))
        obRock3.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 300, height: 300))
        
        obRock1.physicsBody?.categoryBitMask = obRockCategory
        obRock1.physicsBody?.collisionBitMask = 0
        obRock1.physicsBody?.contactTestBitMask = bikerCategory
        
        obRock2.physicsBody?.categoryBitMask = obRockCategory
        obRock2.physicsBody?.collisionBitMask = 0
        obRock2.physicsBody?.contactTestBitMask = bikerCategory
        
        obRock3.physicsBody?.categoryBitMask = obRockCategory
        obRock3.physicsBody?.collisionBitMask = 0
        obRock3.physicsBody?.contactTestBitMask = bikerCategory
        
        obRock1.position = CGPoint(x: (CGFloat(biker.position.x) + spawnXArray[randomSpawnX]), y: (CGFloat(biker.position.y)) + CGFloat(randomY))
        obRock2.position = CGPoint(x: (CGFloat(biker.position.x) + spawnXArray2[randomSpawnX2]), y: (CGFloat(biker.position.y)) + CGFloat(randomY2))
        obRock3.position = CGPoint(x: (CGFloat(biker.position.x) + spawnXArray3[randomSpawnX3]), y: (CGFloat(biker.position.y)) + CGFloat(randomY3))
        //fix remove from parent
        obRock1.zPosition = -1
        obRock2.zPosition = -1
        obRock3.zPosition = -1
        
        obRock1.fillColor = .blue
        obRock2.fillColor = .yellow
        obRock3.fillColor = .green
        
        addChild(obRock1)
        addChild(obRock2)
        addChild(obRock3)
        
        if randomSpawnX == 0 {
            
        obRock1.physicsBody?.velocity = CGVector(dx: -randomVelocity1, dy: (3/2)*(randomY))
            
        } else if randomSpawnX == 1 {
            
        obRock1.physicsBody?.velocity = CGVector(dx: randomVelocity1, dy: -(3/2)*(randomY))
            
        }
        
        if randomSpawnX2 == 0 {
            
            obRock2.physicsBody?.velocity = CGVector(dx: -randomVelocity2, dy: (3/2)*(randomY2))
            
        } else if randomSpawnX2 == 1 {
            
            obRock2.physicsBody?.velocity = CGVector(dx: randomVelocity2, dy: -(3/2)*(randomY2))
            
        }
        
        if randomSpawnX3 == 0 {
            
            obRock3.physicsBody?.velocity = CGVector(dx: -randomVelocity3, dy: (3/2)*(randomY3))
            
        } else if randomSpawnX3 == 1 {
            
            obRock3.physicsBody?.velocity = CGVector(dx: randomVelocity3, dy: -(3/2)*(randomY3))
            
        }
        
        self.run(SKAction.wait(forDuration: 5)) {
            
            let remove = SKAction.removeFromParent()

            obRock1.run(remove)
            obRock2.run(remove)
            obRock3.run(remove)
            
        }
        
        print("obstacle3")
        
    }
    
    func obstacle4() {
        
        let randomY1:Int = Int.random(in: -(Int(frame.size.height/2))...(Int(frame.size.height/2)))
        let randomX1:Int = Int.random(in: -(Int(frame.size.width/2))...(Int(frame.size.width/2)))
        let randomY2:Int = Int.random(in: -(Int(frame.size.height/2))...(Int(frame.size.height/2)))
        let randomX2:Int = Int.random(in: -(Int(frame.size.width/2))...(Int(frame.size.width/2)))
        let randomY3:Int = Int.random(in: -(Int(frame.size.height/2))...(Int(frame.size.height/2)))
        let randomX3:Int = Int.random(in: -(Int(frame.size.width/2))...(Int(frame.size.width/2)))
        let randomY4:Int = Int.random(in: -(Int(frame.size.height/2))...(Int(frame.size.height/2)))
        let randomX4:Int = Int.random(in: -(Int(frame.size.width/2))...(Int(frame.size.width/2)))
        
        let ship1pos = CGPoint(x: biker.position.x + CGFloat(randomX1), y: biker.position.y + CGFloat(randomY1))
        let ship2pos = CGPoint(x: biker.position.x + CGFloat(randomX2), y: biker.position.y + CGFloat(randomY2))
        let ship3pos = CGPoint(x: biker.position.x + CGFloat(randomX3), y: biker.position.y + CGFloat(randomY3))
        let ship4pos = CGPoint(x: biker.position.x + CGFloat(randomX4), y: biker.position.y + CGFloat(randomY4))
        
        if randomX1 <= 0 && randomY1 <= 0{
            
            obShip1.position = CGPoint(x: ship1pos.x - frame.size.width, y: ship1pos.y - frame.size.height)
            
        } else if randomX1 <= 0 && randomY1 >= 0{
            
            obShip1.position = CGPoint(x: ship1pos.x - frame.size.width, y: ship1pos.y + frame.size.height)
            
        } else if randomX1 >= 0 && randomY1 <= 0{
            
            obShip1.position = CGPoint(x: ship1pos.x + frame.size.width, y: ship1pos.y - frame.size.height)
            
        } else if randomX1 >= 0 && randomY1 >= 0{
            
            obShip1.position = CGPoint(x: ship1pos.x + frame.size.width, y: ship1pos.y + frame.size.height)
            
        }
        
        if randomX2 <= 0 && randomY2 <= 0{
            
            obShip2.position = CGPoint(x: ship2pos.x - frame.size.width, y: ship2pos.y - frame.size.height)
            
        } else if randomX2 <= 0 && randomY2 >= 0{
            
            obShip2.position = CGPoint(x: ship2pos.x - frame.size.width, y: ship2pos.y + frame.size.height)
            
        } else if randomX2 >= 0 && randomY2 <= 0{
            
            obShip2.position = CGPoint(x: ship2pos.x + frame.size.width, y: ship2pos.y - frame.size.height)
            
        } else if randomX2 >= 0 && randomY2 >= 0{
            
            obShip2.position = CGPoint(x: ship2pos.x + frame.size.width, y: ship2pos.y + frame.size.height)
            
        }
        
        if randomX3 <= 0 && randomY3 <= 0{
            
            obShip3.position = CGPoint(x: ship3pos.x - frame.size.width, y: ship3pos.y - frame.size.height)
            
        } else if randomX3 <= 0 && randomY3 >= 0{
            
            obShip3.position = CGPoint(x: ship3pos.x - frame.size.width, y: ship3pos.y + frame.size.height)
            
        } else if randomX3 >= 0 && randomY3 <= 0{
            
            obShip3.position = CGPoint(x: ship3pos.x + frame.size.width, y: ship3pos.y - frame.size.height)
            
        } else if randomX3 >= 0 && randomY3 >= 0{
            
            obShip3.position = CGPoint(x: ship3pos.x + frame.size.width, y: ship3pos.y + frame.size.height)
            
        }
        
        if randomX4 <= 0 && randomY4 <= 0{
            
            obShip4.position = CGPoint(x: ship4pos.x - frame.size.width, y: ship1pos.y - frame.size.height)
            
        } else if randomX4 <= 0 && randomY4 >= 0{
            
            obShip4.position = CGPoint(x: ship4pos.x - frame.size.width, y: ship4pos.y + frame.size.height)
            
        } else if randomX4 >= 0 && randomY4 <= 0{
            
            obShip4.position = CGPoint(x: ship4pos.x + frame.size.width, y: ship4pos.y - frame.size.height)
            
        } else if randomX4 >= 0 && randomY4 >= 0{
            
            obShip4.position = CGPoint(x: ship4pos.x + frame.size.width, y: ship4pos.y + frame.size.height)
            
        }
        
        obShip1.fillColor = .red
        obShip2.fillColor = .blue
        obShip3.fillColor = .green
        obShip4.fillColor = .white
        
        obShip1.zPosition = -1
        obShip2.zPosition = -1
        obShip3.zPosition = -1
        obShip4.zPosition = -1
        
        addChild(obShip1)
        addChild(obShip2)
        addChild(obShip3)
        addChild(obShip4)
        
        let rotate = SKAction.rotate(byAngle: CGFloat(Double.pi/4), duration: 0)
        let moveShip1 = SKAction.move(to: ship1pos, duration: 2)
        let moveShip2 = SKAction.move(to: ship2pos, duration: 2)
        let moveShip3 = SKAction.move(to: ship3pos, duration: 2)
        let moveShip4 = SKAction.move(to: ship4pos, duration: 2)
        let fireBullets = SKAction.run {self.bulletsFiring()}
        let wait = SKAction.wait(forDuration: 5)
        let wait2 = SKAction.wait(forDuration: 0.3)
        let flyAway1 = SKAction.move(to: CGPoint(x: 3*ship1pos.x, y: 3*ship1pos.y), duration: 2)
        let flyAway2 = SKAction.move(to: CGPoint(x: 3*ship2pos.x, y: 3*ship2pos.y), duration: 2)
        let flyAway3 = SKAction.move(to: CGPoint(x: 3*ship3pos.x, y: 3*ship3pos.y), duration: 2)
        let flyAway4 = SKAction.move(to: CGPoint(x: 3*ship4pos.x, y: 3*ship4pos.y), duration: 2)
        let remove = SKAction.removeFromParent()
        let actionArray1 = [rotate,moveShip1,wait,flyAway1,remove]
        let actionArray2 = [rotate,moveShip2,wait,flyAway2,remove]
        let actionArray3 = [rotate,moveShip3,wait,flyAway3,remove]
        let actionArray4 = [rotate,moveShip4,wait,flyAway4,remove]
        let sequence = SKAction.sequence(actionArray1)
        let sequence2 = SKAction.sequence(actionArray2)
        let sequence3 = SKAction.sequence(actionArray3)
        let sequence4 = SKAction.sequence(actionArray4)
        let sequenceFire = SKAction.sequence([wait2,fireBullets])
        let fireAgain = SKAction.repeat(sequenceFire, count: 12)
        
        obShip1.run(sequence)
        obShip2.run(sequence2)
        obShip3.run(sequence3)
        obShip4.run(sequence4)
        
        self.run(SKAction.wait(forDuration: 2)) {
            
            self.run(fireAgain)
            
        }
        
        print("obstacle4")
        
    }
    
    func obstacle5() {
        
        let obShadow1 = SKSpriteNode(imageNamed: "reticule")
        let obShadow2 = SKSpriteNode(imageNamed: "reticule")
        let obShadow3 = SKSpriteNode(imageNamed: "reticule")
        let obShadow4 = SKSpriteNode(imageNamed: "reticule")
        
        let obLanded1 = SKShapeNode(circleOfRadius: 150)
        let obLanded2 = SKShapeNode(circleOfRadius: 150)
        let obLanded3 = SKShapeNode(circleOfRadius: 150)
        let obLanded4 = SKShapeNode(circleOfRadius: 150)
        
        let randomY1:Int = Int.random(in: -(Int(frame.size.height/2))...(Int(frame.size.height/2)))
        let randomX1:Int = Int.random(in: -(Int(frame.size.width/2))...(Int(frame.size.width/2)))
        let randomY2:Int = Int.random(in: -(Int(frame.size.height/2))...(Int(frame.size.height/2)))
        let randomX2:Int = Int.random(in: -(Int(frame.size.width/2))...(Int(frame.size.width/2)))
        let randomY3:Int = Int.random(in: -(Int(frame.size.height/2))...(Int(frame.size.height/2)))
        let randomX3:Int = Int.random(in: -(Int(frame.size.width/2))...(Int(frame.size.width/2)))
        let randomY4:Int = Int.random(in: -(Int(frame.size.height/2))...(Int(frame.size.height/2)))
        let randomX4:Int = Int.random(in: -(Int(frame.size.width/2))...(Int(frame.size.width/2)))
        
        let randomSpawn1 = CGPoint(x: biker.position.x + CGFloat(randomX1), y: biker.position.y + CGFloat(randomY1))
        let randomSpawn2 = CGPoint(x: biker.position.x + CGFloat(randomX2), y: biker.position.y + CGFloat(randomY2))
        let randomSpawn3 = CGPoint(x: biker.position.x + CGFloat(randomX3), y: biker.position.y + CGFloat(randomY3))
        let randomSpawn4 = CGPoint(x: biker.position.x + CGFloat(randomX4), y: biker.position.y + CGFloat(randomY4))
        
        let randomSpawnTime1 = Int.random(in: 0...4)
        let randomSpawnTime2 = Int.random(in: 0...4)
        let randomSpawnTime3 = Int.random(in: 0...4)
        let randomSpawnTime4 = Int.random(in: 0...4)
        
        obShadow1.position = randomSpawn1
        obShadow1.alpha = 0.1
        
        obShadow2.position = randomSpawn2
        obShadow2.alpha = 0.1
        
        obShadow3.position = randomSpawn3
        obShadow3.alpha = 0.1

        obShadow4.position = randomSpawn4
        obShadow4.alpha = 0.1
    
        obLanded1.fillColor = .red
        obLanded1.position = obShadow1.position
        obLanded1.physicsBody = SKPhysicsBody(circleOfRadius: 150)
        obLanded1.physicsBody?.categoryBitMask = obLandedCategory
        obLanded1.physicsBody?.collisionBitMask = 0
        obLanded1.physicsBody?.contactTestBitMask = bikerCategory
        
        
        obLanded2.fillColor = .red
        obLanded2.position = obShadow2.position
        obLanded2.physicsBody = SKPhysicsBody(circleOfRadius: 150)
        obLanded2.physicsBody?.categoryBitMask = obLandedCategory
        obLanded2.physicsBody?.collisionBitMask = 0
        obLanded2.physicsBody?.contactTestBitMask = bikerCategory
        
        obLanded3.fillColor = .red
        obLanded3.position = obShadow3.position
        obLanded3.physicsBody = SKPhysicsBody(circleOfRadius: 150)
        obLanded3.physicsBody?.categoryBitMask = obLandedCategory
        obLanded3.physicsBody?.collisionBitMask = 0
        obLanded3.physicsBody?.contactTestBitMask = bikerCategory
        
        obLanded4.fillColor = .red
        obLanded4.position = obShadow4.position
        obLanded4.physicsBody = SKPhysicsBody(circleOfRadius: 150)
        obLanded4.physicsBody?.categoryBitMask = obLandedCategory
        obLanded4.physicsBody?.collisionBitMask = 0
        obLanded4.physicsBody?.contactTestBitMask = bikerCategory
        
        self.run(SKAction.wait(forDuration: TimeInterval(randomSpawnTime1))) {
            
            let remove = SKAction.removeFromParent()
            let spinShadow = SKAction.rotate(toAngle: CGFloat(Double.pi*2), duration: 2)
            let fadeIn = SKAction.fadeIn(withDuration: 2)
            let sequence = SKAction.sequence([spinShadow,remove])
            
            self.addChild(obShadow1)
            
            obShadow1.run(fadeIn)
            obShadow1.run(sequence)
            
            self.run(SKAction.wait(forDuration:2)){
                
                let remove = SKAction.removeFromParent()
                let delay = SKAction.wait(forDuration: 0.5)
                let sequence = SKAction.sequence([delay, remove])
                
                self.addChild(obLanded1)
                obLanded1.run(sequence)
                
            }
            
        }
        
        self.run(SKAction.wait(forDuration: TimeInterval(randomSpawnTime2))) {
            
            let remove = SKAction.removeFromParent()
            let spinShadow = SKAction.rotate(toAngle: CGFloat(Double.pi*2), duration: 2)
            let fadeIn = SKAction.fadeIn(withDuration: 2)
            let sequence = SKAction.sequence([spinShadow,remove])
            
            self.addChild(obShadow2)
            
            obShadow2.run(fadeIn)
            obShadow2.run(sequence)
            
            self.run(SKAction.wait(forDuration:2)){
                
                let remove = SKAction.removeFromParent()
                let delay = SKAction.wait(forDuration: 0.5)
                let sequence = SKAction.sequence([delay, remove])
                
                self.addChild(obLanded2)
                obLanded2.run(sequence)
                
            }
            
        }
        
        self.run(SKAction.wait(forDuration: TimeInterval(randomSpawnTime3))) {
            
            let remove = SKAction.removeFromParent()
            let spinShadow = SKAction.rotate(toAngle: CGFloat(Double.pi*2), duration: 2)
            let fadeIn = SKAction.fadeIn(withDuration: 2)
            let sequence = SKAction.sequence([spinShadow,remove])
            
            self.addChild(obShadow3)
            
            obShadow3.run(fadeIn)
            obShadow3.run(sequence)
            
            self.run(SKAction.wait(forDuration:2)){
                
                let remove = SKAction.removeFromParent()
                let delay = SKAction.wait(forDuration: 0.5)
                let sequence = SKAction.sequence([delay, remove])
                
                self.addChild(obLanded3)
                obLanded3.run(sequence)
                
            }
            
        }
        
        self.run(SKAction.wait(forDuration: TimeInterval(randomSpawnTime4))) {
            
            let remove = SKAction.removeFromParent()
            let spinShadow = SKAction.rotate(toAngle: CGFloat(Double.pi*2), duration: 2)
            let fadeIn = SKAction.fadeIn(withDuration: 2)
            let sequence = SKAction.sequence([spinShadow,remove])
            
            self.addChild(obShadow4)
            
            obShadow4.run(fadeIn)
            obShadow4.run(sequence)
            
            self.run(SKAction.wait(forDuration:2)){
                
                let remove = SKAction.removeFromParent()
                let delay = SKAction.wait(forDuration: 0.5)
                let sequence = SKAction.sequence([delay, remove])
                
                self.addChild(obLanded4)
                obLanded4.run(sequence)
                
            }
            
        }

        
        print("obstacle5")
        
    }
    
    @objc func callObstacleArray() {
        let callNumber = arc4random_uniform(5)
        //let callNumber = 4
        
        if callNumber == UInt32(0) {
            obstacle1()
        } else if callNumber == UInt32(1) {
            obstacle2()
        } else if callNumber == UInt32(2) {
            obstacle3()
        } else if callNumber == UInt32(3) {
            obstacle4()
        } else if callNumber == UInt32(4) {
            obstacle5()
        }
        
        print(callNumber)
        return
    }
    //old
    
    func bulletsFiring() {
        
        let bullet1 = SKShapeNode(circleOfRadius: 25)
        let bullet2 = SKShapeNode(circleOfRadius: 25)
        let bullet3 = SKShapeNode(circleOfRadius: 25)
        let bullet4 = SKShapeNode(circleOfRadius: 25)
        
        bullet1.position = obShip1.position
        bullet1.fillColor = .white
        bullet1.physicsBody = SKPhysicsBody(circleOfRadius: 25)
        bullet1.physicsBody?.collisionBitMask = 0
        addChild(bullet1)
        let bulletX:Float = Float(bullet1.position.x - biker.position.x)
        let bulletY:Float = Float(bullet1.position.y - biker.position.y)
        let speedX = Double((Float(500)*(bulletX))/sqrt(pow((bulletX), 2) + pow((bulletY), 2)))
        let speedY = Double((Float(500)*(bulletY))/sqrt(pow((bulletX), 2) + pow((bulletY), 2)))
        
        bullet1.physicsBody?.velocity = CGVector(dx: -speedX, dy: -speedY)
        
        if bullet1.position.x < -frame.size.width || bullet1.position.x > 2.5*frame.size.width {
            bullet1.removeFromParent()
        }
        
        bullet2.position = obShip2.position
        bullet2.fillColor = .white
        bullet2.physicsBody = SKPhysicsBody(circleOfRadius: 25)
        bullet2.physicsBody?.collisionBitMask = 0
        addChild(bullet2)
        let bulletX2:Float = Float(bullet2.position.x - biker.position.x)
        let bulletY2:Float = Float(bullet2.position.y - biker.position.y)
        let speedX2 = Double((Float(500)*(bulletX2))/sqrt(pow((bulletX2), 2) + pow((bulletY2), 2)))
        let speedY2 = Double((Float(500)*(bulletY2))/sqrt(pow((bulletX2), 2) + pow((bulletY2), 2)))
        
        bullet2.physicsBody?.velocity = CGVector(dx: -speedX2, dy: -speedY2)
        
        if bullet2.position.x < -frame.size.width || bullet2.position.x > 2.5*frame.size.width {
            bullet2.removeFromParent()
        }
        
        bullet3.position = obShip3.position
        bullet3.fillColor = .white
        bullet3.physicsBody = SKPhysicsBody(circleOfRadius: 25)
        bullet3.physicsBody?.collisionBitMask = 0
        addChild(bullet3)
        let bulletX3:Float = Float(bullet3.position.x - biker.position.x)
        let bulletY3:Float = Float(bullet3.position.y - biker.position.y)
        let speedX3 = Double((Float(500)*(bulletX3))/sqrt(pow((bulletX3), 2) + pow((bulletY3), 2)))
        let speedY3 = Double((Float(500)*(bulletY3))/sqrt(pow((bulletX3), 2) + pow((bulletY3), 2)))
        
        bullet3.physicsBody?.velocity = CGVector(dx: -speedX3, dy: -speedY3)
        
        if bullet3.position.x < -frame.size.width || bullet3.position.x > 2.5*frame.size.width {
            bullet3.removeFromParent()
        }
        
        bullet4.position = obShip4.position
        bullet4.fillColor = .white
        bullet4.physicsBody = SKPhysicsBody(circleOfRadius: 25)
        bullet4.physicsBody?.collisionBitMask = 0
        addChild(bullet4)
        let bulletX4:Float = Float(bullet4.position.x - biker.position.x)
        let bulletY4:Float = Float(bullet4.position.y - biker.position.y)
        let speedX4 = Double((Float(500)*(bulletX4))/sqrt(pow((bulletX4), 2) + pow((bulletY4), 2)))
        let speedY4 = Double((Float(500)*(bulletY4))/sqrt(pow((bulletX4), 2) + pow((bulletY4), 2)))
        
        bullet4.physicsBody?.velocity = CGVector(dx: -speedX4, dy: -speedY4)
        
        if bullet4.position.x < -frame.size.width || bullet4.position.x > 2.5*frame.size.width {
            bullet4.removeFromParent()
        }
        
        bullet1.physicsBody?.categoryBitMask = obBulletCategory
        bullet1.physicsBody?.collisionBitMask = 0
        bullet1.physicsBody?.contactTestBitMask = bikerCategory
        
        bullet2.physicsBody?.categoryBitMask = obBulletCategory
        bullet2.physicsBody?.collisionBitMask = 0
        bullet2.physicsBody?.contactTestBitMask = bikerCategory
        
        bullet3.physicsBody?.categoryBitMask = obBulletCategory
        bullet3.physicsBody?.collisionBitMask = 0
        bullet3.physicsBody?.contactTestBitMask = bikerCategory
        
        bullet4.physicsBody?.categoryBitMask = obBulletCategory
        bullet4.physicsBody?.collisionBitMask = 0
        bullet4.physicsBody?.contactTestBitMask = bikerCategory
        
    }
    
    func shieldBuild() {
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
    
    func phaseOut() {
        print("phase out on")
    }
    
    func bikerContact() {
        
        if bObNode == true {
            currentHealth -= (10 - (resistUpNumber*bikerResistance))
            bObNode = false
        }
        
        if bObOval == true {
            currentHealth -= (10 - (resistUpNumber*bikerResistance))
            bObNode = false
        }
        
        if bObRock == true{
            currentHealth -= (10 - (resistUpNumber*bikerResistance))
            bObRock = false
        }
        
        if bObBullet == true{
            currentHealth -= (10 - (resistUpNumber*bikerResistance))
            bObBullet = false
        }
        
        if bObLanded == true{
            currentHealth -= (50 - (resistUpNumber*bikerResistance))
            bObLanded = false
        }
        
        
        if bPuddle == true {
            if activeArray.count >= 1 {
                activeArray.removeLast()
                bPuddle = false
            }
        }
        
        if bSpeed == true {
            if activeArray.count < 5 {
                activeArray.append("Speed")
                speedEmitter()
                pickUpNumber += 1
                velocityDy -= 5
                bSpeed = false
            }
        }
        
        if bResist == true {
            if activeArray.count < 5 {
                activeArray.append("Resist")
                resistEmitter()
                pickUpNumber += 1
                velocityDy -= 5
                bResist = false
            }
        }
        
        if bHeal == true {
            if activeArray.count < 5 {
                activeArray.append("Heal")
                healEmitter()
                pickUpNumber += 1
                velocityDy -= 5
                bHeal = false
            }
        }
        
    }
    
    func emitterPositions() {
        speedParticlesRight?.position.x = cameraNode.position.x + frame.size.width/2
        speedParticlesRight?.position.y = cameraNode.position.y
        speedParticles?.position.x = cameraNode.position.x - frame.size.width/2
        speedParticles?.position.y = cameraNode.position.y
        resistParticlesRight?.position.x = cameraNode.position.x + frame.size.width/2
        resistParticlesRight?.position.y = cameraNode.position.y
        resistParticles?.position.x = cameraNode.position.x - frame.size.width/2
        resistParticles?.position.y = cameraNode.position.y
        healParticlesRight?.position.x = cameraNode.position.x + frame.size.width/2
        healParticlesRight?.position.y = cameraNode.position.y
        healParticles?.position.x = cameraNode.position.x - frame.size.width/2
        healParticles?.position.y = cameraNode.position.y
    }
    
    func rectanglePositions() {
        rect1.position.x = cameraNode.position.x + frame.size.width * 0.066
        rect1.position.y = cameraNode.position.y + (frame.size.height * 0.9335 - frame.size.height/2)
        rect2.position.x = cameraNode.position.x + frame.size.width * 0.156
        rect2.position.y = cameraNode.position.y + (frame.size.height * 0.9335 - frame.size.height/2)
        rect3.position.x = cameraNode.position.x + frame.size.width * 0.246
        rect3.position.y = cameraNode.position.y + (frame.size.height * 0.9335 - frame.size.height/2)
        rect4.position.x = cameraNode.position.x + frame.size.width * 0.336
        rect4.position.y = cameraNode.position.y + (frame.size.height * 0.9335 - frame.size.height/2)
        rect5.position.x = cameraNode.position.x + frame.size.width * 0.426
        rect5.position.y = cameraNode.position.y + (frame.size.height * 0.9335 - frame.size.height/2)
        rect6.position.x = cameraNode.position.x - frame.size.width * 0.407
        rect6.position.y = cameraNode.position.y + (frame.size.height * 0.9335 - frame.size.height/2)
    }
    
    func cameraPositions () {
        cameraNode.position = biker.position
        if cameraNode.position.x <= 0 {
            cameraNode.position.x = 0
        } else if cameraNode.position.x >= frame.size.width{
            cameraNode.position.x = frame.size.width
        }
        if cameraNode.position.y <= frame.size.height * (1/3) {
            cameraNode.position.y = frame.size.height * (1/3)
        } else if cameraNode.position.y >= frame.size.height * (2/3) {
            cameraNode.position.y = frame.size.height * (2/3)
        }
        
    }
    
    func bombBoxPositions() {

        if moveRight == true {
            movementValue += 5
            bombBox.position.x = (cameraNode.position.x + CGFloat(movementValue))
        }
        
        if moveLeft == true {
            movementValue -= 5
            bombBox.position.x = (cameraNode.position.x + CGFloat(movementValue))
        }
        
        if bombBox.position.x > (cameraNode.position.x + frame.size.width/2) {
            moveRight = false
            moveLeft = true
        }
        
        if bombBox.position.x < (cameraNode.position.x - frame.size.width/2) {
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
            
        case bikerCategory | obNodeCategory:
            
            contact.bodyB.node?.removeFromParent()
            bObNode = true
            
        case bikerCategory | obOvalCategory:
            
            bObOval = true
            
        case bikerCategory | obRockCategory:
            
            contact.bodyB.node?.removeFromParent()
            bObRock = true
            
        case bikerCategory | obBulletCategory:
            
            contact.bodyB.node?.removeFromParent()
            bObBullet = true
            
        case bikerCategory | obLandedCategory:
            
            contact.bodyB.node?.removeFromParent()
            bObLanded = true
            
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
        
        biker.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        biker.zPosition = 10
        biker.physicsBody = SKPhysicsBody(texture: biker.texture!, size: biker.texture!.size())
        biker.physicsBody?.affectedByGravity = false
        biker.physicsBody?.isDynamic = true
        biker.name = "BIKER"
        biker.physicsBody?.categoryBitMask = bikerCategory
        biker.physicsBody?.contactTestBitMask = carCategory | boundaryCategory
        biker.physicsBody?.collisionBitMask = 0
        biker.physicsBody?.usesPreciseCollisionDetection = true

        //biker.lightingBitMask = 1
        //biker.shadowCastBitMask = 0
        //biker.shadowedBitMask = 1

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches{
            let location = t.location(in: self)
            
            let bikerX:Float = Float(location.x - biker.position.x)
            let bikerY:Float = Float(location.y - biker.position.y)
            let speedX = Double((Float(300 + (speedUpBiker*speedUpNumber))*(bikerX))/sqrt(pow((bikerX), 2) + pow((bikerY), 2)))
            let speedY = Double((Float(300 + (speedUpBiker*speedUpNumber))*(bikerY))/sqrt(pow((bikerX), 2) + pow((bikerY), 2)))
            
            biker.physicsBody?.velocity = CGVector(dx: speedX, dy: speedY)
            
            if button.contains(location){
                if bombBoxOn == true {
                bombFire = true
                fireBomb()
                bombBoxOn = false
                }
                if phaseOutOn == true{
                    phaseOut()
                    phaseOutOn = false
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches {
            let location = t.location(in: self)
            let bikerX:Float = Float(location.x - biker.position.x)
            let bikerY:Float = Float(location.y - biker.position.y)
            let speedX = Double((Float(300 + (speedUpBiker*speedUpNumber))*(bikerX))/sqrt(pow((bikerX), 2) + pow((bikerY), 2)))
            let speedY = Double((Float(300 + (speedUpBiker*speedUpNumber))*(bikerY))/sqrt(pow((bikerX), 2) + pow((bikerY), 2)))
            
            biker.physicsBody?.velocity = CGVector(dx: speedX, dy: speedY)
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        biker.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
    }

    override func update(_ currentTime: TimeInterval){
        healthLabel.position.x = cameraNode.position.x + frame.size.width*(9/50)
        healthLabel.position.y = cameraNode.position.y + (frame.size.height * 0.962 - frame.size.height/2)
        healthBar.position.x = cameraNode.position.x + frame.size.width/4
        healthBar.position.y = cameraNode.position.y + (frame.size.height * 0.97 - frame.size.height/2)
        shield.position = biker.position
        button.position.x = cameraNode.position.x
        button.position.y = cameraNode.position.y - frame.size.height*(24/50)
        starfieldNode.position.x = cameraNode.position.x
        starfieldNode2.position.x = cameraNode.position.x
        cameraPositions()
        emitterPositions()
        rectanglePositions()
        bombBoxPositions()
        healthAnimation()
        bikerContact()
        readyArray()
        return
    }

}
