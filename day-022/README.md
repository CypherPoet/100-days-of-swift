# Day 22: Project 3

_Follow along at https://www.hackingwithswift.com/100/22_.


## 📒 Field Notes

This day covers the `Project 3: Social Media` in _[Hacking with Swift](https://www.hackingwithswift.com/read/3/overview)_.

I have a [separate repository](https://github.com/CypherPoet/book--hacking-with-swift) where I've been creating projects alongside the material in the book. And you can find Project 3 [here](https://github.com/CypherPoet/book--hacking-with-swift/tree/master/03-social-media).

However, in addition to the project itself, this day also consisted of extending the finished app according to a set of challenges. With that in mind, I copied the old finished project to this repo and got started.


### UIActivityViewController explained

Project 3 was all about introducing `UIActivityViewController` to the Storm Viewer app. Why? `UIActivityViewController` is one of iOS's main components for sharing application content to other services on the system: copying items to the pasteboard, posting to social media, attaching items to emails or SMS messages, and more &mdash; even adding content to custom services.

And it's pretty straightforward. After adding a share button to our detail controller's navbar and connecting it to an action handler function, we can create the `UIActivityViewController` in that function and present it.

```swift
@objc func shareButtonTapped() {
    guard let imageData = imageView.image?.jpegData(compressionQuality: 0.8) else {
        print("No image data found")
        return
    }

    let viewController = UIActivityViewController(activityItems: [imageData], applicationActivities: nil)

    viewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem

    present(viewController, animated: true)
}
```

The `activityItems` refer to the contents of our application that we want to share, and `applicationActivities` would be any custom services we wanted to add to the presented options.


#### ⚠️ iPad Support

One gotcha with `UIActivityViewController` is that it needs an additional step during configuration in order to be compatible with iPads:

```swift
viewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
```

The view controller's `popoverPresentationController.barButtonItem` needs to be assigned so that iPads know where to **anchor** the popover on the screen.

This will be ignored on iPhones, since the `popoverPresentationController`'s view will always take up the entire screen &mdash; which I guess _can_ be convenient, but I remember getting bit in a later project when I forgot about it, tested for a while on an iPhone, and didn't realize my code was destined to crash later on the iPad 🙀. So really, there's no reason not to set something up here from the start.


## 🥅 Challenges

> Try adding the image name to the list of items that are shared. The activityItems parameter is an array, so you can add strings and other things freely. Note: Facebook won’t let you share text, but most other share options will.

- 🔗 [Commit](https://github.com/CypherPoet/100-days-of-swift/commit/a0a90e1d2582d06b493a5567656a96ea52f221d4)


## 🔗 Related Links

- [NSHipster: UIActivity​View​Controller](https://nshipster.com/uiactivityviewcontroller/)
