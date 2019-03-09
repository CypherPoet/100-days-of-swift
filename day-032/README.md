# Day 32: Milestone for Projects 4-6

_Follow along at https://www.hackingwithswift.com/100/32_.


## 📒 Field Notes

This day resolves around recapping the content covered while going through Projects 4-6 in _[Hacking with Swift](https://www.hackingwithswift.com/read)_. I won't try to rehash what I wrote up already, but a few additional tidbits are noteworthy:

- Whenever we're creating views in code &mdash; instead of with storyboards &mdash; overriding our view controller's `loadView` function is often the place to do it. For that matter, it's worth knowing about `UIViewController`'s view loading lifecycle as a whole:

  - `loadView`
  - `viewDidLoad`
  - `viewWillAppear`
  - `viewDidAppear`
  - `viewWillDisappear`
  - `viewDidDisappear`
  - `viewWillLayoutSubviews`
  - `viewDidLayoutSubviews`

  The [`UIViewController` docs](https://developer.apple.com/documentation/uikit/uiviewcontroller) have more on all of these &mdash; as well as this handy graph:

  ![view controller lifecycle](./view-controller-lifecycle.png)


- Auto Layout in code:
  - VFL is cool
  - Anchors are cool &mdash; and usually a lot more useful.
  - `UIStackView` is another important part of this paradigm &mdash; but also a much larger topic 🙂.


## 🔗 Additional/Related Links

- [View Controller Lifecycle Explained: When to Use viewDidLayoutSubviews](https://www.appcoda.com/view-controller-lifecycle/)
