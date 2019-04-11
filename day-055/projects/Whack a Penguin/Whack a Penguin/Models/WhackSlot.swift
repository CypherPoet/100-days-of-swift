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
    lazy var cropNode: SKCropNode = makeCropNode()
    lazy var slotOpening: SKSpriteNode = makeSlotOpening()
    
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
        return isPenguinGood ? FileName.Image.goodPenguin : FileName.Image.badPenguin
    }
    
    var mudEffect: SKAction {
        return SKAction.run { [unowned self] in
            guard let emitter = SKEmitterNode(fileNamed: FileName.Emitter.mudDisplacement) else {
                preconditionFailure("Failed to load mud emitter file")
            }
            
            emitter.zPosition = self.slotOpening.zPosition
            emitter.position = CGPoint(x: self.slotOpening.position.x, y: self.slotOpening.position.y)

            self.addChild(emitter)
        }
    }
    
    var hitEffect: SKAction {
        return SKAction.run { [unowned self] in
            let emitterName = self.isPenguinGood ? FileName.Emitter.goodHit : FileName.Emitter.badHit
            
            guard let emitter = SKEmitterNode(fileNamed: emitterName) else {
                preconditionFailure("Failed to load spark emitter file")
            }
            
            emitter.position = CGPoint(
                x: self.slotOpening.position.x,
                y: self.slotOpening.position.y + (self.slotOpening.size.height / 4)
            )
            emitter.zPosition = self.penguinNode.zPosition + 1
            
            self.addChild(emitter)
        }
    }
    
    var showAction: SKAction {
        return SKAction.moveBy(x: 0, y: penguinNode.size.height, duration: 0.05)
    }
    
    var hideActions: SKAction {
        return SKAction.group([
            SKAction.moveBy(x: 0, y: -penguinNode.size.height, duration: 0.05),
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
        setupPenguin(at: position)
        self.addChild(slotOpening)
    }
    
    
    func show(for timeUntilHide: Double) {
        guard !isShowingPenguin else { return }
        
        isPenguinGood = Double.random(in: 0...1) >= 0.3333
        
        penguinNode.xScale = 1
        penguinNode.yScale = 1
        
        penguinNode.run(SKAction.group([
            mudEffect,
            showAction,
        ]))
        
        isShowingPenguin = true
        isWhacked = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (timeUntilHide * 3.5)) { [weak self] in
            self?.hide()
        }
    }
    
    
    func hide() {
        guard isShowingPenguin else { return }
        
        penguinNode.run(SKAction.group([mudEffect, hideActions]))
    }
    
    
    func whack() {
        guard isShowingPenguin && !isWhacked else { return }
        
        isWhacked = true
        
        penguinNode.run(SKAction.sequence([hitEffect, hideActions]))
    }
}


// MARK: - Private Helper Methods

private extension WhackSlot {
    
    func setupPenguin(at position: CGPoint) {
        self.position = position
        
        penguinNode.position = CGPoint(x: 0, y: -penguinNode.size.height * 1.1)
        cropNode.addChild(penguinNode)
        
        self.addChild(cropNode)
    }
    
    
    func makePenguinNode() -> SKSpriteNode {
        let node = SKSpriteNode(imageNamed: FileName.Image.goodPenguin)
        
        node.name = NodeName.goodPenguin
        node.zPosition = 3
        
        return node
    }
    
    
    func makeCropNode() -> SKCropNode {
        let cropNode = SKCropNode()
        
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: FileName.Image.whackMask)
        
        return cropNode
    }
    
    
    func makeSlotOpening() -> SKSpriteNode {
        let node = SKSpriteNode(imageNamed: FileName.Image.slotOpening)
        
        node.zPosition = 0
        
        return node
    }
}
