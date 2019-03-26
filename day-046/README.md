# Day 46: _Project 11: Pachinko_, Part Two

_Follow along at https://www.hackingwithswift.com/100/46_.


## 📒 Field Notes

> This day covers the second part of `Project 11: Pachinko` in _[Hacking with Swift](https://www.hackingwithswift.com/read/11)_.
>
> I have a [separate repository](https://github.com/CypherPoet/book--hacking-with-swift) where I've been creating projects alongside the material in the book. And you can find Project 11 [here](https://github.com/CypherPoet/book--hacking-with-swift/tree/master/11-pachinko/Pachinko). However, I also copied it over to Day 45's folder so I could extend from where I left off.
>
> With that in mind, Day 46 focuses on several specific topics:
>
> - Spinning slots: SKAction
> - Collision detection: SKPhysicsContactDelegate
> - Scores on the board: SKLabelNode


### Spinning slots: SKAction

`SKAction`s have a neat paradigm where we essentially create `SKAction` instances, and then apply them to various nodes. Ultimately, this object-oriented structure leads into being able to compose various [sequences](https://developer.apple.com/documentation/spritekit/skaction/1417817-sequence) and [groups](https://developer.apple.com/documentation/spritekit/skaction/1417688-group) in immensely powerful ways. For now, though, we're just looking to create some spinning slots that will detect our ball drops:

```swift

func makeSlot(at position: CGPoint, isGood: Bool) -> SKSpriteNode {
    ...
    ...

    let slotGlow = SKSpriteNode(imageNamed: slotGlowFileName)

    let spinAction = SKAction.rotate(byAngle: .pi, duration: 10)
    let glowSpin = SKAction.repeatForever(spinAction)

    slotGlow.run(glowSpin)

    ...
    ...
}
```

Also, yes... those are radians being used. SpriteKit knows what's up 😎.


### Collision detection: SKPhysicsContactDelegate

Collision detection in SpriteKit is orchestrated through a system of node `contactTestBitMask`s, `collisionBitMask`s, and `categoryBitMask`s. Apple has some good [documentation explaining these intricacies](https://developer.apple.com/documentation/spritekit/skphysicsbody/about_collisions_and_contacts).

For our purposes, we're mainly concerned about the ball's `contactTestBitMask`. The way we set this essentially determines which contact events we "sign up" to have handled by our GameScene's `physicsWorld.contactDelegate` (which, in this case, we're setting to be the `GameScene` itself).

```swift
func makeBall(at position: CGPoint) -> SKNode {
    ...
    ...

    // shortcut to sign up for all ball contact notifications
    ball.ballPhysicsBody!.contactTestBitMask = ballPhysicsBody.collisionBitMask

    ...
    ...
}
```

This just sets us up to handle a "contact" event every time our ball collides with another node &mdash; allowing our `SKPhysicsContactDelegate`'s `didBegin(_:)` to detect such an event, and handle it further:

```swift
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
```

### Scores on the board: SKLabelNode

Stylistically, `SKLabelNode`s are pretty similar to UIKit's `UILabels`. The only real difference, as mentioned in [Day 45](../day-045), is the fact that &mdash; because it's a _node_ in a _scene_ &mdash; position's are based on the node's center:


```swift
func makeScoreLabel() -> SKLabelNode {
    let label = SKLabelNode(fontNamed: "Chalkduster")

    label.text = "Score: \(currentScore)"
    label.horizontalAlignmentMode = .right
    label.position = CGPoint(x: frame.maxX * 0.95, y: frame.maxY * 0.91)

    return label
}
```

Sweet. Furthermore, now that the label is in our scene, we can update it similar to the way we'd update a standard UIKit element in a view.

```swift
var currentScore = 0 {
    didSet {
        scoreLabel.text = "Score: \(currentScore)"
    }
}
```
