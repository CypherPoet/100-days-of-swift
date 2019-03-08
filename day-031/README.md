# Day 31: Project 6, Part Two

_Follow along at https://www.hackingwithswift.com/100/31_.


## 📒 Field Notes

This day covers the second and final part of `Project 6: Auto Layout` in _[Hacking with Swift](https://www.hackingwithswift.com/read/6)_.

> I have a [separate repository](https://github.com/CypherPoet/book--hacking-with-swift) where I've been creating projects alongside the material in the book. And you can find Project 6 [here](https://github.com/CypherPoet/book--hacking-with-swift/tree/master/06-auto-layout). However, I also copied it over to Day 30's and began extending it from where I left off.

With that in mind, Day 31 focuses on several specific topics, followed by some challenges:

- Auto Layout metrics and priorities: constraints(withVisualFormat:)
- Auto Layout anchors


### Auto Layout metrics and priorities: constraints(withVisualFormat:)

I hinted at it in [Day 30](../day-030/README.md), but metrics and priorities allow us to give our VFL strings more information density, making them more maintainable and, often, more readable at the same time:

```swift
let metrics = ["labelHeight": 88]

let layoutString = V:|[label1(labelHeight@999)]|
```

Even better, when we want to reuse a specific combination of metrics and priorities, we can reference the key name of the original element using it:

```swift
let metrics = ["labelHeight": 88]

let layoutString = "[label1(labelHeight@999)]-[label2(label1)]-[label3(label1)]-[label4(label1)]-[label5(label1)]"
```

Ultimately, it's all the same to `NSLayoutConstraint.constraints(withVisualFormat:)` &mdash; but that's beside the point 😀.


### Auto Layout anchors

As a language nerd, I can't help but like VFL. But it has to be practical if I'm going to use it. For intricate, uncommon designs, VFL may well be the right tool, but often, we'll be better off [leveraging the anchors that belong to `UIView`](https://developer.apple.com/documentation/uikit/nslayoutanchor).


The have a nice functional, declarative interface for setting constraints, and we can even reference other anchors:

```swift
for label in labels {
    label.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    label.heightAnchor.constraint(equalToConstant: 88).isActive = true
}
```

## 🥅 Challenges


### Challenge 1

>


## 🔗 Additional/Related Links

- [The.Swift.Dev.: Mastering iOS auto layout anchors programmatically from Swift](https://theswiftdev.com/2018/06/14/mastering-ios-auto-layout-anchors-programmatically-from-swift/)
