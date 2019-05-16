//
//  MainGameViewController.swift
//  Fireworks Night
//
//  Created by Brian Sipple on 2/6/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class MainGameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as? SKView {
            if let scene = SKScene(fileNamed: "MainGameScene") {
                scene.scaleMode = .aspectFill
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
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

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
}


// MARK: - Lifecycle

extension MainGameViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        becomeFirstResponder()
    }
    
    
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard
            let spriteKitView = self.view as? SKView,
            let gameScene = spriteKitView.scene as? MainGameScene
        else {
            preconditionFailure("Failed to find SKView and MainGameScene")
        }
        
        gameScene.explodeSelectedFireworks()
    }
}

