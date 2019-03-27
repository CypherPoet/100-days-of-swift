//
//  GameScene.swift
//  Pachinko
//
//  Created by Brian Sipple on 1/24/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import SpriteKit


class GameScene: SKScene {
    enum GameplayState {
        case start
        case editing
        case dropping
        case ending  // out of new balls, but could still be dropping
        case over
    }
    
    weak var gameViewController: GameViewController!
    
    lazy var scoreLabel: SKLabelNode = makeScoreLabel()
    lazy var editModeLabel: SKLabelNode = makeEditLabel()
    lazy var remainingBallsLabel: SKLabelNode = makeRemainingBallsLabel()
    lazy var startGameLabel: SKLabelNode = makeStartGameLabel()
    
    lazy var sceneCenterPoint = CGPoint(x: frame.midX, y: frame.midY)
    
    var remainingObstacles = 0
    
    var currentScore = 0 {
        didSet {
            scoreLabel.text = "Score: \(currentScore)"
        }
    }
    
    var remainingBalls = 5 {
        didSet {
            remainingBallsLabel.text = "Balls: \(remainingBalls)"
        }
    }
    
    var currentGameplayState: GameplayState = .start {
        didSet {
            gameplayStateChanged()
        }
    }
}


// MARK: - Computed Properties

extension GameScene {
    var newBallNode: SKSpriteNode {
        return SKSpriteNode(imageNamed: AssetName.Ball.all.randomElement()!)
    }
    
    var baseLabelNode: SKLabelNode {
         return SKLabelNode(fontNamed: "Chalkduster")
    }
    
    var restartMessage: String {
        if remainingObstacles == 0 {
            return """
                👏 Congratulations! You cleared all the obstacles and finished with \
                \(currentScore) points!
                """
        }
        
        return """
            Unfortunately, you didn't clear all of the obstacles. Your final score is \
            \(currentScore) points.
            """
    }
}


// MARK: - Lifecycle

extension GameScene {
    
    override func didMove(to view: SKView) {
        createBackground()
        setupUI()
        setupObjects()
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        currentGameplayState = .start
    }
}


// MARK: - Event handling

extension GameScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        
        switch currentGameplayState {
        case .start:
            if touchedNodes.contains(editModeLabel) {
                currentGameplayState = .editing
            }
        case .editing:
            if touchedNodes.contains(startGameLabel) {
                currentGameplayState = .dropping
            } else {
                if let obstacle = touchedNodes.first(where: { $0.name == NodeName.obstacle }) {
                    obstacle.removeFromParent()
                    remainingObstacles -= 1
                } else {
                    remainingObstacles += 1
                    addChild(makeObstacle(at: location))
                }
            }
        case .dropping:
            // drop a ball from the top of the screen at the corresponding x position
            addChild(makeBall(at: CGPoint(x: location.x, y: frame.maxY)))
            remainingBalls -= 1
            
            if remainingBalls == 0 {
                currentGameplayState = .ending
            }
        case .ending, .over:
            break
        }
    }
}


// MARK: - Private Helper Methods

private extension GameScene {

    func createBackground() {
        let backgroundNode = SKSpriteNode(imageNamed: "background.jpg")
        
        backgroundNode.position = sceneCenterPoint
        backgroundNode.zPosition = -1
        backgroundNode.blendMode = .replace
        
        addChild(backgroundNode)
    }
    
    
    func setupUI() {
        addChild(scoreLabel)
        addChild(editModeLabel)
        addChild(remainingBallsLabel)
        addChild(startGameLabel)
    }
    
    
    func setupObjects() {
        let objectSpacing = CGFloat(frame.maxX / 4.0)
        
        for i in 0..<5 {
            let bouncerPosition = CGPoint(x: objectSpacing * CGFloat(i), y: 0.0)
            addChild(makeBouncer(at: bouncerPosition))
        }
        
        for i in 0..<4 {
            let slotBasePosition = CGPoint(x: 128 + (objectSpacing * CGFloat(i)), y: 0.0)
            let isSlotGood = i % 2 == 0
            
            addChild(makeSlot(at: slotBasePosition, isGood: isSlotGood))
        }
    }
    
    
    func makeSlot(at position: CGPoint, isGood: Bool) -> SKSpriteNode {
        let slotFileName = isGood ? "slotBaseGood" : "slotBaseBad"
        let slotGlowFileName = isGood ? "slotGlowGood" : "slotGlowBad"
        let slotNodeName = isGood ? NodeName.goodSlot : NodeName.badSlot
        
        let slotContainer = SKSpriteNode()
        let slotBase = SKSpriteNode(imageNamed: slotFileName)
        let slotGlow = SKSpriteNode(imageNamed: slotGlowFileName)

        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        slotBase.name = slotNodeName

        let spinAction = SKAction.rotate(byAngle: .pi, duration: 10)
        let glowSpin = SKAction.repeatForever(spinAction)
        
        slotGlow.run(glowSpin)
        
        slotContainer.position = position
        slotContainer.zPosition = 0
        slotContainer.addChild(slotBase)
        slotContainer.addChild(slotGlow)
        
        return slotContainer
    }
    
    
    func makeBouncer(at position: CGPoint) -> SKSpriteNode {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        
        bouncer.position = position
        bouncer.zPosition = 1
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        bouncer.physicsBody?.isDynamic = false
        
        return bouncer
    }
    
    
    func makeBall(at position: CGPoint) -> SKNode {
        let ball = newBallNode
        let ballPhysicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
        
        ballPhysicsBody.restitution = CGFloat.random(in: 0.64...0.95)
        
        // shortcut to sign up for all ball contact notifications
        ballPhysicsBody.contactTestBitMask = ballPhysicsBody.collisionBitMask
        
        ball.physicsBody = ballPhysicsBody
        ball.position = position
        ball.name = NodeName.ball
        
        return ball
    }
    
    
    func makeObstacle(at position: CGPoint) -> SKNode {
        let boxSize = CGSize(width: Int.random(in: 16...256), height: 16)
        let boxColor = UIColor(
            red: CGFloat.random(in: 0...1),
            green: CGFloat.random(in: 0...1),
            blue: CGFloat.random(in: 0...1),
            alpha: 1
        )
        
        let obstacle = SKSpriteNode(color: boxColor, size: boxSize)
        
        obstacle.zRotation = CGFloat.random(in: 0...3)
        obstacle.position = position
        
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: boxSize)
        obstacle.physicsBody!.isDynamic = false
        obstacle.physicsBody!.restitution = CGFloat.random(in: 0.86...1.0)
        
        obstacle.name = NodeName.obstacle
        
        return obstacle
    }
    
    
    func makeEditLabel() -> SKLabelNode {
        let label = baseLabelNode
        
        label.text = "Edit"
        label.horizontalAlignmentMode = .center
        label.position = sceneCenterPoint
        
        return label
    }
    
    
    func makeStartGameLabel() -> SKLabelNode {
        let label = baseLabelNode
        
        label.text = "Start"
        label.position = CGPoint(x: frame.maxX * 0.078, y: frame.maxY * 0.91)

        return label
    }
    
    
    func makeScoreLabel() -> SKLabelNode {
        let label = baseLabelNode
        
        label.horizontalAlignmentMode = .right
        label.position = CGPoint(x: frame.maxX * 0.95, y: frame.maxY * 0.91)
        
        return label
    }
    
    
    func makeRemainingBallsLabel() -> SKLabelNode {
        let label = baseLabelNode
        
        label.horizontalAlignmentMode = .right
        label.position = CGPoint(x: frame.maxX * 0.95, y: frame.maxY * 0.82)
        
        return label
    }
    
    
    func handleCollisionBetween(ball: SKNode, object: SKNode) {
        switch object.name {
        case NodeName.goodSlot:
            currentScore += 3
            destroy(ball: ball)
        case NodeName.badSlot:
            currentScore -= 3
            destroy(ball: ball)
        case NodeName.obstacle:
            destroy(obstacle: object)
        default:
            break
        }
    }
    
    
    func destroy(obstacle: SKNode) {
        currentScore += 10
        remainingObstacles -= 1
        obstacle.removeFromParent()
    }
    
    
    func destroy(ball: SKNode) {
        guard let fireParticles = SKEmitterNode(fileNamed: "FireParticles") else { return }
        
        fireParticles.position = ball.position
        
        addChild(fireParticles)
        ball.removeFromParent()

        if currentGameplayState == .ending {
            currentGameplayState = .over
        }
    }
    
    
    func gameplayStateChanged() {
        switch currentGameplayState {
        case .start:
            isUserInteractionEnabled = true
            currentScore = 0
            remainingObstacles = 0
            remainingBalls = 5
            startGameLabel.isHidden = true
            editModeLabel.isHidden = false
        case .editing:
            editModeLabel.isHidden = true
            startGameLabel.isHidden = false
        case .dropping:
            startGameLabel.isHidden = true
        case .ending:
            isUserInteractionEnabled = false
        case .over:
            promptForRestart()
        }
    }
    
    func promptForRestart() {
        let alertController = UIAlertController(
            title: "Game Over",
            message: restartMessage,
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(title: "Restart", style: .default) { [weak self] _ in
            self?.restartGame()
        })
        
        gameViewController.present(alertController, animated: true)
    }
    
    
    func restartGame() {
        scene?.enumerateChildNodes(withName: NodeName.obstacle) { (obstacle, _) in
            obstacle.removeFromParent()
        }
        
        currentGameplayState = .start
    }
}


// MARK: - SKPhysicsContactDelegate

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard
            let nodeA = contact.bodyA.node,
            let nodeB = contact.bodyB.node
        else { return }
        
        if nodeA.name == NodeName.ball {
            handleCollisionBetween(ball: nodeA, object: nodeB)
        } else if nodeB.name == NodeName.ball {
            handleCollisionBetween(ball: nodeB, object: nodeA)
        }
    }
}
