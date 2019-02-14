# Day 12: Optionals

_Follow along at https://www.hackingwithswift.com/100/12_.


## 📒 Field Notes

After Tony Hoare invented null references in 1965, he would later refer to them as a "billion-dollar mistake". I disagree. The concept of something _not_ having a value can be just as important as the concept that it does. And in my opinion, good language design isn't about constraining _what_ a programmer can express so much as it's about constraining _how_ they express whatever they might be thinking.

"Nil", "null", "None"... these notions are unavoidable. It's up to the language to design a way to expose them.

Enter Swift optionals &mdash; a way of handling the inevitable, totally-non-optional concept of `nil` in an explicit, type-safe manner.


### Initializing Optionals

Because an optional value _contains_ `nil` in the absence of anything else, these two forms of initialization are equivalent.

```swift
var mass: Int? = nil

print(mass) // nil
```

```swift
var mass: Int?

print(mass) // nil
```

Things get interesting when an optional _does_ gain a value, though:

```swift
var mass: Int?

mass = 100

print(mass) // Optional(100)
```

If you're coming to Swift from a non-type-safe language where `null` or `nil` is tossed around glibly, this can be a lot to take at first sight. Do a bit of unwrapping, though, and you'll find that Swift's interface for interacting with optional values &mdash; and potentially, null references &mdash; is pretty sweet.


### Explicitly Unwrapping Optionals

#### If-let

```swift
func generateMass() -> Int? {
  ...
}

func displayMass() {
  if let mass = generateMass {
    // Do something with the unwrapped Int inside of `mass`
  } else {
    // Do something when `mass` is nil
  }
}
```

#### Guard Statements

```swift
func generateMass() -> Int? {
  ...
}

func displayMass() {
  guard let mass = generateMass else {
    // Do something when `mass` is nil before the the function exits entirely
  }

  // If we get here, `mass` is a first-class `Int` with a value
}
```

Guard statements are actually part of a larger paradigm: Running an expression **inline with the current block of scope**, and then exiting the block if it doesn't execute as expected.

This can be a _really_ clean way to flatten code that performs some initial checks in a function. I'm trying not to abuse it, though 🙂.

To me, `guard` has a special meaning &mdash; much closer to `assert`. It's an indicator that something generally _should_ be the case, otherwise we don't want to be in the function at all.

Conversely, with `if/else`, we're genuinely not sure what the case might be &mdash; but our function intends to handle it regardless.

Anyway, did I mention this was a larger topic? Onward!


### Force Unwrapping

By using `!` after an Optional variable, we're telling the language to use the value that it holds &mdash; or crash!. This is handy way to get around using `if/else` or `guard` when we have absolute certainty that an Optional hold a value. [But do we really](https://www.youtube.com/watch?v=bCY9L3Xidoo)? 😉


### Implicitly Unwrapped Optionals

Similar to force unwrapping, this applies to declarations that don't initialize a value (and are therefore `nil`). It can be thought of as a _guarantee_ to the complier that the variable will have a value by the time we need it.

```swift
var mass: Int! = nil  // "I promise not to use this until it has a value."
```

### Nil Coalescing

`??` lets use the value inside of an optional &mdash; or a default withing an expression.
This seems like somewhat of a cousin to the ternary conditional operator (`?`), which I often find myself using when the value corresponding to `false` is a fallback.


### Optional Chaining

This is a nice way to conduct chained property access when something along the way is an optional:

```swift
let nameLength = person.nickname?.count   // returns nil or `count` wrapped in an Optional
```

The only caveat, though, is that it still tries to unwrap the value used with `?` as an Optional &mdash; so I'd think of it as more of "safe access" than force unwrapping, which was my initial intuition.


### Failable Initializers

Failable initializers are basically a way to declare your _entire_ type as being an Optional. 🤔 I don't know... at that point it feels like we might _really_ need to start questioning our design. But I'm open to seeing some legitimate use cases if they exist.


## 🔗 Related Links

- [Tony Hoare, in retrospect, on Null References](https://www.infoq.com/presentations/Null-References-The-Billion-Dollar-Mistake-Tony-Hoare)
- More thoughts on when to use `guard`
    - https://www.natashatherobot.com/swift-when-to-use-guard-vs-if
    - https://medium.com/@chris_dus/the-guard-statement-in-swift-fdad41b08798
- [Swift Docs on Implicitly Unwrapped Optionals](https://docs.swift.org/swift-book/LanguageGuide/TheBasics.html#ID334)
