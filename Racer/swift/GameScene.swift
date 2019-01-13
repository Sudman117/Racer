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

enum Direction: Int{
    case None = 0
    case Left = 1
    case Right = 2
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let brick1 = SKSpriteNode(imageNamed: "brick2png")
    let brick2 = SKSpriteNode(imageNamed: "brick2png")
    let biker = SKSpriteNode(imageNamed: "biker clean")
    let motionManger = CMMotionManager()
    
    var currentHealth:Int = 450
    var healthBar = SKSpriteNode()
    var contactOnce = 0
    var xAcceleration:CGFloat = 0
    var initialBikerPosition: CGPoint!
    var obstacles = ["car"]
    var carTimer:Timer!
    var puddleTimer:Timer!
    var healthTimer:Timer!
    
    override func didMove(to view: SKView) {
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
        
        healthBar.size = CGSize(width: currentHealth, height: 40)
        healthBar.position = CGPoint(x: frame.size.width * 0.75, y: frame.size.height * 0.95)
        healthBar.zPosition = 5
        healthBar.color = .red
        healthBar.name = "healthBar"
        addChild(healthBar)
    
        //Biker definition
        biker.position = CGPoint(x: frame.size.width/2, y: frame.size.height/6)
        biker.physicsBody = SKPhysicsBody(rectangleOf: biker.size)
        biker.physicsBody?.categoryBitMask = Categories.biker
        biker.physicsBody?.collisionBitMask = Categories.left_boder | Categories.right_border
        biker.physicsBody?.affectedByGravity = false
        biker.physicsBody?.isDynamic = true
        addChild(biker)
        
        setup()
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        showRoadStrip()
        
    }
    
    @objc func setup() {
        Timer.scheduledTimer(timeInterval: TimeInterval(0.25), target: self, selector: #selector(GameScene.createRoadStrip), userInfo: nil, repeats: true)
        
        carTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(addObstacleCar), userInfo: nil, repeats: true)
        puddleTimer = Timer.scheduledTimer(timeInterval: 8, target: self, selector: #selector(addPuddle), userInfo: nil, repeats: true)
        healthTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(healthProgress), userInfo: nil, repeats: true)
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
}
