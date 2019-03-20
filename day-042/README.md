# Day 42: _Project 10: Names and Faces_, Part One

_Follow along at https://www.hackingwithswift.com/100/42_.


## 📒 Field Notes

This day covers the first part of `Project 10: Names and Faces` in _[Hacking with Swift](https://www.hackingwithswift.com/read/10)_.

I have a [separate repository](https://github.com/CypherPoet/book--hacking-with-swift) where I've been creating projects alongside the material in the book. And you can find Project 10 [here](https://github.com/CypherPoet/book--hacking-with-swift/tree/master/10-names-and-faces/Names%20And%20Faces). However, I also copied it over to this day's folder so I could extend from where I left off.

With that in mind, Day 42 focuses on several specific topics:

- Designing UICollectionView cells
- UICollectionView data sources


### Designing UICollectionView Cells

To the extent that table views are... well... tables with rows, collection views are conceptually closer to grids with panels (or panes).

Which is great when we have a list of content whose items can be represented by an image or a graphic or a thumbnail.

Furthermore, richer content display can be a good reason to make a custom cell class &mdash; so this was a good opportunity to design a `PersonCell` class, which, being a Cocoa Touch Class, is just as capable of holding IB connections as our containing view controller.


### UICollectionView Data Sources

Architecturally, implementing the common methods of `UICollectionViewDelegate` is very similar to doing so for `UITableViewDelegate`. For our purposes here, we're using `collectionView(_:numberOfItemsInSection:)`,  `collectionView(_:cellForItemAt:)`, and `collectionView(_:didSelectItemAt:)`.

🔑 One caveat is that we need to have `collectionView(_:cellForItemAt:)` locate an instance of our custom `PersonCell` (_if_ we want our view controller to pass data to it, which is what we're doing here). Using `.dequeueReusableCell(withReuseIdentifier:)` straight-up returns a `UICollectionViewCell`, so we need to help the compiler out with a bit of casting:

```swift
guard let cell = collectionView
    .dequeueReusableCell(withReuseIdentifier: StoryboardID.personCell, for: indexPath) as? PersonCell
else {
    fatalError("Unable to dequeue person cell")
}
```

## 🔗 Additional/Related Links

- [Complete documentation for the `UICollectionViewDelegate` protocol](https://developer.apple.com/documentation/uikit/uicollectionviewdelegate)
