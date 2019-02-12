# Day 10: Classes

_Follow along at https://www.hackingwithswift.com/100/10_.


## 📒 Field Notes

### Initialization

No default memberwise initializers here. Classes require us to implement `init` on
our own. Perhaps that's a nod to the fact that they're a bit more... special... and we need to be more meticulous in their creation? That would seem reasonable &mdash; particularly as inheritance starts getting involved.


### Classes are Reference Types

I wrote more about it in [Day 8](../day-008/README.md), but this is a vital distinction between classes and structs, so it's worth pointing out again:

**Struct instances are passed by value copy:**

```swift
struct Player {
  var name: String
}

var player1 = Player(name: "CypherPoet")
var anotherPlayer = player1

anotherPlayer.name = "Thief"

print(player1.name) // "CypherPoet"
```

**Class instances are passed by reference:**
```swift

class Player {
  var name: String

  init(name: String) {
    self.name = name
  }
}

var player1 = Player(name: "CypherPoet")
var anotherPlayer = player1

anotherPlayer.name = "Thief"

print(player1.name) // "Thief"
```


### Inheritance

While I'm generally on the side of "composition over inheritance", the latter has its uses. And frankly, I'm glad that Swift doesn't shy away from enabling it. I've always preferred languages that allow for developing in an OO _or_ functional way, depending on the circumstances, and the more I'm learning about Swift's features regarding both, the more I'm impressed.

.... As long as we can all agree not to use inheritance too much 😛.


### Marking classes as Final

Because inheritance can be a slippery slope.


#### ⚠️ Potential Gotcha While Inheriting `init`

Something I noticed while playing around with initializer inheritance: `super.init()` should generally be performed last. This is because Swift wants make sure all of the new properties introduced by the child class are initialized before delegating back up to the parent. (This [Stack Overflow thread](https://stackoverflow.com/questions/24021093/error-in-swift-class-property-not-initialized-at-super-init-call) provides more details.)

```swift
class Archer: Player {
    var arrows: Int

    init(name: String, arrows: Int) {
        self.arrows = arrows

        super.init(name: name)
    }
}
```

Fortunately, though, Xcode will be sure to warn about this sort of thing right away. Compile-time master race.


### Deinitialization

Another thing that helps to distinguish classes from structs: lifecycle management. Just as we can (and, indeed, must) control a class instance's setup, we can also handle it's teardown with an optional `deinit` hook:

```swift
class Player {
    deinit {
        print("😵")
    }
}
```

`deinit` can give us a hook into the way Swift handles memory management of instances through [automatic reference counting](https://docs.swift.org/swift-book/LanguageGuide/AutomaticReferenceCounting.html):

```swift
for _ in 1...3 {
    Player()
}

// "😵" printed 3 times
```

It will also run whenever we manually set an instance to `nil`:
```swift
var ghost: Player? = Player()
ghost = nil

// "😵" printed again

```


### Mutation

Classes trade the `mutating` keyword used by structs for indicating the _ability_ to mutate a member via `var` and `let`. Seems pretty sane 👍.


## 🔗 Related Links

- [Swift Guides on Initialization](https://docs.swift.org/swift-book/LanguageGuide/Inheritance.html)
- [Swift Guides on Deinitialization](https://docs.swift.org/swift-book/LanguageGuide/Deinitialization.html)

