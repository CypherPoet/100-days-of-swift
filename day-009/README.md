# Day 9: Structs, Part Two

_Follow along at https://www.hackingwithswift.com/100/9._


## 📒 Field Notes

### Initialzers

Initially, initializers for structs are handled by default: As long as parameters for every property are passed in to the constructor, Swift will run a _memberwise initializer_ that assigns those parameters to the instance's matching properties.

This is separate from classes, which don't have a default _memberwise initializer_. But we can still define our own if we want. This can be useful when we want to setup our own default for a property &mdash; while also alleviating caller from being concerned with setting it.


### Referring to the current instance

Anyone who's done object-oriented programming in other languages is likely familiar with this concept &mdash; and its various flavors of `self`, `this`, `@`, and I'm sure more.

While each language seems to have its own `self`-related nuances, `self` in Swift feels pretty well-thought out. It's not required &mdash; unless we're in a closure, or some block where a local variable has the same name as an instance member &mdash; so using it tactically can add more meaning to the code than using it everywhere. It's also not awkwardly, magically, implicitly crammed into to every method as the first argument &mdash; not that any language would ever do that, of course 😜.

Perhaps most importantly, though, it's the perfect word for what it is. I'll take `self` over `this` and `@` any day.


### Lazy properties

While I've known about the benefits of lazy initialization while programming in other languages, I never really found myself being as _mindful_ of it while defining structs/classes/objects as I do in Swift.

I'd like to think some of that is simply due to learning &mdash; but credit where it's due: Swift's `lazy` keyword is a beautiful example of how clean, straightforward, and seamless implementations can actively encourage better developer practices and ways of thinking.

### Static Properties

If you can think of a struct or a class definition as a _stamp_ &mdash; from which new instances are printed out &mdash; you can probably think of static properties as a part of the handle that always stays put.

This can be useful for sharing/managing state across all instances of a type &mdash; and then selectively providing access to it through instance methods.


### Access Control

Swift offers five levels of access control. From the official documentation:

- Open access
- Public access
- Internal access
- File-private access
- Private access

[The Swift documentation](https://docs.swift.org/swift-book/LanguageGuide/AccessControl.html) provides nice descriptions of each. On the whole, though, it seems both comprehensive _and_ clearly named 👍.


## 🔗 Related Links

- [The.Swift.Dev: Lazy initialization in Swift](https://theswiftdev.com/2018/12/17/lazy-initialization-in-swift/)
