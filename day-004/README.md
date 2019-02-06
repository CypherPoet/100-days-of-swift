# Day 4: Loops

## 📒 Field Notes

### For Loops

Swift for loops are either range-based or collection-based, but they
involve the same "for-in" syntactic approach:

```swift
for i in 1 ... 10 {
  // do something
}

for item in items {
  // do something
}
```

Some languages, `C++`, also use a three-expression for loop:

```cpp
for (i = 1; i <= 10; i++)
```

But I like how Swift seems to have made a deliberate decision to keeping for-loops streamlined and consistent. If we absolutely _need_ an index and an item at the same time, we can always use `enumerated` on the collection being iterated over:

```swift
for (index, score) in scores.enumerated() {
  print("Score \(index): \(score)")
}
```

### While & Repeat-While Loops

I find that I use these much less frequently, but there's also no reason not to support them!

I like how Swift uses `repeat` in place of where many languages use `do`. It's more informative to what's actually happening _while_ we're here &mdash; and it allows `do` to be used for "try blocks", where `do` and `catch` are the outer constructs:


### Exiting loops

Using `break` or `continue` within a single loop is pretty straightforward. Things get tricky when it comes to nested loops, though, because `break`ing only applies to a single layer (or "block"/"level"/etc).

Enter labeled statements.

Swift [isn't the only language to use these](https://codeburst.io/javascript-the-label-statement-a391cef4c556), but to be picky briefly, this is where not having to wrap the conditional statement itself in parentheses gives Swift an edge in cleanliness.


```swift
deepNesting: for planet in planets {
    print("Passing through \(planet)")

    numbers: for i in 1...10 {
        if i == 3 { break numbers }
        print("Inside of `numbers` loop")
    }

    spaceDust: for i in 1...3 {
        print("Moving through space dust")
        asteroids: for j in 1...3 {
            print("Saw an asteroid")

            if i == 2 { break spaceDust }
        }

        if i == 2 { break }
        if i == 333 { break deepNesting }
    }
}
```

Anyway, while rare, this is a handy way to write cleaner code in situations where, given the nature of deep nesting, we're likely to need all the help we can get. (Whether or not it's a code smell to be there in the first place... that's another matter 🙂.)


### Infinite Loops

```swift
print("Infinite loops can be powerful")

while true {
  print("and dangerous!")
}
```


## 🔗 Related Links

- [For loop, for each, while, and repeat. Iterating in Swift](https://www.avanderlee.com/swift/loops-swift/)
- [Swift Labeled Statements](https://medium.com/@rwgrier/swift-labeled-statements-3624ff30e0e7)
