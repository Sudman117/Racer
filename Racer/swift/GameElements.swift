//
//  GameElements.swift
//  bike
//
//  Created by Keegan Tountas on 8/4/18.
//  Copyright © 2018 Keegan Tountas. All rights reserved.
//

import SpriteKit

extension GameScene {
    
    func bikerBuild () {
        
    }
    
    func wallSetup() {
        
    }
    
    func moveBikerRight(){
        biker.physicsBody?.velocity = CGVector(dx: 300, dy: 0)
        let bikerRight = SKTexture(imageNamed: "biker right")
        
        let rotateRight = SKAction.rotate(toAngle: -0.3, duration: 0.5)
        let steerRight = SKAction.animate(with: [bikerRight], timePerFrame: 0.1)
        
        biker.run(rotateRight)
        biker.run(steerRight)
    }
    
    func moveBikerLeft(){
        biker.physicsBody?.velocity = CGVector(dx: -300, dy: 0)
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
        
        for t in touches {
            let location = t.location(in: self)
            let box = CGRect(x: 0, y: 0, width: biker.position.x, height: frame.size.height)
            if box.contains(location){
                moveBikerLeft()
            }
            else{
                moveBikerRight()
            }
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        bikerStop()
    }
    
    func addObstacle (type:ObstacleType) -> SKSpriteNode {
        let obstacle = SKSpriteNode(color:UIColor.white, size: CGSize(width:0, height: 30))
        obstacle.name = "OBSTACLE"
        obstacle.physicsBody?.isDynamic = true
        
        switch type {
        case .Small:
            obstacle.size.width = self.size.width * 0.2
            break
        case .Medium:
            obstacle.size.width = self.size.width * 0.35
            break
        case .Large:
            obstacle.size.width = self.size.width * 0.75
            break
        }
        obstacle.position = CGPoint(x:0,y:self.size.height + obstacle.size.height)
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
        obstacle.physicsBody?.categoryBitMask = Categories.obstacle
        obstacle.physicsBody?.collisionBitMask = 0
        
        
        return obstacle
    }
    
    
    func addMovement (obstacle:SKSpriteNode) {
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.move(to: CGPoint(x: obstacle.position.x, y: -obstacle.size.height), duration: TimeInterval(10.38)))
        actionArray.append(SKAction.removeFromParent())
        
        obstacle.run(SKAction.sequence(actionArray))
    }
}