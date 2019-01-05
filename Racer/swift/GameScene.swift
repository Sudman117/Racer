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
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        addChild(biker)
        bikerBuild()
        setup()
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        showRoadStrip()
    }
    
    @objc func setup() {
        Timer.scheduledTimer(timeInterval: TimeInterval(0.1), target: self, selector: #selector(GameScene.createRoadStrip), userInfo: nil, repeats: true)
        
        //Border definitions//
        let leftBorder = SKSpriteNode(fileNamed: "border_left")
        let rightBorder = SKSpriteNode(fileNamed: "border_right")
        
        
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
