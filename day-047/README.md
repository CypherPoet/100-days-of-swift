# Day 47: _Project 11: Pachinko_, Part Three

_Follow along at https://www.hackingwithswift.com/100/47_.


## 📒 Field Notes

> This day covers the third and final part of `Project 11: Pachinko` in _[Hacking with Swift](https://www.hackingwithswift.com/read/11)_.
>
> I have a [separate repository](https://github.com/CypherPoet/book--hacking-with-swift) where I've been creating projects alongside the material in the book. And you can find Project 11 [here](https://github.com/CypherPoet/book--hacking-with-swift/tree/master/11-pachinko/Pachinko). However, I also copied it over to Day 45's folder so I could extend from where I left off.
>
> With that in mind, Day 47 focuses on wrapping up the project, and then extending it according to a set of challenges.


### Special effects: SKEmitterNode

Not only is `SKEmitterNode` an incredibly powerful class for creating particle effects &mdash; having SpriteKit generate and manage a set of nodes that are emitted as "particles", often in enormous quantities at an equally large velocity &mdash; Xcode also gives us an incredibly powerful editing tool for creating these effects in `.sks` files. Fantastic 💥.


## 🥅 Challenges

### Challenge 1

> Our assets include other ball pictures rather than just “ballRed”. Try writing code to use a random ball color each time they tap the screen.

- 🔗 [Commit](https://github.com/CypherPoet/100-days-of-swift/commit/2e99155e1a1d3ffb2cd3cbdfec51d44207751690)


### Challenge 2

> Right now, users can tap anywhere to have a ball created there, which makes the game too easy. Try to force the Y value of new balls so they are near the top of the screen.

- 🔗 [Already Covered 🙂](https://github.com/CypherPoet/100-days-of-swift/blob/2e99155e1a1d3ffb2cd3cbdfec51d44207751690/day-045/project/Pachinko/Source/Scenes/Main/GameScene.swift#L76)


### Challenge 3

> Give players a limit of five balls, then remove obstacle boxes when they are hit. Can they clear all the pins with just five balls? You could make it so that landing on a green slot gets them an extra ball.

- 🔗 [Commit](https://github.com/CypherPoet/100-days-of-swift/commit/5ef33bad0e8f4c48f663620a108c03d9c9f19522)



## 📸 Screens

<div style="text-align: center;">
  <img src="./screenshot-1.png" width="80%"/>
  <img src="./screenshot-2.png" width="80%"/>
</div>


## 🔗 Additional/Related Links

- [SKEmitterNode Docs](https://developer.apple.com/documentation/spritekit/skemitternode)
