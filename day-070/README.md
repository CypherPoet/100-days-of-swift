# Day 70: _Project 20: Fireworks Night_, Part One

This day covers the first part of `Project 20: Fireworks Night` in _[Hacking with Swift](https://www.hackingwithswift.com/read/20)_.
You can follow along directly [here](https://www.hackingwithswift.com/100/70).


## 📒 Field Notes

> I previously created projects alongside _Hacking with Swift_ in a [separate repository](https://github.com/CypherPoet/book--hacking-with-swift). For _100 Days of Swift_, however, I've been extending things further and adding my revised projects to this repo under each "Part One" folder.
>
> With that in mind, Day 70 focuses on several specific topics:
>
> - Ready... aim... fire: `Timer` and `SKAction.follow()`
> - Swipe to select



### `Timer` and `SKAction.follow()`

Similar to the way we might spawn enemies in a game, we can also configure a timer to "spawn" rockets &mdash; calling a function that generates a random launch configuration on each loop.

```swift
func setupTimer() {
    gameTimer = Timer.scheduledTimer(
        timeInterval: fireworkInterval,
        target: self,
        selector: #selector(launchFireworks),
        userInfo: nil,
        repeats: true
    )
}
```

Nifty 🚀.


One thing I found challenging was devising a clean structure for these random configurations. It shouldn't be necessary to write out massive lists of hand-picked starting points and x-and-y-movements.

So I decided to organize each launch style as an enum, switch on a random case, then call a specialized method for each launch style:

```swift
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
```

```swift
func launchLeftToRight(numFireworks: Int, spacingIncrement: CGFloat) {
    let startY = frame.midY - CGFloat(spacingIncrement * floor(CGFloat(numFireworks) / 2))

    for n in 0 ..< numFireworks {
        let yPosition = startY + (CGFloat(n) * spacingIncrement)
        let xMovement = frame.maxX * 1.5

        createLaunch(xMovement: xMovement, xPos: frame.minX - launchEdgeOffset, yPos: yPosition)
    }
}
```

The `createLaunch` method is its own awesomeness as it attaches a motion action to the firework node that lets it move along a `UIBezierPath`. I can instantly see about a million different use cases for this, but for now, it gets our rockets launching onwards and upwards 🚀🚀🚀.


### Swipe to select

Our goal is to have the user touch all rockets _of a single color_ and then shake the device to detonate them. This means that in both `touchesBegan` (for individual presses) and `touchesMoved` (for swiping), we need to be calling some kind of method that can track all touched rockets of a single color. We'll also be turning them white to indicate a selected rocket to the user.

```swift
override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)

    guard let touch = touches.first else { return }
    handleTouch(touch)
}
```


```swift
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
```

This is where the beauty of `for case let` really makes itself apparent. In a single statement, we can setup a loop that matches on `SKSpriteNode`s only, and initialize a `touchedNode` value for us to use inside of the loop. From there, all we need to do is check its `name` to see if it's a firework node, and if so, we can dig a bit deeper into our selection logic.
