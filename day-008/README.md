# Day 8: Structs, Part One

_Follow along at https://www.hackingwithswift.com/100/8_

## 📒 Field Notes

### Structs are Value Types

Like classes and enums, structs are way to implement a custom type in Swift. Unlike classes, however, structs are passed around by copy (a new replication their value in memory) as opposed to by reference (a variable that links to the same value in memory).

This _can_ have important implications for performance (although Swift's "copy on write" behavior goes a long way to optimize things) &mdash; but it definitely has important implications for state mutation.

#### Classes vs Structs

There's no One Rule To Rule Them All in the matter of Class vs Struct, but the best summary I've found so far comes from [Ray Wenderlich's Swift Style Guide](https://github.com/raywenderlich/swift-style-guide#which-one-to-use), which suggests **preferring structs for object that don't have an intrinsic identity or a lifecycle**. A person would be a class; their birthdate would be a struct.

**📝Note:** I've only just begun to explore what appears to be a _very_ long-running debate/dilemma within the Swift Community. This [Stack Overflow thread](https://stackoverflow.com/questions/24232799/why-choose-struct-over-class) seems like a sufficiently deep rabbit hole, but right now, I'm going with Apple's [official docs](https://developer.apple.com/documentation/swift/choosing_between_structures_and_classes) while I try to acquire more knowledge, experience, and evidence going forward.


### Mutating Member Functions

Structs ultimately serves as "templates" or "prototypes" for instances, meaning we might want some instances to be mutable and others to be constants. To help the compiler (and fellow readers) out with signalling our intent, we can add the `mutating` attribute to any method that wishes to do so.

```swift
struct City {
    var name: String
    var population: Int

    mutating func grantEntry() -> Void {
        population += 1
    }
}
```

This allows us to create a `City` variable, and call `grantEntry` on it. Correspondingly, if we create a `City` constant, calling `grantEntry` will throw an error at compile time 👍.

Rounding out the safety benefits of `mutating`, Xcode will also throw a helpful error message if we
try to define a mutating function that _without_ the `mutating` keyword:

![](./images/bad-mutating-function.png)


## 🔗 Related Links

- [Apple's Swift Documentation: Choosing Between Structures and Classes](https://developer.apple.com/documentation/swift/choosing_between_structures_and_classes)
