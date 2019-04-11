# Day 57: _Project 15: Animation_, Part One

_Follow along at https://www.hackingwithswift.com/100/57_.


## 📒 Field Notes

> This day covers the first part of `Project 15: Animation` in _[Hacking with Swift](https://www.hackingwithswift.com/read/15)_.
>
> I previously created projects alongside _Hacking with Swift_ in a [separate repository](https://github.com/CypherPoet/book--hacking-with-swift), and you can find Project 15 [here](https://github.com/CypherPoet/book--hacking-with-swift/tree/master/15-animation/animation). Even better, though, I copied it over to Day 57's folder so I could extend it for _100 Days of Swift_.
>
> With that in mind, Day 57 focuses on several specific topics:
>
> - Preparing for action
> - Switch, case, animate: animate(withDuration:)
> - Transform: CGAffineTransform


### Preparing for Action

After setting up our "Animate" button and the image to animate, our main challenge is structuring a way to cycle through different animations.

The word "cycle" provides a hint: Given that we're tracking a `currentAnimationIndex` alongside a total number of animations, we can increment the `currentAnimationIndex` around a modulus:

```swift
currentAnimationIndex = (currentAnimationIndex + 1) % 8
```

Here's that line as part of a larger `triggerAnimation` handler:

```swift
@IBAction func triggerAnimation(_ sender: UIButton) {
    triggerButton.alpha = 0.0

    UIView.animate(
        withDuration: animationDuration,
        delay: animationDelay,
        usingSpringWithDamping: 0.5,
        initialSpringVelocity: 5,
        options: [],
        animations: {
            self.runCurrentAnimation()
        },
        completion: { _ in
            self.triggerButton.alpha = 1.0
        }
    )

    currentAnimationIndex = (currentAnimationIndex + 1) % 8
}
```

### Switch, case, animate: animate(withDuration:)

So that `runCurrentAnimation` function.... This is where we can actually `switch` on the `currentAnimationIndex` and choose a set of operations to perform during the lifetime of the `UIView.animate` animation:

```swift
func runCurrentAnimation() {
    switch currentAnimationIndex {
    case 1, 3, 5:
        imageView.transform = .identity
    case 0:
        imageView.transform = CGAffineTransform(scaleX: 2, y: 2)
    case 2:
        imageView.transform = CGAffineTransform(translationX: -(view.center.x / 2), y: -(view.center.y / 2))
    case 4:
        imageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
    case 6:
        imageView.alpha = 0.1
        imageView.backgroundColor = UIColor.purple
    case 7:
        imageView.alpha = 1.0
        imageView.backgroundColor = UIColor.clear
    default:
        preconditionFailure("Current animation index is out of range")
    }
}
```


### Transform: CGAffineTransform

`CGAffineTransform` allows us to manipulate an [affine transformation matrix](https://en.wikipedia.org/wiki/Transformation_matrix#Affine_transformations) belonging to a particular `UIView`.

Because the raw process of that can be a bit mathematically... intricate... `CGAffineTransform` also provides several higher-level initializers that allow us to be more declarative and high-level:

```swift
imageView.transform = CGAffineTransform(scaleX: 2, y: 2)
```

```swift
imageView.transform = CGAffineTransform(translationX: -(view.center.x / 2), y: -(view.center.y / 2))
```

```swift
imageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
```

Hand-in-hand with making transforms that _alter_ an object, we can use `CGAffineTransform.identity` to reset the matrix to the object's original state:

```swift
imageView.transform = .identity
```


## 🔗 Additional/Related Links

- [Affine Transformations](https://en.wikipedia.org/wiki/Affine_transformation)
