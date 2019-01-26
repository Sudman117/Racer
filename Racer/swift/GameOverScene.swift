//
//  GameOverScene.swift
//  Racer
//
//  Created by John Sudduth on 1/13/19.
//  Copyright © 2019 John Sudduth. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    
    let gameOverLabel = SKLabelNode()
    let replayButton = SKLabelNode()
    
    override init(size: CGSize) {
        super.init(size: size)
        
        gameOverLabel.fontColor = SKColor.red
        gameOverLabel.fontSize = 100
        gameOverLabel.text = "GAME OVER"
        gameOverLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        replayButton.fontColor = SKColor.red
        replayButton.fontSize = 70
        replayButton.text = "Replay?"
        replayButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY * 0.33)
        
        addChild(gameOverLabel)
        addChild(replayButton)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        
        if replayButton.contains(touchLocation) {
            
            let reveal = SKTransition.crossFade(withDuration: 0.5)
            let menuScene = MenuScene(size: CGSize(width: 1080, height: 1920))
            self.view?.presentScene(menuScene, transition: reveal)
        }
    }
}
