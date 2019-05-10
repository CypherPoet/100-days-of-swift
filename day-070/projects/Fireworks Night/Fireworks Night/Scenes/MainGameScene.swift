//
//  GameScene.swift
//  Fireworks Night
//
//  Created by Brian Sipple on 2/6/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import SpriteKit
import GameplayKit


class MainGameScene: SKScene {
    let fireworkInterval = 4.0
    let fireworkSpeed = CGFloat(200.0)
    let launchEdgeOffset = CGFloat(22)
    
    var gameTimer: Timer!
    
    var fireworks: [SKNode] = []
    var selectedRockets: [SKSpriteNode] = []
    
    lazy var background: SKNode = makeBackground()
    lazy var scoreLabel: SKLabelNode = makeScoreLabel()
    
    var currentScore = 0 {
        didSet {
            scoreLabel.text = "Score: \(currentScore)"
        }
    }
    
    var colorToDetonate: UIColor!
    lazy var rocketColors = [UIColor.cyan, UIColor.green, UIColor.red]
}


// MARK: - Computed Properties

extension MainGameScene {
    
    var sceneCenterPoint: CGPoint {
        return CGPoint(x: frame.midX, y: frame.midY)
    }
    
    var rocketYMovement: CGFloat {
        return frame.maxY * 1.5
    }
}
    

// MARK: - Lifecycle

extension MainGameScene {
    
    override func didMove(to view: SKView) {
        setupUI()
        setupTimer()
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        guard let touch = touches.first else { return }
        handleTouch(touch)
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let touch = touches.first else { return }
        handleTouch(touch)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        cleanupPastFireworks()
    }
}


// MARK: - Core Methods

extension MainGameScene {
    
    func explodeSelectedFireworks() {
        let pointsToAward = selectedRockets.count * 200
        
        selectedRockets.removeAll(keepingCapacity: true)
        
        for (index, firework) in fireworks.enumerated().reversed() {
            if firework.childNode(withName: NodeName.selectedFireworkRocket) != nil {
                fireworks.remove(at: index)
                explode(firework: firework)
            }
        }
        
        currentScore += pointsToAward
    }
}



// MARK: - Private Helper Methods

private extension MainGameScene {
    
    func setupTimer() {
        gameTimer = Timer.scheduledTimer(
            timeInterval: fireworkInterval,
            target: self,
            selector: #selector(launchFireworks),
            userInfo: nil,
            repeats: true
        )
    }
    
    func setupUI() {
        addChild(scoreLabel)
        addChild(background)
        
        currentScore = 0
    }
    
    
    func makeBackground() -> SKNode {
        let background = SKSpriteNode(imageNamed: "background")
        
        background.position = sceneCenterPoint
        background.blendMode = .replace
        background.zPosition = -1
        
        return background
    }
    
    
    func makeScoreLabel() -> SKLabelNode {
        let scoreLabel = SKLabelNode(fontNamed: "Futura")
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.verticalAlignmentMode = .top
        scoreLabel.position = CGPoint(x: frame.maxX - 16, y: frame.maxY - 16)
        
        return scoreLabel
    }
    
    
    /**
     * Launch fireworks five at a time, in a random configuration
     */
    @objc func launchFireworks() {
        let burstQuantity = 5
        let spacingIncrement = CGFloat(frame.maxY / CGFloat(burstQuantity)) / 2
        
        switch LaunchStyle.allCases.randomElement()! {
        case .straightUp:
            launchStraightUp(numFireworks: burstQuantity, spacingIncrement: spacingIncrement)
        case .fanUp:
            launchFanUp(numFireworks: burstQuantity, spacingIncrement: spacingIncrement)
        case .leftToRight:
            launchLeftToRight(numFireworks: burstQuantity, spacingIncrement: spacingIncrement)
        case .rightToLeft:
            launchRightToLeft(numFireworks: burstQuantity, spacingIncrement: spacingIncrement)
        }
    }
    
    
    func createLaunch(xMovement: CGFloat, xPos: CGFloat, yPos: CGFloat) {
        let firework = makeFirework()
        let motion = makeFireworkMotion(xMovement: xMovement, speed: fireworkSpeed)
        
        firework.position = CGPoint(x: xPos, y: yPos)
        
        fireworks.append(firework)
        firework.run(motion)
        
        addChild(firework)
    }

    
    func makeFirework() -> SKNode {
        let firework = SKNode()
        let fireworkGlow = SKEmitterNode(fileNamed: "fuse")!
        let fireworkRocket = SKSpriteNode(imageNamed: "rocket")
        
        fireworkRocket.colorBlendFactor = 1
        fireworkRocket.name = NodeName.fireworkRocket
        fireworkRocket.color = rocketColors.randomElement()!
        
        fireworkGlow.position = CGPoint(x: 0, y: -22)
        
        firework.addChild(fireworkGlow)
        firework.addChild(fireworkRocket)
        
        return firework
    }
    
    
    func makeFireworkMotion(xMovement: CGFloat, speed: CGFloat) -> SKAction {
        let path = UIBezierPath()
        
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: xMovement, y: rocketYMovement))
        
        let motionPathAction = SKAction.follow(
            path.cgPath,
            asOffset: true, // `asOffset` makes the motion start relative to the node's position
            orientToPath: true,
            speed: CGFloat(speed)
        )
        
        return motionPathAction
    }
    
    
    func launchStraightUp(numFireworks: Int, spacingIncrement: CGFloat) {
        print("launchStraightUp")
        let startX = frame.midX - CGFloat(spacingIncrement * floor(CGFloat(numFireworks) / 2))
        
        for n in 0 ..< numFireworks {
            let xPosition = startX + (CGFloat(n) * spacingIncrement)
                
            createLaunch(xMovement: 0, xPos: xPosition, yPos: frame.minY - launchEdgeOffset)
        }
    }
    
    
    func launchFanUp(numFireworks: Int, spacingIncrement: CGFloat) {
        print("launchFanUp")
        let startX = frame.midX - CGFloat(spacingIncrement * floor(CGFloat(numFireworks) / 2))
        let cosineIncrement = (CGFloat.pi / 8) / CGFloat(numFireworks)
        let startCosine = cos( (CGFloat.pi / 4) - (CGFloat(cosineIncrement * floor(CGFloat(numFireworks) / 2))) )
        
        for n in 0 ..< numFireworks {
            let xPosition = startX
            let currentCosine = abs((startCosine + (CGFloat(n) * cosineIncrement)) - (CGFloat.pi / 4))
            let xMovement = currentCosine * rocketYMovement
            
            createLaunch(xMovement: xMovement, xPos: xPosition, yPos: frame.minY - launchEdgeOffset)
        }
    }
    
    
    func launchLeftToRight(numFireworks: Int, spacingIncrement: CGFloat) {
        print("launchLeftToRight")
        let startY = frame.midY - CGFloat(spacingIncrement * floor(CGFloat(numFireworks) / 2))

        for n in 0 ..< numFireworks {
            let yPosition = startY + (CGFloat(n) * spacingIncrement)
            let xMovement = frame.maxX * 1.5

            createLaunch(xMovement: xMovement, xPos: frame.minX - launchEdgeOffset, yPos: yPosition)
        }
    }
    
    
    func launchRightToLeft(numFireworks: Int, spacingIncrement: CGFloat) {
        print("launchRightToLeft")
        let startY = frame.midY - CGFloat(spacingIncrement * floor(CGFloat(numFireworks) / 2))

        for n in 0 ..< numFireworks {
            let yPosition = startY + (CGFloat(n) * spacingIncrement)
            let xMovement = frame.maxX * 1.5
            
            createLaunch(xMovement: -xMovement, xPos: frame.maxX + launchEdgeOffset, yPos: yPosition)
        }
    }

    
    func handleTouch(_ touch: UITouch) {
        let nodesAtTouchPoint = nodes(at: touch.location(in: self))
        
        for case let touchedNode as SKSpriteNode in nodesAtTouchPoint {
            guard touchedNode.name == NodeName.fireworkRocket else { continue }

            if !selectedRockets.isEmpty && touchedNode.color != colorToDetonate {
                resetSelectedRockets()
            } else {
                colorToDetonate = touchedNode.color
                touchedNode.name = NodeName.selectedFireworkRocket
                touchedNode.colorBlendFactor = 0
                touchedNode.color = UIColor.white
                selectedRockets.append(touchedNode)
            }
        }
    }
    
    
    func resetSelectedRockets() {
        for rocketNode in selectedRockets {
            rocketNode.name = NodeName.fireworkRocket
            rocketNode.color = colorToDetonate
            rocketNode.colorBlendFactor = 1
        }
        
        selectedRockets.removeAll(keepingCapacity: true)
    }
    

    func cleanupPastFireworks() {
        for (index, firework) in fireworks.enumerated().reversed() {
            if firework.position.y > frame.maxY * 1.25 {
                fireworks.remove(at: index)
                firework.removeFromParent()
            }
        }
    }
    
    
    func explode(firework: SKNode) {
        let emitter = SKEmitterNode(fileNamed: "explode")!
        
        emitter.position = firework.position
        addChild(emitter)
        firework.removeFromParent()
    }
}
