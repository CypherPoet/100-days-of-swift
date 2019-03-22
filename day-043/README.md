# Day 43: _Project 10: Names and Faces_, Part Two

_Follow along at https://www.hackingwithswift.com/100/43_.


## 📒 Field Notes

This day covers the second part of `Project 10: Names and Faces` in _[Hacking with Swift](https://www.hackingwithswift.com/read/10)_.

I have a [separate repository](https://github.com/CypherPoet/book--hacking-with-swift) where I've been creating projects alongside the material in the book. And you can find Project 10 [here](https://github.com/CypherPoet/book--hacking-with-swift/tree/master/10-names-and-faces/Names%20And%20Faces). However, I also copied it over to Day 42's folder so I could extend from where I left off.

With that in mind, Day 43 focuses on several specific topics:

- Importing photos with UIImagePickerController
- Custom subclasses of NSObject
- Connecting up the people


### Importing Photos with UIImagePickerController

We can use `UIImagePickerController` for this, but first we need to register our controller as its delegate and handle the `imagePickerController(_:didFinishPickingMediaWithInfo:)` function. (It's strange that this is an `optional` function in the protocol. I'm genuinely curious about cases where we _wouldn't_ need to handle this 🤷‍.)

The picker gives us a nice way to retrieve the edited image, so we really just need a strategy for actually _writing_ that to the device's disk. In our case, we can utilize the Documents directory, which is can save private information for the app _and_ be automatically synchronized with iCloud:

```swift
func imagePickerController(
    _ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
) {
    guard let imagePicked = info[.editedImage] as? UIImage else { return }

    let fileName = UUID().uuidString
    let imageURL = getURL(forFile: fileName)

    if let jpegData = imagePicked.jpegData(compressionQuality: 0.8) {
        try? jpegData.write(to: imageURL)
    }

    people.append(Person(name: "Unknown", imageName: fileName))
    collectionView?.reloadData()

    picker.dismiss(animated: true)
}


func getURL(forFile fileName: String) -> URL {
    return getDocumentsDirectoryURL().appendingPathComponent(fileName)
}


func getDocumentsDirectoryURL() -> URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
}
```

### Custom Subclasses of NSObject

Why subclass NSObject? I mean... we don't have to. And it's certainly nice to prefer composition over inheritance. But inheriting from NSObject makes our type instances compatible with Objective-C -- which sometimes we still need. This [Quora thread](https://www.quora.com/What-is-NSObject-When-do-Swift-developers-need-to-use-NSObject) has some good explanations that go into more detail.


### Connecting up the People

I mentioned before how the data source methods of `UICollectionView` followed many of the same patterns as `UITableView`.

One bit of uniqueness here, though, is how we're responding to `didSelectItemAt`. Rather than playing off of some of the [editing hooks that a table view might give us](https://developer.apple.com/documentation/uikit/uitableviewdelegate), we find the `Person` that was selected, and then prompt the user to for a name:

```swift
override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let person = people[indexPath.item]

    promptForName(of: person)
}

func promptForName(of person: Person) {
    let alertController = UIAlertController(title: "Who is this?", message: nil, preferredStyle: .alert)

    alertController.addTextField()
    alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))

    alertController.addAction(
        UIAlertAction(title: "OK", style: .default) { [unowned self, alertController] _ in
            let newName = alertController.textFields![0].text!

            person.name = newName
            self.collectionView?.reloadData()
        }
    )

    present(alertController, animated: true)
}
```

🔑 Architecturally, this is a somewhat trivial example. But I think it's a good introduction to how collection views &mdash; despite having a data flow that's similar to table views &mdash; can quickly introduce different functionalities and ways of interacting with our content ⚡️.
