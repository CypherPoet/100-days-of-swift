# Day 55: _Project 14: Whack-a-Penguin_, Part One

_Follow along at https://www.hackingwithswift.com/100/55_.


## 📒 Field Notes

> This day covers the first part of `Project 14: Whack-a-Penguin` in _[Hacking with Swift](https://www.hackingwithswift.com/read/14)_.
>
> I previously created projects alongside _Hacking with Swift_ in a [separate repository](https://github.com/CypherPoet/book--hacking-with-swift), and you can find Project 14 [here](https://github.com/CypherPoet/book--hacking-with-swift/tree/master/14-whack-a-penguin/Whack%20a%20Penguin). Even better, though, I copied it over to Day 55's folder so I could extend it for _100 Days of Swift_.
>
> With that in mind, Day 55 focuses on several specific topics:
>
> - Getting up and running: SKCropNode
> - Showing penguins with SKAction moveBy(x:y:duration:)


### Getting up and running: SKCropNode

Similar to the way we might subclass `UIView` to encapsulate the rendering logic of a complex UI element, it's beneficial for us to subclass `SKNode` to encapsulate a `WhackSlot` &mdash; a hole at a specific position that animates a penguin in to and out of view.

This class handles a number of things &mdash; animating showing and hiding, rendering a "good" or "evil" texture. But perhaps most notable is its usage `SKCropNode`. As [described by the SpriteKit documentation](https://developer.apple.com/documentation/spritekit/skcropnode), this allows us to hide object behind a "mask" where the masks pixels have a low alpha value:

```swift
let cropNode = SKCropNode()

cropNode.position = CGPoint(x: 0, y: 15)
cropNode.zPosition = 1
cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")

penguinNode.position = CGPoint(x: 0, y: -penguinNode.size.height * 1.1)

cropNode.addChild(penguinNode)
```


### Showing Penguins with SKAction moveBy(x:y:duration:)

`SKNode`s have a `run` method that takes an `SKAction`, which SpriteKit uses to apply transformations in a smooth, animated way, over a specified duration.

All of this means that with our `WhackSlot` class, we can have fine-grained control over the way each penguin moves in and out of view.

`SKAction` also has its own static `run` method, which executes a closure. This means we can integrate our own operations straight into the sequence of actions being performed, and compose actions like this:

```swift
extension WhackSlot {

    var showAction: SKAction {
        return SKAction.moveBy(x: 0, y: 80, duration: 0.05)
    }

    var hideActions: SKAction {
        return SKAction.group([
            SKAction.moveBy(x: 0, y: -80, duration: 0.05),
            SKAction.scale(to: 0.08, duration: 0.025),
            SKAction.run { [weak self] in
                self?.isShowingPenguin = false
            },
        ])
    }
}

```



## 🔗 Additional/Related Links

- [More Apple guides on cropping nodes](https://developer.apple.com/documentation/spritekit/skcropnode/cropping_nodes)
