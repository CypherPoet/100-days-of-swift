# Day 5: Functions

_Follow along at https://www.hackingwithswift.com/100/5_

## 📒 Field Notes

Syntactically, Swift's functions are a thing of beauty:

- `func` feels like a perfect combination of brevity (as opposed to `function`, like in JavaScript) and clarity (as opposed to `def`, like in Python and Elixir).
- Denoting the return type a la `-> String`  is drastically more sensible then declaring the return type out in front (like in C++) as if you were initializing a variable.
- "Internal" and "External" parameter names are 🔥. Anyone who's struggled in other languages to create a parameter name that reads well for both the caller, and in the implementation, knows this deeply.
- Named parameters are lovely in many ways. But in a compiled language like Swift, this goes very well with function overloading.
- The style of simplifying a function name and instead having the semantics carry through into the parameters
is so slick 😎
  + `print(name: String)` instead of `printName(name: String)`
  + `choose(fromNames: [String])` instead of `chooseFromNames(names: [String])`
  + I could do this forever 🙂.

The benefits of functions, functional programming &mdash; and keeping code modular, well-composed, constrained with concerns, etc &mdash; are all much larger topics. But to a large extent, it's the _feel_ of functions that will impact the way developers use them within a language. And Swift nails it.


### Variadic Functions

_Needing_ to use a variadic function tends to be a bit rare, but it's a handy ability to have &mdash; and I'm more
intrigued by how Swift designs what known in other languages as "parameter packing" or "gathering" (I'm sure I'm missing some other names). Ellipses at the end of the type seems like a clean way to do it 👌.


### Throwing Functions

It's tough at first to see something like `throws -> Bool` and not think that `Bool` refers to the error type. But it makes more sense when you realize that Swift doesn't have named error types 😛.


### inout Parameters

Immutability. Purity. Generally, this is what we want in a function. And Swift helps that greatly by having most types copied by value and making parameters constants by default.

With that, designing a syntax for bending those rules can be a bit of a challenge. `inout` is a bit vague at first, but it works. For callers, passing the variable with `&` is equally straightforward &mdash; and a nice homage to C++'s "reference" parameter syntax 😉.

There's a more important aspect of this, though. Similar to needing to explicitly use `fallthrough` in `switch` cases, I like Swift's approach of leading developers down a path of success &mdash; steering them towards expected behaviors. If you _really_ want a function to mutate your arguments, you have to be explicit in defining it that way &mdash; and asking for it.


## 🔗 Related Links

- [Official Swift Documentation on Error Handling](https://docs.swift.org/swift-book/LanguageGuide/ErrorHandling.html)
- [Reference vs. Value Types in Swift](https://www.raywenderlich.com/9481-reference-vs-value-types-in-swift)

