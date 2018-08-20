//
//  GameScene.swift
//  Racer
//
//  Created by Keegan Tountas on 7/30/18.
//  Copyright © 2018 Keegan Tountas. All rights reserved.
//

import SpriteKit
import UIKit

enum Direction: Int{
    case None = 0
    case Left = 1
    case Right = 2
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    
    let brick1 = SKSpriteNode(imageNamed: "brick2png")
    let brick2 = SKSpriteNode(imageNamed: "brick2png")
    let biker = SKSpriteNode(imageNamed: "biker clean")
    
    var initialBikerPosition: CGPoint!
    
    override func didMove(to view: SKView) {
        
        let boundary = SKSpriteNode()
        boundary.size = self.frame.size
        boundary.physicsBody?.isDynamic = false
        boundary.physicsBody?.friction = 1.0
        
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        addChild(brick1)
        addChild(brick2)
        addChild(biker)
        
        scrollingBackground1()
        scrollingBackground2()
        bikerBuild()
        addRow(type: RowType.SSmall)
        
    }
    
    func addRandomRow() {
        let randomNumber = Int(arc4random_uniform(3))
        
        switch  randomNumber {
        case 0:
            addRow(type: RowType(rawValue: 0)!)
            break
        case 1:
            addRow(type: RowType(rawValue: 1)!)
            break
        case 2:
            addRow(type: RowType(rawValue: 2)!)
            break
        default:
            break
            
        }
    }
    
    //new
    
    //old
    
    var lastUpdateTimeInterval = TimeInterval()
    var lastYieldTimeInterval = TimeInterval()
    
    
    func updateWithTimeSinceLastUpdate (timeSinceLastUpdate:TimeInterval) {
        lastYieldTimeInterval += timeSinceLastUpdate
        if lastYieldTimeInterval > 2 {
            lastYieldTimeInterval = 0
            addRandomRow()
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
    //new
    
    //old
}
func didBegin(_ contact: SKPhysicsContact) {
    if contact.bodyA.node?.name == "BIKER"{
        print("HIT")
    }
}
