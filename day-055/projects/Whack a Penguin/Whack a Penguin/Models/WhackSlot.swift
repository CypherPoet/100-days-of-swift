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
    enum NodeName: String {
        case goodPenguin = "good-penguin"
        case evilPenguin = "evil-penguin"
    }
    
    var penguinNode: SKSpriteNode!
    var isShowingPenguin: Bool = false
    var isWhacked: Bool = false
    
    var penguinTextureName: String {
        return isPenguinGood ? "penguinGood" : "penguinEvil"
    }
    
    var isPenguinGood = false {
        didSet {
            penguinNode.texture = SKTexture(imageNamed: penguinTextureName)
            penguinNode.name = isPenguinGood ? NodeName.goodPenguin.rawValue : NodeName.evilPenguin.rawValue
        }
    }
    
    var showAction: SKAction {
        return SKAction.moveBy(x: 0, y: 80, duration: 0.05)
    }
    
    var hideAction: SKAction {
        return SKAction.moveBy(x: 0, y: -80, duration: 0.05)
    }
    
    
    static func getPenguinSlot(from node: SKNode) -> WhackSlot? {
        if (
            node.name == WhackSlot.NodeName.evilPenguin.rawValue ||
            node.name == WhackSlot.NodeName.goodPenguin.rawValue
        ) {
            return node.parent?.parent as? WhackSlot
        }

        return nil
    }
    
    
    func setup(at position: CGPoint) {
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (timeUntilHide * 3.5)) { [unowned self] in
            self.hide()
        }
    }
    
    func hide() {
        guard isShowingPenguin else { return }
        
        penguinNode.run(hideAction)

        isShowingPenguin = false
    }
    
    
    func whack(andShrink: Bool = false) {
        guard isShowingPenguin && !isWhacked else { return }
        
        let delay = SKAction.wait(forDuration: 0.25)
        let turnOffVisibility = SKAction.run({ [unowned self] in self.isShowingPenguin = false })
        
        isWhacked = true
        
        penguinNode.xScale = 0.85
        penguinNode.yScale = 0.85
        penguinNode.run(SKAction.sequence([delay, hideAction, turnOffVisibility]))
    }
    
    
    private func setupPenguin(at position: CGPoint) {
        let cropNode = SKCropNode()
        penguinNode = SKSpriteNode(imageNamed: "penguinGood")
        
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        
        penguinNode.position = CGPoint(x: 0, y: -90)
        penguinNode.name = NodeName.goodPenguin.rawValue
        
        cropNode.addChild(penguinNode)
        
        self.addChild(cropNode)
    }
}
