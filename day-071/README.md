# Day 71: _Project 20: Fireworks Night_, Part Two

This day covers the second and final part of `Project 20: Fireworks Night` in _[Hacking with Swift](https://www.hackingwithswift.com/read/20)_.
You can follow along directly [here](https://www.hackingwithswift.com/100/71).


## 📒 Field Notes

> I previously created projects alongside _Hacking with Swift_ in a [separate repository](https://github.com/CypherPoet/book--hacking-with-swift). For _100 Days of Swift_, however, I've been extending things further and adding my revised projects to this repo under each "Part One" folder.
>
> With that in mind, Day 71 focuses on using `SKEmitterNode` to trigger explosions. Then it finishes by extending the project with a set of challenges.


### Making Things Go Bang: `SKEmitterNode`

Because we're using the device's motion to explode fireworks, it's important for our game scene's view controller to be able to communicate with the game scene itself. By overriding its `motionBegan` hook we can do exactly that:

```swift
override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
    guard
        let spriteKitView = self.view as? SKView,
        let gameScene = spriteKitView.scene as? MainGameScene
    else {
        preconditionFailure("Failed to find SKView and MainGameScene")
    }

    gameScene.explodeSelectedFireworks()
}
```

`explodeSelectedFireworks`, then, lives in our `SKScene` class, and it handles updating the player's current score, finding each complete group of firework nodes with a rocket child node that was selected, and then running an explosion effect at its current position:

```swift
func explodeSelectedFireworks() {
    currentScore += pointsToAward
    selectedRockets.removeAll(keepingCapacity: true)

    for (index, firework) in fireworks.enumerated().reversed() {
        if firework.children.contains(where: { $0.name == NodeName.selectedFireworkRocket }) {
            fireworks.remove(at: index)
            explode(firework: firework)
        }
    }
}

func explode(firework: SKNode) {
    let emitter = SKEmitterNode(fileNamed: "explode")!

    emitter.position = firework.position
    addChild(emitter)
    firework.removeFromParent()
}
```

If I were doing this project again, I'd probably create models for each firework that contained logic for navigating its node structure and searching for selected rockets. That would prevent keeping loose arrays in the main game scene class and iterating through them in each of these functions. In any case, though, things are going 💥.


## 🥅 Challenges

### Challenge 1

> For an easy challenge try adding a score label that updates as the player’s score changes.

- 🔗 [Already Covered 🙂](https://github.com/CypherPoet/100-days-of-swift/blob/164cc35d8a660f039398aa7fd5fdf21c75e4f782/day-070/projects/Fireworks%20Night/Fireworks%20Night/Scenes/MainGameScene.swift#L28)


### Challenge 2

> Make the game end after a certain number of launches. You will need to use the invalidate() method of Timer to stop it from repeating.

- 🔗 [Commit](_General feedback and discussion for [Day 70](https://github.com/CypherPoet/100-days-of-swift/tree/master/day-070)._)


### Challenge 3

> Use the `waitForDuration` and `removeFromParent` actions in a sequence to make sure explosion particle emitters are removed from the game scene when they are finished.

- 🔗 [Commit](https://github.com/CypherPoet/100-days-of-swift/commit/5fb690d7263fded5eb74cb2ef77c5e8a2ef00044)
