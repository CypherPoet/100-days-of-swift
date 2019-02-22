# Day 19: Project 2, Part One

_Follow along at https://www.hackingwithswift.com/100/19_.


## 📒 Field Notes

This day covers the beginning of Project 2: Guess the Flag in _[Hacking with Swift](https://www.hackingwithswift.com/read/2/overview)_.

I have a [separate repository](https://github.com/CypherPoet/book--hacking-with-swift) where I've been creating projects alongside the material in the book. And you can find Project 2 [here](https://github.com/CypherPoet/book--hacking-with-swift/tree/master/02-guess-the-flag/Guess%20the%20Flag). However, this day focused specifically on a number of topics:

- Setting up
- Designing your layout
- Making the basic game work: UIButton and CALayer



### Designing the Layout

#### View Controller Navbars
An initial gotcha with creating projects from a Single View App: views don't automatically have a navigation bar &mdash; we need to wrap them in a Navigation Controller first to begin having the navbar show up.

#### Making Flag Buttons

Adding buttons in Interface Builder, we get to start with whatever the latest default iOS design is. So how, exactly, does one make a "Flag Button"? It's actually pretty straightforward: buttons can have image set for them. And IB allows us to select an image directly from the content in our Asset Catalogs 💥.

#### Asset Catalogs

This part of the project introduces a really neat optimization that iOS uses for handling images for different screen sizes. By using a naming scheme of `name.png`, `name@2x.png`, and `name@3x.png`, iOS will [match the `@` portion with the "scale factor" that Apples has assigned](https://developer.apple.com/design/human-interface-guidelines/ios/icons-and-images/image-size-and-resolution/) to the current device. The App Store then takes it a step further with [app thinning](https://www.imore.com/app-thinning-ios-9-explained) &mdash; automatically stripping out unused assets when a device is downloading the app &mdash; to ensure that developers can take advantage of dynamic sizing without weighing down their users.

#### Auto Layout

Positioning our flags exposes a number of different Auto Layout techniques:

- Centering a single piece of content horizontally or vertically relative to its containing view.
- Aligning two items at a particular distance from each other by using a vertical or horizontal Auto
Layout spacing constraint.
- Aligning an item at a particular distance from the screen's "Safe Area" by using a vertical or horizontal Auto Layout spacing constraint.


### Making the basic game work

As mentioned previously, Interface Builder makes it dead simple to give a button an image. But here, we need to add button images based upon flag names that will ultimately be derived at random in our code. [We need to go deeper](https://www.meme-arsenal.com/memes/2729e60bf11162f59e9b071fef2dac94.jpg).

Specifically, we need to make use of `UIButton.setImage`, `UIImage(named:)`:

```swift
button1.setImage(UIImage(named: flagNames[0]), for: .normal)
button2.setImage(UIImage(named: flagNames[1]), for: .normal)
button3.setImage(UIImage(named: flagNames[2]), for: .normal)
```

`setImage` does just that, while `UIImage(named:)` is one of the many ways to create a `UIImage` in iOS &mdash; but fits our purposes here perfectly.


#### Styling buttons in code

In addition to creating buttons in code, UIKit provides a `layer` property to access various visual attributes such as `borderWidth`, `borderColor` and more:

```swift
button1.layer.borderColor = UIColor.lightGray.cgColor
```

`layer` is an instance of `CALayer`, which, itself, is a Core Animation data type that sits under each UIView. So yes... `borderColor` is just scratching the surface of what that can allow us to do 😃.


## 🔗 Related Links

- [WWDC 2018: Optimizing App Assets](https://developer.apple.com/videos/play/wwdc2018/227/)
