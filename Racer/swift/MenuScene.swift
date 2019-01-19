//
//  GameScene.swift
//  Racer
//  Authors: John Sudduth & Keegan Tountas
//  Copyright 2018
//

import SpriteKit

class MenuScene: SKScene {
    
    let title = SKLabelNode()
    let playButton = SKLabelNode()
    
    override init(size: CGSize) {
        super.init(size: size)
        backgroundColor = SKColor.black
        title.fontColor = SKColor.red
        title.fontSize = 100
        title.text = "RACER"
        title.position = CGPoint(x: self.frame.width / 2, y: self.frame.height * 0.75)
        
        playButton.fontColor = SKColor.red
        playButton.text = "play"
        playButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        addChild(playButton)
        addChild(title)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        
        if playButton.contains(touchLocation) {
            let reveal = SKTransition.doorsOpenVertical(withDuration: 0.5)
            let gameScene = GameScene(size: CGSize(width: 1080, height: 1920))
            self.view?.presentScene(gameScene, transition: reveal)
        }
    }
}
