# Day 7: Closures, Part 2

_Follow along at https://www.hackingwithswift.com/100/7_.

## 📒 Field Notes

### Defining closures as parameters when they accept parameters

Not to be confused with _calling_ closures with parameters, calling a function that _takes_ a closure as a parameter has an important distinction: We're still just defining the closure &mdash; we're not using it.

Crucially, this means that, when calling the standard function with a closure function, we can give our closure's parameters labels &mdash; because the standard function can only enforce types for the closure which is, itself, a type of its (the standard function's) parameter. 🤯

### Shorthand Parameter Names

Swift closures offer an... impressive degree of flexibility when passed to a function. Trailing return syntax is just the tip of the iceberg:

```swift

func attackEnemy(onHit: (Int) -> Void) {
    let didHit = Int.random(in: 0...1) % 2 == 0

    if didHit {
        let damageDone = Int.random(in: 0...100)

        onHit(damageDone)
    } else {
        print("Missed!")
    }
}


// Full Syntax
attackEnemy(onHit: { (damageDone: Int) -> Void in
    print("We did \(String(damageDone)) damage points!")
})


// Omit Return Type
attackEnemy(onHit: { (damageDone: Int) in
    print("We did \(String(damageDone)) damage points!")
})


// Omit parameter label
attackEnemy { (damageDone) -> Void in
    print("We did \(String(damageDone)) damage points!")
}


// Omit parameter label and parentheses
attackEnemy { damageDone -> Void in
    print("We did \(String(damageDone)) damage points!")
}

// Omit parameter label and parentheses, and return type
attackEnemy { damageDone in
    print("We did \(String(damageDone)) damage points!")
}

// Trailing return syntax, complete omission of function signature
attackEnemy {
    print("We did \(String($0)) damage points!")
}

```

Essentially, there's a spectrum of brevity here. In some cases, it's handy to use every shorthand possible. But I can also see that making code unnecessarily opaque at times. Sometimes, reading the code, I _want_ to know &mdash; I _value_ knowing &mdash; that this is the `onHit` callback.

A more realistic example of this, in my opinion, is using `UIView.animate`:

```swift
UIView.animate(
  withDuration: 0.25,
  delay: 0.2,
  options: [.autoreverse, .curveEaseOut],
  animations: {
    self.submitButton.layer.opacity = 0
  },
  completion: {
    self.triggerSubmissionSound()
  }
)
```

Here, in a function that's already taking 4 other parameters, I don't really mind seeing the 5th. And in fact, I find it much more useful to be explicit that this is the `completion` handler as opposed to... say... the `animations` closure right above it &mdash; or who knows what else.


### Capturing Values

If I had to use one word to describe closures, it's "capture". (Fortunately, thuogh, I don't have to use one word, because closures are tricky enough to grasp with an entire vocabulary.)

Closures allow us to capture state from an outer context, bundle it up inside of a function, and then pass that function off to some other context that will handle calling it later. This as an incredibly powerful concept, and it's no surprise to see closures appears all over the place in Swift given its many patterns concerning delegation, multithreading, event handling, functional programming, and more.

Another concept they enable is generators. In this simple example from [_Hacking with Swift_](https://www.hackingwithswift.com/sixty/6/11/capturing-values)...

```swift
func travel() -> (String) -> Void {
    var counter = 1

    return {
        print("\(counter). I'm going to \($0)")
        counter += 1
    }
}
```

...`travel` essentially _generates_ some state, which the closure it returns has captured and now gets to operate on whenever it's called.


## 🔗 Related Links

- [Official Swift Language Guide on Closures](https://docs.swift.org/swift-book/LanguageGuide/Closures.html)
