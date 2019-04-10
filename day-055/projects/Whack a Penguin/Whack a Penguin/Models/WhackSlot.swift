//
//  WhackSlot.swift
//  Whack a Penguin
//
//  Created by Brian Sipple on 1/28/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import SpriteKit
import UIKit

class WhackSlot: SKNode {
    enum NodeName {
        static let goodPenguin = "good-penguin"
        static let evilPenguin = "evil-penguin"
    }
    
    lazy var penguinNode: SKSpriteNode = makePenguinNode()
    
    var isShowingPenguin: Bool = false
    var isWhacked: Bool = false
    
    var isPenguinGood = false {
        didSet {
            penguinNode.texture = SKTexture(imageNamed: penguinTextureName)
            penguinNode.name = isPenguinGood ? NodeName.goodPenguin : NodeName.evilPenguin
        }
    }
}


// MARK: - Computed Properties

extension WhackSlot {
    var penguinTextureName: String {
        return isPenguinGood ? "penguinGood" : "penguinEvil"
    }
    
    var showAction: SKAction {
        return SKAction.moveBy(x: 0, y: 80, duration: 0.05)
    }
    
    var hideActions: SKAction {
        return SKAction.group([
            SKAction.moveBy(x: 0, y: -80, duration: 0.05),
            SKAction.scale(to: 0.08, duration: 0.025),
            SKAction.run { [weak self] in
                self?.isShowingPenguin = false
            },
        ])
    }
}


// MARK: - Static Properties

extension WhackSlot {
    
    static func getPenguinSlot(from node: SKNode) -> WhackSlot? {
        if (
            node.name == WhackSlot.NodeName.evilPenguin ||
            node.name == WhackSlot.NodeName.goodPenguin
        ) {
            return node.parent?.parent as? WhackSlot
        }

        return nil
    }
}


// MARK: - Core Methods

extension WhackSlot {
    
    func configure(at position: CGPoint) {
        self.position = position
        
        let hole = SKSpriteNode(imageNamed: "whackHole")
        
        setupPenguin(at: position)
        self.addChild(hole)
    }
    
    
    func show(for timeUntilHide: Double) {
        guard !isShowingPenguin else { return }
        
        isPenguinGood = Double.random(in: 0...1) >= 0.3333
        
        penguinNode.xScale = 1
        penguinNode.yScale = 1
        penguinNode.run(showAction)
        
        isShowingPenguin = true
        isWhacked = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (timeUntilHide * 3.5)) { [weak self] in
            self?.hide()
        }
    }
    
    
    func hide() {
        guard isShowingPenguin else { return }
        
        penguinNode.run(hideActions)
    }
    
    
    func whack() {
        guard isShowingPenguin && !isWhacked else { return }
        
        isWhacked = true
        
        let delay = SKAction.wait(forDuration: 0.25)
        penguinNode.run(SKAction.sequence([delay, hideActions]))
    }
}


// MARK: - Private Helper Methods

private extension WhackSlot {
    
    func setupPenguin(at position: CGPoint) {
        let cropNode = SKCropNode()
        
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        
        penguinNode.position = CGPoint(x: 0, y: -penguinNode.size.height * 1.1)
        
        cropNode.addChild(penguinNode)
        
        self.addChild(cropNode)
    }
    
    
    func makePenguinNode() -> SKSpriteNode {
        let node = SKSpriteNode(imageNamed: "penguinGood")
        node.name = NodeName.goodPenguin
        
        return node
    }
}
