//
//  GameViewController.swift
//  Racer
//
//  Created by John Sudduth on 8/17/18.
//  Copyright © 2018 John Sudduth. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        if let view = self.view as! SKView? {
            let menuScene = MenuScene(size: CGSize(width: view.bounds.width, height: view.bounds.height))
            let skView = view
            skView.showsFPS = true
            skView.showsNodeCount = true
            skView.ignoresSiblingOrder = true
            skView.presentScene(menuScene)
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
