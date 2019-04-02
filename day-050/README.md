# Day 50: Milestone for Projects 10-12

_Follow along at https://www.hackingwithswift.com/100/50_.


## 📒 Field Notes

This day resolves around recapping the content covered while going through Projects 10-12 in _[Hacking with Swift](https://www.hackingwithswift.com/read)_, and then implementing a challenge project. Regarding the recap, I won't try to rehash what I wrote up already &mdash; but a few extra things are worth noting.


### `touchesBegan`

- When `touchesBegan` is called in a SpriteKit `GameScene`, it has the following signature:

```swift
func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
```

The `touches` set is guaranteed to contain at least one touch, so we can use implicit unwrapping of `Array.first` without much concern:


```swift
let touch = touches.first!
```

### UserDefaults and type safety

While `UserDefaults` provides a type-safe getters for "simple" types &mdash; and even an array of strings &mdash; getting more complex objects is a different story.

```swift
let photos = UserDefaults.standard.object(forKey: "Photos") as? [Photo] ?? [Photo]()
```

If you weren't good at nil coalescing before, you will be now 😛.


## 🥅 Challenge Project

From https://www.hackingwithswift.com/guide/5/3/challenge:

> Put two different projects into one: Let users take photos of things that interest them, add captions to them, then show those photos in a table view. Tapping the caption should show the picture in a new view controller.


Feel free to peruse the finished project [here](./project) ✌️.

![screenshot](./project/screenshot-1.png)

