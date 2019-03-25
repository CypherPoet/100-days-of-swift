# Day 45: _Project 11: Pachinko_, Part One

_Follow along at https://www.hackingwithswift.com/100/45_.


## 📒 Field Notes

> This day covers the first part of `Project 11: Pachinko` in _[Hacking with Swift](https://www.hackingwithswift.com/read/11)_.
>
> I have a [separate repository](https://github.com/CypherPoet/book--hacking-with-swift) where I've been creating projects alongside the material in the book. And you can find Project 11 [here](https://github.com/CypherPoet/book--hacking-with-swift/tree/master/11-pachinko/Pachinko). However, I also copied it over to this day's folder so I could extend from where I left off.
>
> With that in mind, Day 45 focuses on several specific topics:
>
> - Coordinate Systems and Positioning
> - Falling boxes: SKSpriteNode, UITouch, SKPhysicsBody
> - Bouncing balls: circleOfRadius


### Coordinate Systems and Positioning

SpriteKit doesn't mess around. It respects the Grammar of Graphics and zeroes its Y-coordinate at the bottom, increasing upwards. This is notable, because UIKit's Y-coordinate goes the other way (top to bottom) &mdash; more like a Grammar of Page Layout... or something.

Furthermore, `nodes` &mdash; the objects placed in a scene &mdash; are positioned from their center: The point (0,0) refers to the horizontal and vertical center of a node.

These differences can be confusing at first, but they exist for a reason. When we start to introduce physics and other effects, it's handy to have a coordinate and positioning system that lets us think in terms of _worlds_, _universes_, and _bodies_ within them 💫.


### Falling boxes: SKSpriteNode, UITouch, SKPhysicsBody

Despite being in its own world, SpriteKit _can_ and does still let us interface with UIKit. Handling the `touchesBegan` method is a perfect example. Because the `GameScene` is still driven by a `GameViewController`, which is a subclass of `UIViewController`, we can respond to `touchesBegan`, and use the location information to... say... place a node:

```swift
override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }

    let location = touch.location(in: self)

    // drop a ball from the top of the screen at the corresponding x position
    addChild(makeBall(at: CGPoint(x: location.x, y: frame.maxY)))
}
```


### Bouncing balls: circleOfRadius

Nodes placed in the scene can have an instance of `SKPhysicsBody` set on them. This is an optional property &mdash; an `SKLabelNode` probably won't need it &mdash; but when we use it, [look out](https://giphy.com/embed/XpIsgXZJIzJDi).

Physics bodies are dynamic by default, meaning that Sprite Kit goes about applying, among many things, the force of gravity in the scene's `physicsWorld` to them.

We can influence the way our nodes react to these forces with [the properties we define on a node's `physicsBody`](https://developer.apple.com/documentation/spritekit/skphysicsbody) &mdash; including the overall form we initialize it with:

```swift
func makeBall(at position: CGPoint) -> SKNode {
    let ball = SKSpriteNode(imageNamed: "ballRed")
    let ballPhysicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)

    ballPhysicsBody.restitution = 0.4

    ball.physicsBody = ballPhysicsBody
    ball.position = position

    return ball
}
```

`circleOfRadius` is one of the _many_ arguments we could provide here. For more complex bodies, it seems like the `(texture:size:)` initializer would be handy. For circles, however, SpriteKit can spare the performance hit and use geometry instead 💯.


## 🔗 Additional/Related Links

- [SpriteKit Docs](https://developer.apple.com/documentation/spritekit)
- [Coordinate Systems Primer](https://www.cs.uic.edu/~jbell/CourseNotes/ComputerGraphics/Coordinates.html)
