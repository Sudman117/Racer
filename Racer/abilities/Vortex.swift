//
//  Vortex.swift
//  Racer
//
//  Created by John Sudduth on 5/15/19.
//  Copyright © 2019 John Sudduth. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit
import CoreMotion

class Vortex: Ability {
    
    let vortexEmitter = SKEmitterNode(fileNamed: "vortex")
    let vortex = SKFieldNode.radialGravityField()
    
    var player:SKSpriteNode
    
    init(playerSprite player:SKSpriteNode) {
        self.player = player
    }

    func execute() {
        createVortex()
    }
    
    func quit() {
        //
    }
    
    private func createVortex() {

        vortex.isEnabled = true
        vortex.strength = 200
        vortex.categoryBitMask = Category.vortexCategory
        player.physicsBody?.fieldBitMask = 0
        player.addChild(vortex)
        player.addChild(vortexEmitter!)
        
        Timer.scheduledTimer(withTimeInterval: 30, repeats: false, block: { (Timer) in
            self.vortex.isEnabled = false
        })
    }

    
}
