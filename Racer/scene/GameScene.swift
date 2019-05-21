//
//  GameScene.swift
//  Racer
//  Authors: John Sudduth & Keegan Tountas
//  Copyright 2018, 2019
//

import SpriteKit
import GameplayKit
import UIKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let player = SKSpriteNode(imageNamed: "ship")
    let shield = SKShapeNode(circleOfRadius: 200)
    let zapper = SKShapeNode(circleOfRadius: 400)
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
    
    let obHitBoxa = SKSpriteNode(texture: SKTexture(imageNamed: "ob hitbox"))
    let obHitBoxb = SKSpriteNode(texture: SKTexture(imageNamed: "ob hitbox"))
    let obHitBoxc = SKSpriteNode(texture: SKTexture(imageNamed: "ob hitbox"))
    
    //implement
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
    
    var threeSecondOn = true
    var fiveSecondOn = true
    var threeSecondRunTime:Float = 0
    var fiveSecondRunTime:Float = 0
    
    var shieldOn:Bool = false
    var zapperOn:Bool = false
    var buttonOn:Bool = false
    var bombBoxOn:Bool = false
    var bombFire:Bool = false
    var teleportOn:Bool = false
    var phaseOutOn:Bool = false
    var invulnerableOn:Bool = false
    var vortexActive:Bool = false
    var roarOn:Bool = false
    var speedBoostOn:Bool = false
    var missileCall:Bool = false
    var sendShips:Bool = true
    var shipsAlive:CGFloat = 0

    var bPuddle:Bool = false
    var bHeal:Bool = false
    var bResist:Bool = false
    var bSpeed:Bool = false
    var contactSmall:Bool = false
    var contactMedium:Bool = false
    var contactLarge:Bool = false
    var contactOval:Bool = false
    var smallShipContact:Bool = false
    
    var touchDetected:Bool = false
    var moveRight:Bool = true
    var moveLeft:Bool = false
    var touchLocationX:CGFloat = 0
    var touchLocationY:CGFloat = 0
    
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
    let roarParticles = SKEmitterNode(fileNamed: "RoarEmitter.sks")
    let starfieldNode = SKSpriteNode(imageNamed: "starfield")
    let starfieldNode2 = SKSpriteNode(imageNamed: "starfield")
    let bombBox = SKSpriteNode(imageNamed: "reticule")
    
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
    var threeSecondTimer:Timer!
    var fiveSecondTimer:Timer!
    var gameOver = false

    
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
    
    @objc func doubleTapDetected() {
        
        let bikerX:CGFloat = CGFloat(touchLocationX - player.position.x)
        let bikerY:CGFloat = CGFloat(touchLocationY - player.position.y)
        let teleportX = Double((CGFloat(300)*(bikerX))/sqrt(pow((bikerX), 2) + pow((bikerY), 2)))
        let teleportY = Double((CGFloat(300)*(bikerY))/sqrt(pow((bikerX), 2) + pow((bikerY), 2)))
        
        player.position.x = (player.position.x + CGFloat(teleportX))
        player.position.y = (player.position.y + CGFloat(teleportY))
        
        print("teleport")
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
        
        powerUpSpeed.physicsBody?.categoryBitMask = Category.speedCategory
        powerUpSpeed.physicsBody?.contactTestBitMask = Category.bikerCategory
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
        
        powerUpResist.physicsBody?.categoryBitMask = Category.resistCategory
        powerUpResist.physicsBody?.contactTestBitMask = Category.bikerCategory
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
        
        powerUpHeal.physicsBody?.categoryBitMask = Category.healCategory
        powerUpHeal.physicsBody?.contactTestBitMask = Category.bikerCategory
        powerUpHeal.physicsBody?.collisionBitMask = 0
        
        self.addChild(powerUpHeal)
        
        powerUpHeal.physicsBody?.velocity = CGVector(dx: 0, dy: velocityDy)
        
        if powerUpHeal.position.y < -frame.size.height/4 {
            powerUpHeal.removeFromParent()
        }
    }
    
    func healEmitter() {
        
        addChild(healParticles!)
        addChild(healParticlesRight!)
        self.run(SKAction.wait(forDuration:1.5)){
            self.healParticles?.removeFromParent()
            self.healParticlesRight?.removeFromParent()
        }
    }
    
    func resistEmitter() {
        
        addChild(resistParticles!)
        addChild(resistParticlesRight!)
        self.run(SKAction.wait(forDuration:1.5)){
            self.resistParticles?.removeFromParent()
            self.resistParticlesRight?.removeFromParent()
        }
    }
    
    func speedEmitter() {
        
        addChild(speedParticles!)
        addChild(speedParticlesRight!)
        self.run(SKAction.wait(forDuration:1.5)){
            self.speedParticles?.removeFromParent()
            self.speedParticlesRight?.removeFromParent()
        }
    }
    
    func roarEmitter() {

        addChild(roarParticles!)
        self.run(SKAction.wait(forDuration:1)){
            self.roarParticles?.removeFromParent()
        }
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
    
    @objc func powerUpCombinations() {
        if currentHealth < 500 {
            currentHealth += (bikerHealing*healUpNumber)
        }
        
        makeShips()
        
        let abilityArray = [speedUpNumber,resistUpNumber,healUpNumber]
        
        switch abilityArray {
        
        case [5,0,0]:
            teleportOn = true
            rect6.isHidden = false
        case [0,5,0]:
            makeShield()
            rect6.texture = SKTexture(imageNamed: "resist icon")
            rect6.isHidden = false
        case [0,0,5]:
            rect6.isHidden = false
        case [4,1,0]:
            phaseOutOn = true
            rect6.isHidden = false
        case [4,0,1]:
            rect6.isHidden = false
        case [1,0,4]:
            //add line for zap, hide circle
            makeZapper()
            rect6.isHidden = false
        case [0,1,4]:
            rect6.isHidden = false
        case [0,4,1]:
            invulnerableOn = true
            rect6.isHidden = false
        case [1,4,0]:
            roarOn = true
            rect6.isHidden = false
        case [3,2,0]:
            //vortex ability
            vortexActive = true
            let vortex = Vortex(playerSprite: player)
            vortex.execute()
            rect6.isHidden = false
        case [3,0,2]:
            player.size = CGSize(width: 200, height: 200)
            rect6.isHidden = false
        case [2,3,0]:
            //ships
            sendShips = true
            makeShips()
            rect6.isHidden = false
        case [0,3,2]:
            speedBoostOn = true
            rect6.isHidden = false
        case [0,2,3]:
            rect6.isHidden = false
        case [2,0,3]:
            rect6.isHidden = false
        case [3,1,1]:
            missileCall = true
            rect6.isHidden = false
        case [1,1,3]:
            rect6.isHidden = false
        case [1,3,1]:
            rect6.isHidden = false
        case [2,2,1]:
            
            if fiveSecondOn == true {
                bombBoxOn = true
                bombBox.isHidden = false
            }
            rect6.isHidden = false
        case [2,1,2]:
            rect6.isHidden = false
        case [1,2,2]:
            rect6.isHidden = false
        default:
            rect6.isHidden = true
            bombBox.isHidden = true
            player.size = CGSize(width: 300, height: 300)
            bombBoxOn = false
            phaseOutOn = false
            bombFire = false
            teleportOn = false
            invulnerableOn = false
            roarOn = false
            zapperOn = false
            speedBoostOn = false
            missileCall = false
        }
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
        
        addChild(player)
        bikerBuild()
        
        addChild(button)
        makeButton()
        
        //starField()
        
        bombBox.physicsBody = SKPhysicsBody(texture: bombBox.texture!, size: bombBox.size)
        bombBox.position = CGPoint(x: frame.size.width/2, y: frame.size.height*(5.5/10))
        bombBox.physicsBody?.categoryBitMask = Category.bombCategory
        bombBox.physicsBody?.contactTestBitMask = Category.smallDamageCategory | Category.mediumDamageCategory | Category.largeDamageCategory
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
        
        gameTimer2 = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(addPuddle), userInfo: nil, repeats: true)
        gameTimer3 = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(callObstacleArray), userInfo: nil, repeats: true)
        gameTimer4 = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(addPowerUps), userInfo: nil, repeats: true)
        gameTimer7 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(powerUpCombinations), userInfo: nil, repeats: true)
        gameTimer8 = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateArrayImage), userInfo: nil, repeats: true)
        threeSecondTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(threeSecondPress), userInfo: nil, repeats: true)
        fiveSecondTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(fiveSecondPress), userInfo: nil, repeats: true)
}
    
    @objc func threeSecondPress() {
        threeSecondRunTime += 1
        if threeSecondRunTime >= 3{
        threeSecondOn = true
        }
    }
    
    @objc func fiveSecondPress() {
        fiveSecondRunTime += 1
        if fiveSecondRunTime >= 5{
            fiveSecondOn = true
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
        
        puddle.physicsBody?.categoryBitMask = Category.puddleCategory
        puddle.physicsBody?.contactTestBitMask = Category.bikerCategory
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
        
        ob1Node.position = CGPoint(x: CGFloat(player.position.x) - frame.size.width*(3/8), y: CGFloat(player.position.y) + frame.size.height*0.4)
        ob2Node.position = CGPoint(x: CGFloat(player.position.x) - frame.size.width*0.187, y: CGFloat(player.position.y) + frame.size.height*0.4)
        ob3Node.position = CGPoint(x: CGFloat(player.position.x), y: CGFloat(player.position.y) + frame.size.height*0.4)
        ob4Node.position = CGPoint(x: CGFloat(player.position.x) + frame.size.width*0.187, y: CGFloat(player.position.y) + frame.size.height*0.4)
        ob5Node.position = CGPoint(x: CGFloat(player.position.x) + frame.size.width*(3/8), y: CGFloat(player.position.y) + frame.size.height*0.4)
        
        ob1Node.physicsBody = SKPhysicsBody(circleOfRadius: 100)
        ob2Node.physicsBody = SKPhysicsBody(circleOfRadius: 100)
        ob3Node.physicsBody = SKPhysicsBody(circleOfRadius: 100)
        ob4Node.physicsBody = SKPhysicsBody(circleOfRadius: 100)
        ob5Node.physicsBody = SKPhysicsBody(circleOfRadius: 100)
        
        ob1Node.physicsBody?.categoryBitMask = Category.smallDamageCategory
        ob2Node.physicsBody?.categoryBitMask = Category.smallDamageCategory
        ob3Node.physicsBody?.categoryBitMask = Category.smallDamageCategory
        ob4Node.physicsBody?.categoryBitMask = Category.smallDamageCategory
        ob5Node.physicsBody?.categoryBitMask = Category.smallDamageCategory
        
        ob1Node.physicsBody?.collisionBitMask = Category.shieldCategory
        ob2Node.physicsBody?.collisionBitMask = Category.shieldCategory
        ob3Node.physicsBody?.collisionBitMask = Category.shieldCategory
        ob4Node.physicsBody?.collisionBitMask = Category.shieldCategory
        ob5Node.physicsBody?.collisionBitMask = Category.shieldCategory
        
        ob1Node.physicsBody?.contactTestBitMask = Category.bikerCategory
        ob2Node.physicsBody?.contactTestBitMask = Category.bikerCategory
        ob3Node.physicsBody?.contactTestBitMask = Category.bikerCategory
        ob4Node.physicsBody?.contactTestBitMask = Category.bikerCategory
        ob5Node.physicsBody?.contactTestBitMask = Category.bikerCategory
        
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
        
        let oval1a = SKSpriteNode(texture: SKTexture(imageNamed: "fade 1"))
        let oval2a = SKSpriteNode(texture: SKTexture(imageNamed: "fade 2"))
        let oval3a = SKSpriteNode(texture: SKTexture(imageNamed: "fade 3"))
        let flicker1a = SKSpriteNode(texture: SKTexture(imageNamed: "flicker 1"))
        let flicker2a = SKSpriteNode(texture: SKTexture(imageNamed: "flicker 2"))
        
        let oval1b = SKSpriteNode(texture: SKTexture(imageNamed: "fade 1"))
        let oval2b = SKSpriteNode(texture: SKTexture(imageNamed: "fade 2"))
        let oval3b = SKSpriteNode(texture: SKTexture(imageNamed: "fade 3"))
        let flicker1b = SKSpriteNode(texture: SKTexture(imageNamed: "flicker 1"))
        let flicker2b = SKSpriteNode(texture: SKTexture(imageNamed: "flicker 2"))
        
        let oval1c = SKSpriteNode(texture: SKTexture(imageNamed: "fade 1"))
        let oval2c = SKSpriteNode(texture: SKTexture(imageNamed: "fade 2"))
        let oval3c = SKSpriteNode(texture: SKTexture(imageNamed: "fade 3"))
        let flicker1c = SKSpriteNode(texture: SKTexture(imageNamed: "flicker 1"))
        let flicker2c = SKSpriteNode(texture: SKTexture(imageNamed: "flicker 2"))
        
        let randomRotate:Int = Int.random(in: -50...50)
        let randomRotate2:Int = Int.random(in: -50...50)
        let randomRotate3:Int = Int.random(in: -50...50)
        
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
        //add hitbox physics bodies
        oval1a.position = CGPoint(x: Int(player.position.x) + randomX, y: Int(player.position.y) + randomY)
        oval1a.zPosition = -6
        oval1a.alpha = 0
        oval2a.position = oval1a.position
        oval2a.zPosition = -5
        oval2a.alpha = 0
        oval3a.position = oval1a.position
        oval3a.zPosition = -4
        oval3a.alpha = 0
        obHitBoxa.position = oval1a.position
        obHitBoxa.zPosition = -7
        obHitBoxa.alpha = 0
        obHitBoxa.physicsBody = SKPhysicsBody(texture: obHitBoxa.texture!, size: obHitBoxa.texture!.size())
        obHitBoxa.physicsBody?.categoryBitMask = Category.obOvalCategory
        obHitBoxa.physicsBody?.collisionBitMask = 0
        obHitBoxa.physicsBody?.contactTestBitMask = Category.bikerCategory
        flicker1a.position = oval1a.position
        flicker1a.zPosition = -3
        flicker1a.alpha = 1
        flicker2a.position = oval1a.position
        flicker2a.zPosition = -2
        flicker2a.alpha = 1
        
        oval1b.position = CGPoint(x: Int(player.position.x) + randomX2, y: Int(player.position.y) + randomY2)
        oval1b.zPosition = -6
        oval1b.alpha = 0
        oval2b.position = oval1b.position
        oval2b.zPosition = -5
        oval2b.alpha = 0
        oval3b.position = oval1b.position
        oval3b.zPosition = -4
        oval3b.alpha = 0
        obHitBoxb.position = oval1b.position
        obHitBoxb.zPosition = -7
        obHitBoxb.alpha = 0
        obHitBoxb.physicsBody = SKPhysicsBody(texture: obHitBoxb.texture!, size: obHitBoxb.texture!.size())
        obHitBoxb.physicsBody?.categoryBitMask = Category.obOvalCategory
        obHitBoxb.physicsBody?.collisionBitMask = 0
        obHitBoxb.physicsBody?.contactTestBitMask = Category.bikerCategory
        flicker1b.position = oval1b.position
        flicker1b.zPosition = -3
        flicker1b.alpha = 1
        flicker2b.position = oval1b.position
        flicker2b.zPosition = -2
        flicker2b.alpha = 1
        
        oval1c.position = CGPoint(x: Int(player.position.x) + randomX3, y: Int(player.position.y) + randomY3)
        oval1c.zPosition = -6
        oval1c.alpha = 0
        oval2c.position = oval1c.position
        oval2c.zPosition = -5
        oval2c.alpha = 0
        oval3c.position = oval1c.position
        oval3c.zPosition = -4
        oval3c.alpha = 0
        obHitBoxc.position = oval1c.position
        obHitBoxc.zPosition = -7
        obHitBoxc.alpha = 0
        obHitBoxc.physicsBody = SKPhysicsBody(texture: obHitBoxc.texture!, size: obHitBoxc.texture!.size())
        obHitBoxc.physicsBody?.categoryBitMask = Category.obOvalCategory
        obHitBoxc.physicsBody?.collisionBitMask = 0
        obHitBoxc.physicsBody?.contactTestBitMask = Category.bikerCategory
        flicker1c.position = oval1c.position
        flicker1c.zPosition = -3
        flicker1c.alpha = 1
        flicker2c.position = oval1c.position
        flicker2c.zPosition = -2
        flicker2c.alpha = 1
        
        let rotate = SKAction.rotate(byAngle: CGFloat(randomRotate), duration: 0)
        let rotate2 = SKAction.rotate(byAngle: CGFloat(randomRotate2), duration: 0)
        let rotate3 = SKAction.rotate(byAngle: CGFloat(randomRotate3), duration: 0)
        let fadeIn = SKAction.fadeIn(withDuration: 0.66)
        let spawnDelay = SKAction.wait(forDuration: 2)
        let wait1 = SKAction.wait(forDuration: 0.66)
        let wait2 = SKAction.wait(forDuration: 1.32)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([rotate,fadeIn,spawnDelay,remove])
        let sequence2 = SKAction.sequence([rotate2,fadeIn,spawnDelay,remove])
        let sequence3 = SKAction.sequence([rotate3,fadeIn,spawnDelay,remove])
        
        addChild(oval1a)
        addChild(oval1b)
        addChild(oval1c)
        
        oval1a.run(sequence)
        oval1b.run(sequence2)
        oval1c.run(sequence3)
        
        self.run(SKAction.wait(forDuration: 0.66)) {
            
            self.addChild(oval2a)
            let rotate4 = SKAction.rotate(byAngle:CGFloat(randomRotate), duration:0)
            let removeA = SKAction.removeFromParent()
            let sequenceA = SKAction.sequence([rotate4,fadeIn,wait2,removeA])
            
            oval2a.run(sequenceA)
            
            self.addChild(oval2b)
            let rotate5 = SKAction.rotate(byAngle:CGFloat(randomRotate2), duration:0)
            let sequenceB = SKAction.sequence([rotate5,fadeIn,wait2,removeA])
            
            oval2b.run(sequenceB)
            
            self.addChild(oval2c)
            let rotate6 = SKAction.rotate(byAngle:CGFloat(randomRotate3), duration:0)
            let sequenceC = SKAction.sequence([rotate6,fadeIn,wait2,removeA])
            
            oval2c.run(sequenceC)
            
        }
        
        self.run(SKAction.wait(forDuration: 1.32)) {
            
            self.addChild(oval3a)
            let rotate4 = SKAction.rotate(byAngle:CGFloat(randomRotate), duration:0)
            let removeA = SKAction.removeFromParent()
            let sequenceA = SKAction.sequence([rotate4,fadeIn,wait1,removeA])
            
            oval3a.run(sequenceA)
            
            self.addChild(oval3b)
            let rotate5 = SKAction.rotate(byAngle:CGFloat(randomRotate2), duration:0)
            let sequenceB = SKAction.sequence([rotate5,fadeIn,wait1,removeA])
            
            oval3b.run(sequenceB)
            
            self.addChild(oval3c)
            let rotate6 = SKAction.rotate(byAngle:CGFloat(randomRotate3), duration:0)
            let sequenceC = SKAction.sequence([rotate6,fadeIn,wait1,removeA])
            
            oval3c.run(sequenceC)
            
        }
        
        self.run(SKAction.wait(forDuration: 1.98)) {
            
            self.addChild(self.obHitBoxa)
            let rotate4 = SKAction.rotate(byAngle:CGFloat(randomRotate), duration:0)
            let spawnDelayA = SKAction.wait(forDuration: 2)
            let removeA = SKAction.removeFromParent()
            let sequenceA = SKAction.sequence([rotate4,spawnDelayA,removeA])
            
            self.obHitBoxa.run(sequenceA)
            
            self.addChild(self.obHitBoxb)
            let rotate5 = SKAction.rotate(byAngle:CGFloat(randomRotate2), duration:0)
            let sequenceB = SKAction.sequence([rotate5,spawnDelayA,removeA])
            
            self.obHitBoxb.run(sequenceB)
            
            self.addChild(self.obHitBoxc)
            let rotate6 = SKAction.rotate(byAngle:CGFloat(randomRotate3), duration:0)
            let sequenceC = SKAction.sequence([rotate6,spawnDelayA,removeA])
            
            self.obHitBoxc.run(sequenceC)
            
        }
        
        self.run(SKAction.wait(forDuration: 1.98)) {
            
            self.addChild(flicker1a)
            let rotate4 = SKAction.rotate(byAngle:CGFloat(randomRotate), duration:0)
            let spawnDelayA = SKAction.wait(forDuration: 2)
            let removeA = SKAction.removeFromParent()
            let sequenceA = SKAction.sequence([rotate4,spawnDelayA,removeA])
            
            flicker1a.run(sequenceA)
            
            self.addChild(flicker1b)
            let rotate5 = SKAction.rotate(byAngle:CGFloat(randomRotate2), duration:0)
            let sequenceB = SKAction.sequence([rotate5,spawnDelayA,removeA])
            
            flicker1b.run(sequenceB)
            
            self.addChild(flicker1c)
            let rotate6 = SKAction.rotate(byAngle:CGFloat(randomRotate3), duration:0)
            let sequenceC = SKAction.sequence([rotate6,spawnDelayA,removeA])
            
            flicker1c.run(sequenceC)
            
        }
        
        self.run(SKAction.wait(forDuration: 1.98)) {
            
            self.addChild(flicker2a)
            let rotate4 = SKAction.rotate(byAngle:CGFloat(randomRotate), duration:0)
            let removeA = SKAction.removeFromParent()
            let fadeInFast = SKAction.fadeIn(withDuration: 0.33)
            let fadeOutFast = SKAction.fadeOut(withDuration: 0.33)
            let sequenceA = SKAction.sequence([rotate4,fadeOutFast,fadeInFast,fadeOutFast,fadeInFast,fadeOutFast,fadeInFast,removeA])
            
            flicker2a.run(sequenceA)
            
            self.addChild(flicker2b)
            let rotate5 = SKAction.rotate(byAngle:CGFloat(randomRotate2), duration:0)
            let sequenceB = SKAction.sequence([rotate5,fadeOutFast,fadeInFast,fadeOutFast,fadeInFast,fadeOutFast,fadeInFast,removeA])
            
            flicker2b.run(sequenceB)
            
            self.addChild(flicker2c)
            let rotate6 = SKAction.rotate(byAngle:CGFloat(randomRotate3), duration:0)
            let sequenceC = SKAction.sequence([rotate6,fadeOutFast,fadeInFast,fadeOutFast,fadeInFast,fadeOutFast,fadeInFast,removeA])
            
            flicker2c.run(sequenceC)
            
        }
        
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
        
        obRock1.physicsBody?.categoryBitMask = Category.mediumDamageCategory
        obRock1.physicsBody?.collisionBitMask = Category.shieldCategory
        obRock1.physicsBody?.contactTestBitMask = Category.bikerCategory
        
        obRock2.physicsBody?.categoryBitMask = Category.mediumDamageCategory
        obRock2.physicsBody?.collisionBitMask = Category.shieldCategory
        obRock2.physicsBody?.contactTestBitMask = Category.bikerCategory
        
        obRock3.physicsBody?.categoryBitMask = Category.mediumDamageCategory
        obRock3.physicsBody?.collisionBitMask = Category.shieldCategory
        obRock3.physicsBody?.contactTestBitMask = Category.bikerCategory
        
        obRock1.position = CGPoint(x: (CGFloat(player.position.x) + spawnXArray[randomSpawnX]), y: (CGFloat(player.position.y)) + CGFloat(randomY))
        obRock2.position = CGPoint(x: (CGFloat(player.position.x) + spawnXArray2[randomSpawnX2]), y: (CGFloat(player.position.y)) + CGFloat(randomY2))
        obRock3.position = CGPoint(x: (CGFloat(player.position.x) + spawnXArray3[randomSpawnX3]), y: (CGFloat(player.position.y)) + CGFloat(randomY3))
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
        
        let ship1pos = CGPoint(x: player.position.x + CGFloat(randomX1), y: player.position.y + CGFloat(randomY1))
        let ship2pos = CGPoint(x: player.position.x + CGFloat(randomX2), y: player.position.y + CGFloat(randomY2))
        let ship3pos = CGPoint(x: player.position.x + CGFloat(randomX3), y: player.position.y + CGFloat(randomY3))
        let ship4pos = CGPoint(x: player.position.x + CGFloat(randomX4), y: player.position.y + CGFloat(randomY4))
        
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
        let wait2 = SKAction.wait(forDuration: 0.5)
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
        let fireAgain = SKAction.repeat(sequenceFire, count: 8)
        
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
        
        let randomSpawn1 = CGPoint(x: player.position.x + CGFloat(randomX1), y: player.position.y + CGFloat(randomY1))
        let randomSpawn2 = CGPoint(x: player.position.x + CGFloat(randomX2), y: player.position.y + CGFloat(randomY2))
        let randomSpawn3 = CGPoint(x: player.position.x + CGFloat(randomX3), y: player.position.y + CGFloat(randomY3))
        let randomSpawn4 = CGPoint(x: player.position.x + CGFloat(randomX4), y: player.position.y + CGFloat(randomY4))
        
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
        obLanded1.physicsBody?.categoryBitMask = Category.largeDamageCategory
        obLanded1.physicsBody?.collisionBitMask = 0
        obLanded1.physicsBody?.contactTestBitMask = Category.bikerCategory
        
        
        obLanded2.fillColor = .red
        obLanded2.position = obShadow2.position
        obLanded2.physicsBody = SKPhysicsBody(circleOfRadius: 150)
        obLanded2.physicsBody?.categoryBitMask = Category.largeDamageCategory
        obLanded2.physicsBody?.collisionBitMask = 0
        obLanded2.physicsBody?.contactTestBitMask = Category.bikerCategory
        
        obLanded3.fillColor = .red
        obLanded3.position = obShadow3.position
        obLanded3.physicsBody = SKPhysicsBody(circleOfRadius: 150)
        obLanded3.physicsBody?.categoryBitMask = Category.largeDamageCategory
        obLanded3.physicsBody?.collisionBitMask = 0
        obLanded3.physicsBody?.contactTestBitMask = Category.bikerCategory
        
        obLanded4.fillColor = .red
        obLanded4.position = obShadow4.position
        obLanded4.physicsBody = SKPhysicsBody(circleOfRadius: 150)
        obLanded4.physicsBody?.categoryBitMask = Category.largeDamageCategory
        obLanded4.physicsBody?.collisionBitMask = 0
        obLanded4.physicsBody?.contactTestBitMask = Category.bikerCategory
        
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
        //let callNumber = 1
        
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
        addChild(bullet1)
        let bulletX:Float = Float(bullet1.position.x - player.position.x)
        let bulletY:Float = Float(bullet1.position.y - player.position.y)
        let speedX = Double((Float(500)*(bulletX))/sqrt(pow((bulletX), 2) + pow((bulletY), 2)))
        let speedY = Double((Float(500)*(bulletY))/sqrt(pow((bulletX), 2) + pow((bulletY), 2)))
        
        bullet1.physicsBody?.velocity = CGVector(dx: -speedX, dy: -speedY)
        
        if bullet1.position.x < -frame.size.width || bullet1.position.x > 2.5*frame.size.width {
            bullet1.removeFromParent()
        }
        
        bullet2.position = obShip2.position
        bullet2.fillColor = .white
        bullet2.physicsBody = SKPhysicsBody(circleOfRadius: 25)
        addChild(bullet2)
        let bulletX2:Float = Float(bullet2.position.x - player.position.x)
        let bulletY2:Float = Float(bullet2.position.y - player.position.y)
        let speedX2 = Double((Float(500)*(bulletX2))/sqrt(pow((bulletX2), 2) + pow((bulletY2), 2)))
        let speedY2 = Double((Float(500)*(bulletY2))/sqrt(pow((bulletX2), 2) + pow((bulletY2), 2)))
        
        bullet2.physicsBody?.velocity = CGVector(dx: -speedX2, dy: -speedY2)
        
        if bullet2.position.x < -frame.size.width || bullet2.position.x > 2.5*frame.size.width {
            bullet2.removeFromParent()
        }
        
        bullet3.position = obShip3.position
        bullet3.fillColor = .white
        bullet3.physicsBody = SKPhysicsBody(circleOfRadius: 25)
        addChild(bullet3)
        let bulletX3:Float = Float(bullet3.position.x - player.position.x)
        let bulletY3:Float = Float(bullet3.position.y - player.position.y)
        let speedX3 = Double((Float(500)*(bulletX3))/sqrt(pow((bulletX3), 2) + pow((bulletY3), 2)))
        let speedY3 = Double((Float(500)*(bulletY3))/sqrt(pow((bulletX3), 2) + pow((bulletY3), 2)))
        
        bullet3.physicsBody?.velocity = CGVector(dx: -speedX3, dy: -speedY3)
        
        if bullet3.position.x < -frame.size.width || bullet3.position.x > 2.5*frame.size.width {
            bullet3.removeFromParent()
        }
        
        bullet4.position = obShip4.position
        bullet4.fillColor = .white
        bullet4.physicsBody = SKPhysicsBody(circleOfRadius: 25)
        addChild(bullet4)
        let bulletX4:Float = Float(bullet4.position.x - player.position.x)
        let bulletY4:Float = Float(bullet4.position.y - player.position.y)
        let speedX4 = Double((Float(500)*(bulletX4))/sqrt(pow((bulletX4), 2) + pow((bulletY4), 2)))
        let speedY4 = Double((Float(500)*(bulletY4))/sqrt(pow((bulletX4), 2) + pow((bulletY4), 2)))
        
        bullet4.physicsBody?.velocity = CGVector(dx: -speedX4, dy: -speedY4)
        
        if bullet4.position.x < -frame.size.width || bullet4.position.x > 2.5*frame.size.width {
            bullet4.removeFromParent()
        }
        
        self.run(SKAction.wait(forDuration:9)){
            bullet1.removeFromParent()
            bullet2.removeFromParent()
            bullet3.removeFromParent()
            bullet4.removeFromParent()
        }
        
        bullet1.physicsBody?.categoryBitMask = Category.smallDamageCategory
        bullet1.physicsBody?.collisionBitMask = Category.shieldCategory
        bullet1.physicsBody?.contactTestBitMask = Category.bikerCategory
        
        bullet2.physicsBody?.categoryBitMask = Category.smallDamageCategory
        bullet2.physicsBody?.collisionBitMask = Category.shieldCategory
        bullet2.physicsBody?.contactTestBitMask = Category.bikerCategory
        
        bullet3.physicsBody?.categoryBitMask = Category.smallDamageCategory
        bullet3.physicsBody?.collisionBitMask = Category.shieldCategory
        bullet3.physicsBody?.contactTestBitMask = Category.bikerCategory
        
        bullet4.physicsBody?.categoryBitMask = Category.smallDamageCategory
        bullet4.physicsBody?.collisionBitMask = Category.shieldCategory
        bullet4.physicsBody?.contactTestBitMask = Category.bikerCategory
        
    }
    
    func makeShield() {
        
        shield.strokeColor = .blue
        shield.lineWidth = 2
        shield.glowWidth = 2
        shield.zPosition = 6
        shield.position = player.position
        shield.physicsBody = SKPhysicsBody(circleOfRadius: 200)
        shield.physicsBody?.isDynamic = true
        shield.physicsBody?.categoryBitMask = Category.shieldCategory
        shield.physicsBody?.contactTestBitMask = Category.smallDamageCategory | Category.mediumDamageCategory | Category.largeDamageCategory
        shield.physicsBody?.collisionBitMask = 0
        
        if fiveSecondOn == true && shieldOn == false{
        shieldOn = true
        addChild(shield)
        }
        
    }
    
    func makeShips() {
        
        let shipOne = SKSpriteNode(imageNamed: "ship")
        let shipTwo = SKSpriteNode(imageNamed: "ship")
        
        shipOne.position = CGPoint(x: player.position.x + 200, y: player.position.y)
        shipOne.size = CGSize(width: 150, height: 150)
        shipOne.zPosition = 3
        shipOne.physicsBody = SKPhysicsBody(texture: shipOne.texture!, size: shipOne.texture!.size())
        shipOne.physicsBody?.categoryBitMask = Category.smallShipCategory
        shipOne.physicsBody?.collisionBitMask = 0
        shipOne.physicsBody?.contactTestBitMask = Category.smallDamageCategory | Category.mediumDamageCategory | Category.largeDamageCategory
        
        shipTwo.position = CGPoint(x: player.position.x - 200, y: player.position.y)
        shipTwo.size = CGSize(width: 150, height: 150)
        shipTwo.zPosition = 3
        shipTwo.physicsBody = SKPhysicsBody(texture: shipTwo.texture!, size: shipTwo.texture!.size())
        shipTwo.physicsBody?.categoryBitMask = Category.smallShipCategory
        shipTwo.physicsBody?.collisionBitMask = 0
        shipTwo.physicsBody?.contactTestBitMask = Category.smallDamageCategory | Category.mediumDamageCategory | Category.largeDamageCategory
        
        shipOne.physicsBody?.velocity = CGVector(dx: 200, dy: 200)
        shipTwo.physicsBody?.velocity = CGVector(dx: -200, dy: 200)
        
        //let xDifference = abs(shipOne.position.x)
        //print(xDifference)
        
        if abs(shipOne.position.x - player.position.x) > 300 {
            shipOne.physicsBody?.applyImpulse(CGVector(dx: -(shipOne.position.x - player.position.x), dy: 0))
        }
        
        if abs(shipTwo.position.x - player.position.x) > 300 {
            shipTwo.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            //shipTwo.physicsBody?.applyImpulse(CGVector(dx: -(shipTwo.position.x - player.position.x), dy: 0))
        }
        
        if abs(shipOne.position.y - player.position.y) > 400 {
            shipOne.physicsBody?.applyImpulse(CGVector(dx: 0, dy: -(shipOne.position.y - player.position.y)))
        }
        
        if abs(shipTwo.position.y - player.position.y) > 400 {
            shipTwo.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            //shipTwo.physicsBody?.applyImpulse(CGVector(dx: 0, dy: -(shipTwo.position.y - player.position.y)))
        }
        
        if shipsAlive == 0 && fiveSecondOn == true && sendShips == true {
            fiveSecondOn = false
            fiveSecondRunTime = 0
            addChild(shipOne)
            addChild(shipTwo)
            shipsAlive = 2
            print("ships")
        }
        
        
    }
    
    func makeZapper() {
        
        zapper.strokeColor = .blue
        zapper.lineWidth = 2
        
        zapper.zPosition = 6
        zapper.position = player.position
        zapper.physicsBody = SKPhysicsBody(circleOfRadius: 400)
        zapper.physicsBody?.isDynamic = true
        zapper.physicsBody?.categoryBitMask = Category.zapperCategory
        zapper.physicsBody?.contactTestBitMask = Category.smallDamageCategory | Category.mediumDamageCategory | Category.largeDamageCategory
        zapper.physicsBody?.collisionBitMask = 0
        
        if fiveSecondOn == true && zapperOn == false{
            zapperOn = true
            addChild(zapper)
            
        }
        
    }
    
    func vortexField() {
        
        let roarVortex = SKFieldNode.radialGravityField()
        roarVortex.strength = -300.0
        roarVortex.position = player.position
        roarVortex.region = SKRegion(size: CGSize(width: 600, height: 600))
        roarVortex.categoryBitMask = Category.roarVortexCategory
        roarVortex.isEnabled = true
        
        addChild(roarVortex)
        
        self.run(SKAction.wait(forDuration: 1)) {
            roarVortex.removeFromParent()
        }
        
    }
    
    func missileCallActive() {
        
        let callDelaySprite = SKSpriteNode(imageNamed: "reticule")
        callDelaySprite.size = CGSize(width: 10, height: 10)
        callDelaySprite.position = CGPoint(x: player.position.x, y: player.position.y + 550)
        let growCall = SKAction.resize(toWidth: 600, height: 600, duration: 1.5)
        addChild(callDelaySprite)
        callDelaySprite.run(growCall)
        
        let landedSprite = SKShapeNode(circleOfRadius: 300)
        landedSprite.fillColor = .red
        landedSprite.position = callDelaySprite.position
        landedSprite.physicsBody?.isDynamic = false
        landedSprite.physicsBody = SKPhysicsBody.init(circleOfRadius: 300)
        landedSprite.physicsBody?.categoryBitMask = Category.missileCallCategory
        landedSprite.physicsBody?.collisionBitMask = 0
        landedSprite.physicsBody?.contactTestBitMask = Category.smallDamageCategory | Category.mediumDamageCategory | Category.largeDamageCategory
        
        self.run(SKAction.wait(forDuration: 1.5)) {
            self.addChild(landedSprite)
            callDelaySprite.removeFromParent()
        }
        self.run(SKAction.wait(forDuration: 2)) {
            landedSprite.removeFromParent()
        }
        
    }
    
    func fireBomb() {
        let bombNode = SKSpriteNode(imageNamed: "bomb")
        bombNode.position = player.position
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
        
        player.physicsBody?.categoryBitMask = 0
        player.alpha = 0.5
        
        
        self.run(SKAction.wait(forDuration: 1)) {
            self.player.physicsBody?.categoryBitMask = Category.bikerCategory
            self.player.alpha = 1.0
        }
    }
    
    func bikerContact() {
        
        if contactSmall == true {
            currentHealth -= (10 - (resistUpNumber*bikerResistance))
            contactSmall = false
        }
        
        if contactMedium == true{
            currentHealth -= (25 - (resistUpNumber*bikerResistance))
            contactMedium = false
        }
        
        
        if contactLarge == true{
            currentHealth -= (50 - (resistUpNumber*bikerResistance))
            contactLarge = false
        }
        
        if contactOval == true{
            currentHealth -= (10 - (resistUpNumber*bikerResistance))
            contactOval = false
            
            self.run(SKAction.wait(forDuration: 0.33)) {
                self.obHitBoxa.physicsBody?.categoryBitMask = Category.obOvalCategory
                self.obHitBoxb.physicsBody?.categoryBitMask = Category.obOvalCategory
                self.obHitBoxc.physicsBody?.categoryBitMask = Category.obOvalCategory
            }
        }
        
        if smallShipContact == true{
            shipsAlive -= 1
            smallShipContact = false
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
    
    func invulnerable() {
        let invulnerable = SKAction.run {self.player.physicsBody?.collisionBitMask = 1; self.player.physicsBody?.categoryBitMask = 0}
        
        self.run(invulnerable)
        
        self.run(SKAction.wait(forDuration: 2)) {
            
            self.player.physicsBody?.collisionBitMask = 0
            self.player.physicsBody?.categoryBitMask = Category.bikerCategory
            
        }
    }
    
    func abilityPositions() {
        shield.position = player.position
        zapper.position = player.position
        roarParticles?.position = player.position
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
        cameraNode.position = player.position
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

        bombBox.position.y = player.position.y + frame.size.height/4
        
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
            
        case Category.bikerCategory | Category.puddleCategory:

            contact.bodyB.node?.removeFromParent()
            bPuddle = true
            
        case Category.bikerCategory | Category.speedCategory:
 
            contact.bodyB.node?.removeFromParent()
            bSpeed = true
            
        case Category.bikerCategory | Category.resistCategory:
 
            contact.bodyB.node?.removeFromParent()
            bResist = true
            
        case Category.bikerCategory | Category.healCategory:

            contact.bodyB.node?.removeFromParent()
            bHeal = true
            
        case Category.shieldCategory | Category.smallDamageCategory:
            
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            
            fiveSecondRunTime = 0
            shieldOn = false
            
        case Category.zapperCategory | Category.smallDamageCategory:
            
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            
            fiveSecondRunTime = 0
            zapperOn = false
            
        case Category.missileCallCategory | Category.smallDamageCategory:
            
            contact.bodyB.node?.removeFromParent()
            
        case Category.missileCallCategory | Category.mediumDamageCategory:
            
            contact.bodyB.node?.removeFromParent()
            
        case Category.missileCallCategory | Category.largeDamageCategory:
            
            contact.bodyB.node?.removeFromParent()
            
        case Category.smallShipCategory | Category.smallDamageCategory:
            
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            smallShipContact = true
            
        case Category.smallShipCategory | Category.mediumDamageCategory:
            
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            smallShipContact = true
            
        case Category.smallShipCategory | Category.largeDamageCategory:
            
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            smallShipContact = true
            
        case Category.bikerCategory | Category.smallDamageCategory:
            
            contact.bodyB.node?.removeFromParent()
            contactSmall = true
            
        case Category.bikerCategory | Category.mediumDamageCategory:
            
            contact.bodyB.node?.removeFromParent()
            contactMedium = true
            
        case Category.bikerCategory | Category.largeDamageCategory:
            
            contact.bodyB.node?.removeFromParent()
            contactLarge = true
            
        case Category.bikerCategory | Category.obOvalCategory:
            
            contactOval = true
            obHitBoxa.physicsBody?.categoryBitMask = 0
            obHitBoxb.physicsBody?.categoryBitMask = 0
            obHitBoxc.physicsBody?.categoryBitMask = 0
            
        case Category.zapperCategory | Category.smallDamageCategory:
            
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            
            fiveSecondRunTime = 0
            shieldOn = false
            
            if bombFire == true {
                let delay = SKAction.wait(forDuration: 1)
                let remove = SKAction.run {contact.bodyB.node?.removeFromParent()}
                let sequence = SKAction.sequence([delay, remove])

                self.run(sequence)
                bombFire = false
            }
            
        default:
            return
            
        }
    }
    
    func bikerBuild() {
        player.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        player.zPosition = 10
        player.size = CGSize(width: 300, height: 300)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.texture!.size())
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.isDynamic = true
        player.name = "player"
        player.physicsBody?.categoryBitMask = Category.bikerCategory
        player.physicsBody?.contactTestBitMask = Category.smallDamageCategory | Category.mediumDamageCategory | Category.largeDamageCategory
        player.physicsBody?.collisionBitMask = 0
        player.physicsBody?.fieldBitMask = 0
        player.physicsBody?.usesPreciseCollisionDetection = true
        player.lightingBitMask = 1
        player.shadowCastBitMask = 0
        player.shadowedBitMask = 1
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches{
            let location = t.location(in: self)
            
            let bikerX:Float = Float(location.x - player.position.x)
            let bikerY:Float = Float(location.y - player.position.y)
            let speedX = Double((Float(300 + (speedUpBiker*speedUpNumber))*(bikerX))/sqrt(pow((bikerX), 2) + pow((bikerY), 2)))
            let speedY = Double((Float(300 + (speedUpBiker*speedUpNumber))*(bikerY))/sqrt(pow((bikerX), 2) + pow((bikerY), 2)))
            
            touchLocationX = location.x
            touchLocationY = location.y
            
            player.physicsBody?.velocity = CGVector(dx: speedX, dy: speedY)
            
            let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapDetected))
            doubleTap.numberOfTapsRequired = 2
            
            if teleportOn == true{
            view?.addGestureRecognizer(doubleTap)
            }
            
            touchDetected = true
            if touchDetected == false{
                player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            }
            
            if button.contains(location) {
                
                if fiveSecondOn == true && roarOn == true{
                    fiveSecondRunTime = 0
                    fiveSecondOn = false
                    vortexField()
                    roarEmitter()
                    print("roar fire")
                }
                
                if fiveSecondOn == true && missileCall == true{
                    fiveSecondRunTime = 0
                    fiveSecondOn = false
                    missileCallActive()
                    print("missile")
                }
                
                if bombBoxOn == true && fiveSecondOn == true {
                bombFire = true
                fireBomb()
                fiveSecondRunTime = 0
                fiveSecondOn = false
                bombBoxOn = false
                }
                if threeSecondOn == true{
                    if phaseOutOn == true{
                            phaseOut()
                            threeSecondRunTime = 0
                            threeSecondOn = false
                    
                }
            }
                if fiveSecondOn == true && invulnerableOn == true {
                        invulnerable()
                        fiveSecondRunTime = 0
                        fiveSecondOn = false
                    
                }
                
                if fiveSecondOn == true && speedBoostOn == true {
                    
                    player.physicsBody?.velocity = CGVector(dx: speedX + 600, dy: speedY + 600)
                    fiveSecondRunTime = 0
                    fiveSecondOn = false
                    //might work?
                    self.run(SKAction.wait(forDuration: 2)) {
                        
                        self.player.physicsBody?.velocity = CGVector(dx: speedX, dy: speedY)
                        
                    }
                }
        }
            
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches {
            let location = t.location(in: self)
            let bikerX:Float = Float(location.x - player.position.x)
            let bikerY:Float = Float(location.y - player.position.y)
            let speedX = Double((Float(300 + (speedUpBiker*speedUpNumber))*(bikerX))/sqrt(pow((bikerX), 2) + pow((bikerY), 2)))
            let speedY = Double((Float(300 + (speedUpBiker*speedUpNumber))*(bikerY))/sqrt(pow((bikerX), 2) + pow((bikerY), 2)))
            
            touchDetected = true
            if touchDetected == false{
                player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            }
            
            player.physicsBody?.velocity = CGVector(dx: speedX, dy: speedY)
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchDetected = false
        player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchDetected = false
        player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
    }

    override func update(_ currentTime: TimeInterval){
        healthLabel.position.x = cameraNode.position.x + frame.size.width*(9/50)
        healthLabel.position.y = cameraNode.position.y + (frame.size.height * 0.962 - frame.size.height/2)
        healthBar.position.x = cameraNode.position.x + frame.size.width/4
        healthBar.position.y = cameraNode.position.y + (frame.size.height * 0.97 - frame.size.height/2)
        button.position.x = cameraNode.position.x
        button.position.y = cameraNode.position.y - frame.size.height*(24/50)
        starfieldNode.position.x = cameraNode.position.x
        starfieldNode2.position.x = cameraNode.position.x
        cameraPositions()
        emitterPositions()
        abilityPositions()
        rectanglePositions()
        bombBoxPositions()
        healthAnimation()
        bikerContact()
        readyArray()
        return
    }

}
