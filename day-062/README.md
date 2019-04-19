# Day 62: _Project 17: Space Race_, Part One

_Follow along at https://www.hackingwithswift.com/100/62_.


## 📒 Field Notes

> This day covers the first part of `Project 17: Space Race` in _[Hacking with Swift](https://www.hackingwithswift.com/read/17)_.
>
> I previously created projects alongside _Hacking with Swift_ in a [separate repository](https://github.com/CypherPoet/book--hacking-with-swift), and you can find Project 17 [here](https://github.com/CypherPoet/book--hacking-with-swift/tree/master/23-space-race). Even better, though, I copied it over to Day 62's folder so I could extend it for _100 Days of Swift_.
>
> With that in mind, Day 62 focuses on several specific topics:
>
> - Setting up our UI
> - Bring on the enemies: `linearDamping`, `angularDamping`
> - Making contact: `didBegin()`



### Setting up our UI

Wonderous as the universe itself, the power of SpriteKit allows us to create a "starfield" background with a small amount of clever configuration.

Given an emitter node that emits a horizontal stream of star-like particles, we can position the node in on the center-rightmost edge of the screen, set its `zPosition` to be behind everything else, and advance the node's simulation time so that it instantly renders as a full screen of stars ✨.

```swift
func makeStarfieldBackground() -> SKEmitterNode {
    guard let starfield = SKEmitterNode(fileNamed: "Starfield") else {
        preconditionFailure("Failed to starfield emitter effect")
    }

    starfield.position = CGPoint(x: frame.maxX, y: sceneCenterPoint.y)
    starfield.zPosition = -1

    // cause the particles to spread out over our background
    starfield.advanceSimulationTime(10)

    return starfield
}
```


### Bring on the Enemies: `linearDamping`, `angularDamping`

Space junk is dangerous. So the nodes that we're flying our ship through need to look the part: massive, twirling, and with no end in sight.

Two properties of SpriteKit nodes that come in handy here are `linearDamping` and `angularDamping`. By default, these will have values, because gravity serves as a dampener on both angular and linear momentum. To simulate the zero-gravity atmosphere of outer space, though, we can set them to 0 to keep them floating and spinning along smoothly.

```swift
@objc func spawnEnemy() {
    let enemyType = EnemyType.allCases.randomElement()!
    let enemy = SKSpriteNode(imageNamed: enemyType.rawValue)
    let enemyWidth = CGFloat(enemy.size.width)
    let enemyHeight = CGFloat(enemy.size.height)

    let xPos = frame.maxX + enemyWidth
    let yPos = CGFloat.random(in: enemyHeight...(frame.maxY - enemyHeight))

    enemy.position = CGPoint(x: xPos, y: yPos)

    enemy.physicsBody = SKPhysicsBody(texture: enemy.texture!, size: enemy.size)
    enemy.physicsBody?.categoryBitMask = BitMask.enemy
    enemy.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
    enemy.physicsBody?.angularDamping = 0
    enemy.physicsBody?.linearDamping = 0
    enemy.physicsBody?.angularVelocity = 5

    addChild(enemy)
}
```


### Making Contact: `didBegin()`

Since emitter nodes are one-and-done, we can take advantage of this to place an explosion _right_ at the position of the ship when we detect it colliding with an "enemy" &mdash; also utilizing `SKNode.removeFromParent` to vaporize our ship and the enemy at the same time:

```swift
func shipDestroyed(by enemy: SKNode) {
  guard let explosion = SKEmitterNode(fileNamed: "explosion") else {
      preconditionFailure("Failed to load explosion emitter effect")
  }

  explosion.position = playerShip.position

  remove(node: enemy)
  remove(node: playerShip)
  addChild(explosion)

  currentGameplayState = .over
}
```


## 🔗 Additional/Related Links

- Seriously... [space junk](https://www.nasa.gov/offices/nesc/articles/space-debris) [is dangerous](https://www.youtube.com/watch?v=vKW-Gd_S_xc)!
