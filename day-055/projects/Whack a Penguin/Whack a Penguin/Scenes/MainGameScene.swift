//
//  MainGameScene.swift
//  Whack a Penguin
//
//  Created by Brian Sipple on 1/27/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import SpriteKit


class MainGameScene: SKScene {
    var currentScoreLabel: SKLabelNode!
    var popupTime = 0.85
    var currentRound = 0
    
    lazy var slots: [WhackSlot] = makeWhackSlots()
    
    var currentScore = 0 {
        didSet {
            currentScoreLabel.text = "Score: \(self.currentScore)"
        }
    }
}


// MARK: - Computed Properties

extension MainGameScene {
    
    var sceneCenterPoint: CGPoint {
        return CGPoint(x: frame.midX, y: frame.midY)
    }
    
    
    var remainingRounds: Int {
        return 30 - currentRound
    }
    
    
    var randomEnemyDelay: Double {
        let minDelay = popupTime / 2.0
        let maxDelay = popupTime * 2.0
        
        return Double.random(in: minDelay...maxDelay)
    }
}


// MARK: - Lifecycle

extension MainGameScene {
    
    override func didMove(to view: SKView) {
        setupBackground()
        setupUI()
        
        currentScore = 0
        
        startPopupLoop()
    }
}


// MARK: - Event handling

extension MainGameScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes {
            if let slot = WhackSlot.getPenguinSlot(from: node) {
                whackPenguin(inSlot: slot)
            }
        }
    }
}


// MARK: - Private Helper Methods

private extension MainGameScene {
    
    func setupBackground() {
        let background = SKSpriteNode(imageNamed: "whackBackground")
        
        background.position = sceneCenterPoint
        background.blendMode = .replace
        background.zPosition = -1
        
        addChild(background)
    }
    
    
    func setupUI() {
        currentScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        
        currentScoreLabel.position = CGPoint(x: frame.maxX * 0.007, y: frame.maxY * 0.007)
        currentScoreLabel.horizontalAlignmentMode = .left
        currentScoreLabel.fontSize = 48
        
        addChild(currentScoreLabel)
    }
    
    
    func makeWhackSlots() -> [WhackSlot] {
        var slots: [WhackSlot] = []
        
        makeSlotPositions().forEach { position in
            let whackSlot = WhackSlot()
            
            whackSlot.setup(at: position)
            addChild(whackSlot)
            slots.append(whackSlot)
        }
        
        return slots
    }
    
    
    func makeSlotPositions() -> [CGPoint] {
        let holeWidth = CGFloat(170.0)
        let widerRowStartX = frame.maxX * 0.1
        let thinnerRowStartX = frame.maxX * 0.12
        let rowHeights = [0.534, 0.416, 0.298, 0.180].map({ $0 * frame.maxY })
        var positions = [CGPoint]()
        
        // row 1
        for i in 0 ..< 5 { positions.append(CGPoint(x: widerRowStartX + (holeWidth * CGFloat(i)), y: rowHeights[0])) }
        
        // row 2
        for i in 0 ..< 4 { positions.append(CGPoint(x: thinnerRowStartX + (holeWidth * CGFloat(i)), y: rowHeights[1])) }
        
        // row 3
        for i in 0 ..< 5 { positions.append(CGPoint(x: widerRowStartX + (holeWidth * CGFloat(i)), y: rowHeights[2])) }
        
        // row 4
        for i in 0 ..< 4 { positions.append(CGPoint(x: thinnerRowStartX + (holeWidth * CGFloat(i)), y: rowHeights[3])) }
        
        return positions
    }
    
    
    func startPopupLoop() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.createEnemy()
        }
    }
    
    
    @objc func createEnemy() {
        currentRound += 1
        
        guard remainingRounds > 0 else { return endGame() }
        
        popupTime *= 0.991
        
        for slot in getSlotsToShow() {
            slot.show(for: popupTime)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + randomEnemyDelay) { [weak self] in
            self?.createEnemy()
        }
    }
    
    
    func getSlotsToShow() -> [WhackSlot] {
        slots.shuffle()
        
        var slotsToShow = [slots.first!]
        
        for (idx, threshold) in [4, 8, 10, 11].enumerated() {
            if Int.random(in: 0...12) > threshold {
                slotsToShow.append(slots[idx + 1])
            }
        }
        
        return slotsToShow
    }
    
    
    func whackPenguin(inSlot slot: WhackSlot) {
        if slot.penguinNode.name == WhackSlot.NodeName.goodPenguin.rawValue {
            guard !slot.isWhacked && slot.isShowingPenguin else { return }
            
            slot.whack(andShrink: true)
            currentScore += 1
            
            run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
            
        } else if slot.penguinNode.name == WhackSlot.NodeName.evilPenguin.rawValue {
            guard !slot.isWhacked && slot.isShowingPenguin else { return }
            
            slot.whack()
            currentScore -= 5
            
            run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
        }
    }
    
    
    func endGame() {
        slots.forEach { $0.hide() }
        
        let gameOverText = SKSpriteNode(imageNamed: "gameOver")
        
        gameOverText.position = CGPoint(x: frame.maxX / 2, y: frame.maxY / 2)
        gameOverText.zPosition = 1
        
        addChild(gameOverText)
    }
}
