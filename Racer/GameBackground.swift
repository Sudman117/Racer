//
//  GameBackground.swift
//  bike
//
//  Created by Keegan Tountas on 8/5/18.
//  Copyright © 2018 Keegan Tountas. All rights reserved.
//

import SpriteKit

extension GameScene {
    
    
    func scrollingBackground1 () {
        
        brick1.position = CGPoint(x: frame.size.width/2, y: frame.size.height*0.5)
        brick1.size = CGSize(width: frame.size.width, height: frame.size.height)
        brick1.zPosition = -1
        
        let b1Down = SKAction.moveBy(x: 0, y: -frame.size.height * 1.0, duration: 10.0)
        let b1ResetPosition = SKAction.moveBy(x: 0, y: frame.size.height * 1.0, duration: 0.0)
        
        let b1Move = SKAction.sequence([b1Down,b1ResetPosition])
        let b1Cycle = SKAction.repeatForever(b1Move)
        
        brick1.run(b1Cycle)
        
    }
    
    func scrollingBackground2 () {
        
        brick2.position = CGPoint(x: frame.size.width/2, y: frame.size.height * 1.5)
        brick2.size = CGSize(width: frame.size.width, height: frame.size.height)
        brick2.zPosition = -1
        
        let b2Down = SKAction.moveBy(x: 0, y: -frame.size.height * 1.0, duration: 10.0)
        let b2ResetPosition = SKAction.moveBy(x: 0, y: frame.size.height * 1.0, duration: 0.0)
        
        let b2Move = SKAction.sequence([b2Down,b2ResetPosition])
        let b2Cycle = SKAction.repeatForever(b2Move)
        
        brick2.run(b2Cycle)
    }
}
