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
        let rightBorder = SKSpriteNode(color: UIColor.red, size: CGSize(width: 40, height: self.frame.height))
        rightBorder.position = CGPoint(x: frame.midX, y: frame.midY)
        rightBorder.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: rightBorder.frame.width, height: rightBorder.frame.height))
        rightBorder.physicsBody?.restitution = 0.75
        rightBorder.physicsBody?.usesPreciseCollisionDetection = true
        rightBorder.physicsBody?.categoryBitMask = Categories.right_border
        rightBorder.physicsBody?.isDynamic = true
        rightBorder.physicsBody?.friction = 0
        rightBorder.physicsBody?.affectedByGravity = false
        addChild(rightBorder)
        
        //Biker definition
        biker.position = CGPoint(x: frame.size.width/2, y: frame.size.height/6)
        biker.physicsBody = SKPhysicsBody(rectangleOf: biker.size)
        biker.physicsBody?.categoryBitMask = Categories.biker
        biker.physicsBody?.collisionBitMask = Categories.left_boder | Categories.right_border
        biker.physicsBody?.affectedByGravity = false
        addChild(biker)
        
        
        setup()
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        showRoadStrip()
        
    }
    
    @objc func setup() {
        //Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(GameScene.createRoadStrip), userInfo: nil, repeats: true)
        
        //Border definitions//
        
        

//        leftBorder.physicsBody = borderPhysicsBody
//        leftBorder.physicsBody?.restitution = 0.75
//        leftBorder.physicsBody?.usesPreciseCollisionDetection = true
//        leftBorder.physicsBody?.categoryBitMask = Categories.left_boder
//        leftBorder.physicsBody?.isDynamic = false
//        leftBorder.physicsBody?.friction = 0
    }
    
    func showRoadStrip() {
        enumerateChildNodes(withName: "road strip", using: { (roadStrip, stop) in
            let strip = roadStrip as! SKShapeNode
            strip.position.y -= 30
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
}
