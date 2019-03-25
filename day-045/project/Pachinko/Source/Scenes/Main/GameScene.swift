//
//  GameScene.swift
//  Pachinko
//
//  Created by Brian Sipple on 1/24/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import SpriteKit

let sceneWidth = 1024.0
let sceneHeight = 768.0


class GameScene: SKScene {
    var scoreLabel: SKLabelNode!
    var editModeLabel: SKLabelNode!
    
    lazy var sceneCenterPoint = CGPoint(x: frame.midX, y: frame.midY)
    
    var currentScore = 0 {
        didSet {
            scoreLabel.text = "Score: \(self.currentScore)"
        }
    }
    
    var isInEditMode = false {
        didSet {
            editModeLabel.text = self.isInEditMode ? "Done" : "Edit"
        }
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
    }
}


// MARK: - Event handling

extension GameScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        
        if nodes(at: location).contains(editModeLabel) {
            isInEditMode.toggle()
        } else if isInEditMode {
            // create an obstacle -- or remove an obstacle that's being touched
            if let obstacle = nodes(at: location).first(where: { $0.name == NodeName.obstacle }) {
                obstacle.removeFromParent()
            } else {
                addChild(makeObstacle(at: location))
            }
        } else {
            // drop a ball from the top of the screen at the corresponding x position
            addChild(makeBall(at: CGPoint(x: location.x, y: frame.maxY)))
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
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        editModeLabel = SKLabelNode(fontNamed: "Chalkduster")
        
        scoreLabel.text = "Score: \(currentScore)"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: sceneWidth * 0.95, y: sceneHeight * 0.91)
        
        editModeLabel.text = "Edit"
        editModeLabel.position = CGPoint(x: sceneWidth * 0.078, y: sceneHeight * 0.91)
        
        
        addChild(scoreLabel)
        addChild(editModeLabel)
    }
    
    
    func setupObjects() {
        let objectSpacing = sceneWidth / 4.0
        
        for i in 0..<5 {
            let bouncerPoint = CGPoint(x: objectSpacing * Double(i), y: 0.0)
            addChild(makeBouncer(at: bouncerPoint))
        }
        
        for i in 0..<4 {
            let slotBasePoint = CGPoint(x: 128 + (objectSpacing * Double(i)), y: 0.0)
            let isSlotGood = i % 2 == 0
            
            addChild(makeSlot(at: slotBasePoint, isGood: isSlotGood))
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
        slotContainer.addChild(slotBase)
        slotContainer.addChild(slotGlow)
        
        return slotContainer
    }
    
    
    func makeBouncer(at position: CGPoint) -> SKSpriteNode {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        bouncer.physicsBody?.isDynamic = false
        
        return bouncer
    }
    
    
    func makeBall(at position: CGPoint) -> SKNode {
        let ball = SKSpriteNode(imageNamed: "ballRed")
        let ballPhysicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
        
        ballPhysicsBody.restitution = 0.4
        
        // shortcut to sign up for all ball contact notifications
        ballPhysicsBody.contactTestBitMask = ballPhysicsBody.collisionBitMask
        
        ball.physicsBody = ballPhysicsBody
        ball.position = position
        ball.name = NodeName.ball
        
        return ball
    }
    
    
    func makeObstacle(at position: CGPoint) -> SKNode {
        let boxSize = CGSize(width: Int.random(in: 16...256), height: 16)
        let boxColor = UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1)
        let obstacle = SKSpriteNode(color: boxColor, size: boxSize)
        
        obstacle.zRotation = CGFloat.random(in: 0...3)
        obstacle.position = position
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: boxSize)
        obstacle.physicsBody!.isDynamic = false
        obstacle.name = NodeName.obstacle
        
        return obstacle
    }
    
    
    func handleCollisionBetween(ball: SKNode, object: SKNode) {
        if object.name == NodeName.goodSlot {
            currentScore += 1
            destroy(ball: ball)
        } else if (object.name == NodeName.badSlot) {
            currentScore -= 1
            destroy(ball: ball)
        }
    }
    
    
    func destroy(ball: SKNode) {
        guard let fireParticles = SKEmitterNode(fileNamed: "FireParticles") else { return }
        
        fireParticles.position = ball.position
        
        addChild(fireParticles)
        ball.removeFromParent()
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
