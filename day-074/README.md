# Day 74: Milestone for Projects 19-21

_Follow along at https://www.hackingwithswift.com/100/74_.


## 📒 Field Notes

> This day resolves around recapping the content covered while going through Projects 19-21 in _[Hacking with Swift](https://www.hackingwithswift.com/read)_, and then implementing a challenge project.

Regarding the recap, I won't try to rehash what I wrote up already &mdash; but a few extra things are worth noting.


### for case let

Using `for case let` to iterate through an array is inescapably cool. A bit trippy at first &mdash; but grokable the more you being to [associating "case let" with "pattern-match and bind"](https://twitter.com/cypher_poet/status/1110149201407733760):


```swift
for case let label as UILabel in view.subviews {
    print("Found a label with text \(label.text)")
}
```

### Recoloring SpriteKit Nodes

Though it seems like minutiae, the `colorBlendFactor` of `SKNodes` is anything but. Setting it to `1` allows us to recolor `SKSpriteNodes` dynamically and performantly, which can be critical for certain scenarios.

```swift
firework.color = UIColor.cyan
firework.colorBlendFactor = 1
```

Naturally, since this is SpriteKit, we can even animate this kind of change:

```swift
let action = SKAction.colorize(with: UIColor.red, colorBlendFactor: 1, duration: 1)
```

Apple's docs have some solid leads with more information:

- [colorBlendFactor](https://developer.apple.com/documentation/spritekit/skspritenode/1519780-colorblendfactor)
- [Tinting a Sprite](https://developer.apple.com/documentation/spritekit/skspritenode/tinting_a_sprite)


## 🥅 Challenge Project

> Your challenge for this milestone is to use those API to imitate Apple as closely as you can: I’d like you to recreate the iOS Notes app.

So... Notes has grown up quite a bit since I'm thinking this challenge was conceived. Needless to say, it's a bit out of scope for how I'm trying to integrate _100 Days of Swift_ into my other projects 🙂.

In any case, I _did_ tackle this challenge to some extent when I originally went through _Hacking with Swift_. You can check out that code [here](https://github.com/CypherPoet/book--hacking-with-swift/tree/a749130cab59394d64ab649a331c54ce7b91ba64/challenges/apple-notes-imitation/Apple%20Notes%20Imitation). Though coincidentally, reading it now brings [this Tweet](https://twitter.com/cypher_poet/status/1132939910720233473) to mind 😛.
