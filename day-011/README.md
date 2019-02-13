# Day 11: Protocols and Extensions

_Follow along at https://www.hackingwithswift.com/100/11_.


## 📒 Field Notes

Protocol Oriented Programming is Swift's answer to ["prefer composition over inheritance"](https://en.wikipedia.org/wiki/Composition_over_inheritance).

A lot of this seems due to their usage pattern: While classes can only inherit from one parent at a time, multiple protocols can be applied to a type at once &mdash; and protocols themselves can even inherit from other protocols when they're defined.

The effect is that complex inheritance can be designed at the protocol level, and **type implementors can precisely choose which protocols they want to conforms to**, rather than worrying about where to fit in on some inheritance chain so the universe doesn't implode. Powerful stuff 💥.


### Protocol Inheritance

As alluded to above, _this_ is where we can get really crazy with inheritance when designing abstract types. The ability for protocols to inherit other protocols &mdash; several at a time &mdash; gives us a tremendous amount of power to create compound protocols:

```swift
protocol Atomic {
    var atomicNumber: Int { get set }
}

protocol Symbolized {
    var symbol: String { get set }
}

protocol PeriodicElement: Atomic, Symbolized {
    var name: String { get set }

    func displaySymbol() -> Void
}
```

Then, by the time we get to our actual type definition, we can just focus on a single concept:

```swift
struct Xenon: PeriodicElement {
    var name = "Xenon"
    var symbol = "Xe"
    var atomicNumber = 54

    func displaySymbol() -> Void {
        print("\(name): \(symbol)")
    }
}
```

(This is super cool from the standpoint of language design &mdash; but it's also neat from the standpoint of architecture, philosophy, and logical thinking. You can begin to see how protocols are essentially a way of encapsulating concepts, clusters of concepts, and before you know it, the DNA of the entire universe 🤯.)


### Extensions

Extensions seem to be a more... direct... cousin of protocols. They operate directly _on_ types &mdash; more like mix-ins &mdash; as opposed to being type agnostic interface requirements.

... Which is cool because it basically means that the confines of our application are a Swifty sandbox. Even protocols can be extended! This is a powerful way of giving them default implementations (since we can't implement code directly _in_ a protocol), and it encompasses a pattern of programming known as **Protocol-oriented programming**.


## 🔗 Related Links

- [Talk from WWDC 2015: "Protocol-Oriented Programming in Swift"](https://developer.apple.com/videos/play/wwdc2015/408/)
