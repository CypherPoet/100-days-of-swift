# Day 6: Closures, Part 1

## 📒 Field Notes

### Accepting Parameters

This caught me off guard. I initially expected a closure defined in the following way...

```swift
let greet = { (name: String) in
    print("👋 Hello, \(name)")
}
```

... to be called like this:

```swift
greet(name: "friend")
```

Alas, it appears that Swift closures can't be called with parameter labels. So we need to call it like this:

```swift
greet("friend")
```

There _has_ to be a reason for this, though I'm not exactly sure what it is at the moment. Perhaps it has something to
do with the compiler not being able to enforce the signature of an "anonymous" function from the caller's point of view? There could also be cases where code calling the closure can't &mdash; or shouldn't &mdash; know about parameter labels, which I can see being useful.


### Trailing Closure Syntax

Like closure syntax itself, _trailing_ closure syntax takes a bit of getting used to at first. But there's payoff. Callers have a clean, visible space to create block scopes &mdash; and we know that their not defining a new function because there's no `func` keyword:

```swift
func zap(response: () -> Void) {
    print("⚡️")
}

zap {
    print("Yo!")
}
```

Again, I'm impressed with how Swift finds ways to mix cleanliness with expressiveness. More importantly, though, this kind of syntax sets up Swift to be a great language for functional programming:

```swift
let scores = [2, 34, 4, 56, 1]

let doubledScores = scores.map { $0 * 2 }
```

👍


## 🔗 Related Links

- [Official Swift Language Guide on Closures](https://docs.swift.org/swift-book/LanguageGuide/Closures.html)

