//
//  MainGameScene.swift
//  Whack a Penguin
//
//  Created by Brian Sipple on 1/27/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import SpriteKit


class MainGameScene: SKScene {
    enum GameState {
        case active
        case over
    }
    
    var popupTime = 0.85
    let maxRounds = 30
    
    lazy var slots: [WhackSlot] = makeWhackSlots()
    lazy var currentScoreLabel: SKLabelNode = makeCurrentScoreLabel()
    lazy var gameOverLabel: SKSpriteNode = makeGameOverLabel()
    lazy var finalScoreLabel: SKLabelNode = makeFinalScoreLabel()
    
    var currentScore = 0 {
        didSet {
            currentScoreLabel.text = "Score: \(self.currentScore)"
        }
    }
    
    var currentRound = 0 {
        didSet {
            if currentRound > maxRounds {
                currentGameState = .over
            }
        }
    }
    
    var currentGameState: GameState = .active {
        didSet { gameStateChanged() }
    }
}


// MARK: - Computed Properties

extension MainGameScene {
    
    var sceneCenterPoint: CGPoint {
        return CGPoint(x: frame.midX, y: frame.midY)
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
        currentRound = 1
        
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
        addChild(currentScoreLabel)
    }
    
    
    func makeWhackSlots() -> [WhackSlot] {
        var slots: [WhackSlot] = []
        
        makeSlotPositions().forEach { position in
            let whackSlot = WhackSlot()
            
            whackSlot.configure(at: position)
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
    
    
    func makeCurrentScoreLabel() -> SKLabelNode {
        let label = SKLabelNode(fontNamed: "Chalkduster")
        
        label.position = CGPoint(x: frame.maxX * 0.007, y: frame.maxY * 0.007)
        label.horizontalAlignmentMode = .left
        label.fontSize = 48
        
        return label
    }
    
    
    func makeGameOverLabel() -> SKSpriteNode {
        let label = SKSpriteNode(imageNamed: "gameOver")
        
        label.position = sceneCenterPoint
        label.zPosition = 1
        
        return label
    }
    
    
    func makeFinalScoreLabel() -> SKLabelNode {
        let label = SKLabelNode(fontNamed: "Chalkduster")
        
        label.text = "Final Score: \(currentScore)"
        label.horizontalAlignmentMode = .center
        label.fontColor = #colorLiteral(red: 1, green: 0.3426768184, blue: 0.5157134533, alpha: 1)
        label.zPosition = 1
        label.fontSize = 42
        label.position = CGPoint(x: sceneCenterPoint.x, y: sceneCenterPoint.y - 84)
        
        return label
    }
    
    
    func startPopupLoop() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.runNewEnemyRound()
        }
    }
    
    
    func runNewEnemyRound() {
        guard currentGameState == .active else {
            preconditionFailure(#""runNewEnemyRound" called when game state was not active."#)
        }
        
        popupTime *= 0.991
        
        getSlotsToShow().forEach { $0.show(for: popupTime) }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + randomEnemyDelay) { [weak self] in
            self?.currentRound += 1
            
            if self?.currentGameState == .active {
                self?.runNewEnemyRound()
            }
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
        if slot.penguinNode.name == WhackSlot.NodeName.goodPenguin {
            guard !slot.isWhacked && slot.isShowingPenguin else { return }
            
            slot.whack()
            currentScore += 1
            
            run(SKAction.playSoundFileNamed(FileName.Sound.whackGood, waitForCompletion: false))
            
        } else if slot.penguinNode.name == WhackSlot.NodeName.evilPenguin {
            guard !slot.isWhacked && slot.isShowingPenguin else { return }
            
            slot.whack()
            currentScore -= 5
            
            run(SKAction.playSoundFileNamed(FileName.Sound.whackBad, waitForCompletion: false))
        }
    }

    
    func gameStateChanged() {
        if currentGameState == .over {
            endGame()
        }
    }
    
    
    func endGame() {
        slots.forEach { $0.hide() }

        currentScoreLabel.isHidden = true
        
        addChild(gameOverLabel)
        addChild(finalScoreLabel)
        
        run(SKAction.playSoundFileNamed(FileName.Sound.gameOver, waitForCompletion: false))
    }
}
