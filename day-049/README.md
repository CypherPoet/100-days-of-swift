# Day 49: _Project 12: User Defaults_, Part Two

_Follow along at https://www.hackingwithswift.com/100/49_.


## 📒 Field Notes

> This day covers the second and final part of `Project 12: User Defaults` in _[Hacking with Swift](https://www.hackingwithswift.com/read/12)_.
>
> Project 12 is a technique project &mdash; geared towards refactoring Project 10 to use `UserDefaults`. You can find my original version of Project 10 in [Day 42](../day-042). However, I also copied everything over to Day 48's folder to extend from where I left off.
>
> With that in mind, Day 49 focuses on fixing Project 10's lack of data persistence by using `UserDefaults` and `Codable` &mdash; and then concluding with some challenges around implementing `UserDefaults` in a number of other projects.


### Fixing Project 10 with Codable

Unlike `NSCoding`, `Codable` allows us to persist data as JSON, which makes our data much more portable across different domains. If we don't need our types to interface to Objective-C, `Codable` is likely the way to go.

Differences aside, though, the underlying philosophies are very similar: Encoding and decoding... serializing and deserializing... and hooking in to the transformation process with the way we define our models.

But where `Codable` really shines is in practice. When we have an object structure that doesn't require custom key coding, `Codeable` handles most of the serialization/deserialization under the hood. Case in point: our new `Person` class:

```swift
class Person: NSObject, Codable {
    var name: String
    var imageName: String

    init(name: String, imageName: String) {
        self.name = name
        self.imageName = imageName
    }
}
```

External code that triggers the encoding or decoding is also much cleaner:

```swift
let encoder = JSONEncoder()

do {
    let data = try encoder.encode(people)
    userDefaults.set(data, forKey: "people")
} catch {
    print("Failed to saved people")
}
```

```swift
let decoder = JSONDecoder()

if let peopleData = userDefaults.object(forKey: "people") as? Data {
    do {
        return try decoder.decode([Person].self, from: peopleData)
    } catch {
        showError(error, title: "Error while loading saved people")
    }
}
```


## 🥅 Challenges

### Challenge 1

> Modify project 1 so that it remembers how many times each storm image was shown – you don’t need to show it anywhere, but you’re welcome to try modifying your original copy of project 1 to show the view count as a subtitle below each image name in the table view.

- 🔗 [Commit](https://github.com/CypherPoet/100-days-of-swift/commit/91be8a6e1e7785678e085811244f2dab86febaf4)


### Challenge 2

> Modify project 2 so that it saves the player’s highest score, and shows a special message if their new score beat the previous high score.

- 🔗 [Commit](https://github.com/CypherPoet/100-days-of-swift/commit/fab62a19d639cb7cd0fe13dfb55b94e5a3c76c95)


### Challenge 3

> Modify project 5 so that it saves the current word and all the player’s entries to UserDefaults, then loads them back when the app launches

- 🔗 [Commit](https://github.com/CypherPoet/100-days-of-swift/commit/7240f0a261017da0d369a7c2d085059599eca52c)
