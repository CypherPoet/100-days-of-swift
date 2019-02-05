# Day 3: Operators and Conditions

## 📒 Field Notes

### Arithmetic Operators

Swift's arithmetic operators are pretty standard 👌. It's curious that there's no exponent operator, but there _is_ [a `pow` function in Foundation](https://developer.apple.com/documentation/foundation/1779833-pow), &mdash; so I'm all for just using that consistently.


### Operator Overloading

Operator overloading can be a hornet's nest in languages without type safety: Is `1 + "1"` supposed to be `2` or `11`? But this is one of the many ways in which type safety pays off in Swift. Arithmetic operators can't be overloaded for mixed types, but they _can_ be overloaded in many useful, **unambiguous** ways otherwise.

Especially the `+` operator:

```swift
let fibs = [1, 1, 2, 3, 5, 8]
let primes = [2, 3, 5, 7, 11]

print(fibs + primes) // [1, 1, 2, 3, 5, 8, 2, 3, 5, 7, 11]
print("Swift is" + " " + "awesome!")  // "Swift is awesome!"
```

### Compound Assignment Operators

No homage to `++`? Just kidding. `+= 1` FTW 😛.


### Comparison Operators

`onPoint == true`


### Conditionals

`if`, `if else`, `else`... if I'm missing anything else, please let me know. One notable distinction between Swift and some other languages is that the expression of a conditional doesn't need to be wrapped in parentheses. 👍


### Combining Conditions

"And" (`&&`) and "or" (`||`). Right on. It's neat how some languages leverage `and` and `or` directly as conditional keywords, but I can go either way. These symbols are pretty universal &mdash; perhaps more so than English for some.


### Ternaries

People seem pretty divided about ternaries. Do they make code cleaner, or more confusing?

Personally, I find ternaries to be lovely, and useful... when they're not abused. It mainly depends on whether making a given part of the code more compact would help or hurt readability. Overall, I'm glad they're in the language.

```swift
let opinion = fitsOnALine ? "quite pleasing" : "a bit sloppy"

if youCanBeSuccinct {
  print("Go ahead and use a ternary. They're \(opinion) -- and even help readability.")
} else {
  print("If/else blocks tend to make things more clear.")
}
```


### Switch Statements

Swift's switch statements are some of the most powerful and expressive I've seen in any language. In addition to direct value cases, the ability to use range cases and even `where` expressions is
straight 🔥.

```swift
enum Planet: String {
    case mercury, venus, earth, mars, jupiter, saturn, neptune, uranus
}

let planet = Planet.jupiter

switch planet {
case _ where [.mercury, .venus].contains(planet):
    print("Close to the sun")
case _ where [.earth, .mars].contains(planet):
    print("Habitable zone")
default:
    print("Spaceman")
}
```

```swift
let steaks = 1

switch steaks {
case Int.min...0:
    print("Vegan mode")
case 0..<12:
    print("Less than a dozen")
case 12:
    print("Dozen")
case 12...Int.max:
    print("That's a lot of steak")
default:
    print("Where's the beef?")
}

```

And this is before considering how falling through is opt-in (via the `fallthrough` keyword)!

Seriously, coming from several languages where `case` blocks fall through by default, this is extraordinary 😂. Swift took an implicit behavior that's resulted in untold amounts of bugs and side-effects &mdash; and has led some to view switch statements as outright anti-patterns &mdash; and stopped it cold. If you want to fall through, you need to say so — you need to know what you’re asking for.


### Ranges

Ranges are a concept I first fell in love with in Python, and they immediately become handy in Swift.

The syntax is a bit odd at first, compared to a `range` function, but it grows on you quickly. Also, being able to encode the concept of openness by switching the last character to a `<` (which creates a "half-open" range) is a clever little design trick. Well done 🙂.



## 🔗 Related Links

- [John Sundell on the power of switch statements in Swift](https://www.swiftbysundell.com/posts/the-power-of-switch-statements-in-swift)
