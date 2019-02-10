# Day 2: Complex Data Types

_Follow along at https://www.hackingwithswift.com/100/2_

## 📒 Field Notes

### Arrays

Swift arrays should be pretty intuitive to anyone who's used arrays in other languages. They're indexable, appendable, insert-at-able, etc. And the support a long-list of functions for operations like splitting, counting, mapping, filtering, and finding the index of an element.

A few structural points are important to note:
  - Arrays are defined by the type of their element. That is an array of Strings (`[String]`),
  is a different type than an array of Ints (`[Ints]`).
  - Naturally, this means that arrays can't have mixed-type elements. (Fortunately, though, Swift tuples can be used for that 🙂.)


### Sets

Sets are a really cool mathematical construct, and it's nice to see first-class
support for them in Swift.

Key things to note:
  - The order in which the items are stored is not guaranteed. This is more memory-efficient under the hood &mdash; but it also means the set can't be indexed like an array.

  - Items must be unique. Even trying to initialize a set with duplicate values will
  produce a _deduped_ set:

    ```swift
    var characters = Set(["Ezio", "Altair", "Bayek", "Desomond", "Evie", "Bayek"])

    // initializes the Set<String> of ["Ezio", "Bayek", "Desomond", "Altair", "Evie"]
    ```

  Because order isn't guaranteed, insertion is a very general concept. There's no
  "appending", "prepending", or "inserting-at"... you're just tossing another item
  into the collection:

  ```swift
  characters.insert("Kassandra")
  ```

### Tuples

From a design perspective, tuples are a hardcore example of creating constrained interfaces.
You want to mix types in a collection? Fine... here you go. But that's it. To support these shenanigans, tuples don't allow items to added or removed, and they don't provide the functional utilities that arrays do (e.g., `map`, `filter`, `slice`).

Tuples can be created with or without keys:

```swift
var grabBag = (4, "🦄", [23, 11, 4], 99.3, Character("a"))
var response = (status: 201, message: "Created a new 🦄")
```

Elements in the key-less version can be accessed using 0-based positions:

```swift
grabBag.0
```

Elements in the keyed version can be accessed using 0-based positions _or_ keys:

```swift
response.0 == response.status  // true
```

Despite their constraints, one thing we _can_ still get away with, is changing an item in a tuple when the new value has the same type:

```swift
var grabBag = (4, "🦄⚡️", [23, 11, 4], 99.3, Character("a"))

grabBag.0 = 44
```

All things considered, though, The more I'm learning about what they enable in Swift, the more I'm seeing the beauty in tuples's constraints. Essentially, they allow us to "freeze" a signature at compile time: Once a `(Int, String, String, Int)`, always a `(Int, String, String, Int)`. And this will doubtless come in handy later when we get to [multiple-return functions](https://docs.swift.org/swift-book/LanguageGuide/Functions.html#ID164).


### Dictionaries

In light of tuples and arrays, Swift dictionaries feel like a hybrid of the two. In some sense, they can be thought of as a list of key-value pairs.

Types can be anything:

```swift
// key's can be of any type
var primeFactors = [
    9: [3, 3],
    12: [2, 2, 3],
    99: [3, 3, 11]
]
```

Really:

```swift
var insaneDictionary = [
    ["A", "B", "C"]: [[12: "Foo"]: 33],
    ["D", "E", "F"]: [[91: "Bar"]: 103]
]
```

But they also need to be consistent:

```swift
// won't compile
var primeFactors = [
    9: [3, 3],
    12: "2, 3, 3"
]
```

Interestingly, reading from dictionaries produces an Optional:

```swift
var scoreData = [
    "Brian": 9,
]

scoreData["Brian"]   // Optional(9)
scoreData["Alex"]   // nil
```

However, we can guarantee a value by specifying a default:
```swift
scoreData["Brian", default: 100]  // 9
scoreData["Alex", default: 100]  // 100
```

I like how Swift doesn't try to futz with using curly braces (`{}`) for dictionary expressions. Curly braces are for blocks &mdash; contexts &mdash; and it's nice to preserve that meaning. The "array of
key-value pairs" aesthetic takes a bit of getting used to coming from languages like Python and JavaScript &mdash; but not that much 🙂.


### Initializing Empty Collections

Types matter. And so do type signatures when it comes to initializing empty collections.

```swift
var names = [String]()
var scores = [String: Int]()

names.append("Alex")
scores[names[0]] = 33
```

Sets have to use the "official", angle-bracket-based type signature:

```swift
var items = Set<String>()

items.insert("Computer")
```

But this can be use for arrays and dictionaries, too if desired:

```swift
var oldSchoolArray = Array<Int>()
var atomicNumbers = Dictionary<String, Int>()

atomicNumbers["Xe"] = 54
```

I like how arrays and dictionaries have the extra sugar. I'm not sure how that evolved, but I'll take it. I can see how different contexts would lend them selves to different styles, and it's useful to have a signature like `[String]` that's closer to the actual structure.


### Enumerations

Languages either seem to have enumerations, or myriad strategies of simulating them with things like macros or modules that export constants. So yeah... I'm glad too see `enum` in Swift.

Enums offer a good way to model a type of values in more structured, organized, and consistent way.
Swift gets extra points for allowing us to elide the `enum` name itself when it can already be guaranteed at compile time:

```swift
enum StatusCode {
  case success
  case error
}

let myStatus: StatusCode = .success
```


## 🔗 Related Links

- [Khan Academy videos on sets](https://www.khanacademy.org/math/statistics-probability/probability-library#basic-set-ops)
- [Tuples vs Sets](https://en.wikipedia.org/wiki/Tuple#Properties)
