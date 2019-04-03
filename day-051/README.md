# Day 51: Conference Talks and Functional Programming

_Follow along at https://www.hackingwithswift.com/100/51_.


## 📒 Field Notes

This day served as a deviation from the _Hacking with Swift_ projects and instead involved watching two recent Paul Hudson conference talks:

- ["Elements of Functional Programming" from dotSwift 2018](https://www.youtube.com/watch?v=OgU8d_E1K14)
- ["Teaching Swift at Scale" from NSSpain 2018](https://vimeo.com/291590798)

Interestingly, while I'd already watched both of these videos a few months ago, after _re-watching_ them now (having been developing/learning/experimenting with Swift and Apple development since) I was much more familiar with a lot of the material and able to relate to it in ways previously impossible. The learning process is a beautiful thing 🙂.


### "Elements of Functional Programming" from dotSwift 2018

Pure functions, avoiding side-effects, composability, declarativeness... these are just a few things that come to mind when I think of functional programming, and the talk covers them quite well.

Having experience with functional programming in several other languages, I'm glad to see it being emphasized &mdash; seemingly at a growing rate &mdash; in Swift. It's _especially_ nice that one can write functional Swift, but then still switch to using classes, structs, protocols, and other object-oriented patterns without skipping a beat.

And Swift doesn't skimp on features. One particular functional method that goes beyond the standard `map`, `filter`, `reduce` transformations is `flatMap`. `flatMap` is like a nesting-conscious map. It will run a transformation on a sequence, and return a flattened sequence where a simple `map` would have included nested sequences:

```swift
let items = [1, 1, 2, 3, 5, 8]

items.map { Array(repeating: $0, count: 2) }

// > [[1, 1], [1, 1], [2, 2], [3, 3], [5, 5], [8, 8]]


items.flatMap { Array(repeating: $0, count: 2) }

// > [1, 1, 1, 1, 2, 2, 3, 3, 5, 5, 8, 8]
```

A close relative of `flatMap` that's particularly... well... Swifty is `compactMap`. `compactMap` is essentially an Optional-aware `map` &mdash; a `mao` post-processor, if you will &mdash; that takes the values returned by `map`ing, unwraps any optionals, and removes any values that might be `nil`.

```swift
let items2 = [1, 1, 2, Optional(3), nil]

print(items2.compactMap { $0 })

// > [1, 1, 2, 3]
```


### "Teaching Swift at Scale" from NSSpain 2018

While this talk touched on Paul's experience with teaching Swift and the challenges many people encounter while learning it, I found it highly relatable as a member of the latter crowd.

There's plenty of good insight in here on the areas where best practices &mdash; and community awareness of them &mdash; can be improved. In my opinion, many of these challenges are the nature of a young, constantly evolving, thriving language: Which architecture patterns, libraries, and APIs apply to which problems, functionalities and user experiences?

Despite a fair amount of (light-hearted) jabbing, I think there's an important bigger picture to take away about how far Swift and iOS has come in such a short time.


## 🔗 Additional/Related Links

- [Apple Documentation on `flatMap`](https://developer.apple.com/documentation/swift/sequence/2905332-flatmap)
- [Apple Documentation on `compactMap`](https://developer.apple.com/documentation/swift/sequence/2950916-compactmap)
