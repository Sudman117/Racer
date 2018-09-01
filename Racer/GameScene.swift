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
    
    var xAcceleration:CGFloat = 0
    var initialBikerPosition: CGPoint!
    var obstacles = ["car"]
    var gameTimer:Timer!
    
    
    override func didMove(to view: SKView) {
        
        let boundary = SKSpriteNode()
        boundary.size = self.frame.size
        boundary.physicsBody?.isDynamic = true
        boundary.physicsBody?.friction = 1.0
        
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        addChild(brick1)
        addChild(brick2)
        addChild(biker)
        
        scrollingBackground1()
        scrollingBackground2()
        bikerBuild()
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(addObstacles), userInfo: nil, repeats: true)
        
        motionManger.accelerometerUpdateInterval = 0.2
        motionManger.startAccelerometerUpdates(to: OperationQueue.current!) { (data:CMAccelerometerData?, error:Error?) in
            if let accelerometerData = data {
                let acceleration = accelerometerData.acceleration
                self.xAcceleration = CGFloat(acceleration.x) * 0.75 + self.xAcceleration * 0.25
            }
        }
    }
    
    @objc func addObstacles() {
        obstacles = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: obstacles) as! [String]
        
        let obstacle = SKSpriteNode(imageNamed: obstacles[0])
        
        let randomObstaclePosition = GKRandomDistribution(lowestValue: 0, highestValue: 1080)
        let position = CGFloat(randomObstaclePosition.nextInt())
        
        obstacle.position = CGPoint(x: position, y: self.frame.size.height + self.frame.size.height*0.5)
        
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
        obstacle.physicsBody?.isDynamic = true
        
        obstacle.physicsBody?.categoryBitMask = CollisionBitMask.Obstacle
        obstacle.physicsBody?.collisionBitMask = CollisionBitMask.biker
        
        self.addChild(obstacle)
        
        let animationDuration:TimeInterval = 12
        
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.moveBy(x: 0, y: -frame.size.height * 2.0, duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        
        obstacle.run(SKAction.sequence(actionArray))
    }
    
    var lastUpdateTimeInterval = TimeInterval()
    var lastYieldTimeInterval = TimeInterval()
    
    
    func updateWithTimeSinceLastUpdate (timeSinceLastUpdate:TimeInterval) {
        lastYieldTimeInterval += timeSinceLastUpdate
        if lastYieldTimeInterval > 2 {
            lastYieldTimeInterval = 0
        }
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        var timeSinceLastUpdate = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        
        if timeSinceLastUpdate > 1 {
            timeSinceLastUpdate = 1/60
            lastUpdateTimeInterval = currentTime
        }
        
        updateWithTimeSinceLastUpdate(timeSinceLastUpdate: timeSinceLastUpdate)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "BIKER"{
            print("HIT")
        }
    }
}
