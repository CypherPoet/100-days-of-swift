# Day 1: Variables, Simple Data Types, and String Interpolation

_Follow along at https://www.hackingwithswift.com/100/1_

## 📒 Field Notes

### Variables

Swift variables are initialized with `var` and hold a value. Pretty straightforward.
But to me, it's useful to know how the language handles mutablity and type inference.

Variables can have their value changed at any later point, as long as the value is of the same type, and they can even be declared without a value so long as we're explicit about the type:

```swift
var name: String
var age = 0

name = "Brian"
name = "Roger"

age = 10
age += 1
```

 _Constants_, on the other hand cannot be changed later. To distinguish them from variables, constants are initialized with the `let` keyword.

 While it might seem trivial, this separation is tremendously useful. It allows our code to convey more information about how we intend to use each value. We can "let" things be constant by default, and conservatively use `var` when needed &mdash; specifically because the value held by this variable will be changed later on.

### Type Inference

Type inference can be explicit or left up the compiler. I like this because it offers the flexibility of being explicit when you need to, being implicit otherwise &mdash; and knowing that the compiler has your back in either case.

### Doubles vs Ints

Doubles and Ints can be mixed in an expression when they're raw values.
The Int will be "upcasted" to avoid information loss:

```swift
print(993.1 + 1)  // prints 994.1
```

Mixing types in an expression won't work with variables or constants, however:
```swift

let pi = 3.141592653589793
let oneHundred = 100

var price = 100.0
var shares = 22

print(pi + oneHundred)  // error
print(price * shares)   // error
```

### Booleans

Conditional if/else statements have to use actual Booleans, as does the initialization of Booleans. You can take your unnecessary ambiguity and "truthiness" elsewhere 😛.


## 🔗 Related Links

- [Boolean Algebra](https://en.wikipedia.org/wiki/Boolean_algebra)
- [The history of George Boole, for whom Booleans are named](https://en.wikipedia.org/wiki/George_Boole)
- [A primer on raw strings &mdash; coming to Swift 5!](https://www.hackingwithswift.com/articles/162/how-to-use-raw-strings-in-swift)


