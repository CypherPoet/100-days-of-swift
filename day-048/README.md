# Day 48: _Project 12: User Defaults_, Part One

_Follow along at https://www.hackingwithswift.com/100/48_.


## 📒 Field Notes

> This day covers the first part of `Project 12: User Defaults` in _[Hacking with Swift](https://www.hackingwithswift.com/read/12)_.
>
> Project 12 is a technique project &mdash; geared towards refactoring Project 10 to use `UserDefaults`. You can find my original version of Project 10 in [Day 42](../day-042). However, I also copied everything over to this day's folder to extend from where I left off.
>
> With that in mind, Day 48 focuses on several specific topics:
>
> - Reading and writing basics: UserDefaults
> - Fixing Project 10 with NSCoding


### Reading and writing basics: UserDefaults

`UserDefaults` offers a handy way of persisting data for an application, locally on the device.

Worth noting, though, is that it's not meant to be a heavy, production-level database. In most cases, it seems like a place where we'd store user preferences or loosely-structured miscellany that would be nice to persist while the user has our app downloaded.

For our current app, we want to persist `Person` instances. `UserDefaults` can _probably_ pass as a legitimate approach since these are fairly lightweight (each instance stores an image _file name_, not the file directly), and it's the only kind of data our app is dealing with. Adding more models to the mix, though, would probably warrant a solution more along the lines of Core Data. I found [this article](https://fluffy.es/persist-data/) to be a really good breakdown of the various persistance approaches Apple gives us.

With all that being said, we'll mainly be interested in reading and writing objects. `UserDefaults` instances have a fairly straightforward, if not-very-type-safe API that revolves around A) calling `set` with a key and a value, and B) calling `object(forKey:)`, using the same key across each.

The extra type information needs to be applied by us if we want to ensure that we've retrieved the correct object. For example:

```swift
let array = defaults.object(forKey:"SavedArray") as? [String] ?? [String]()

let dict = defaults.object(forKey: "SavedDict") as? [String: String] ?? [String: String]()
```

Furthermore, objects stored in `UserDefaults` need to be property lists. Here's how Apple [elaborates](https://developer.apple.com/documentation/foundation/userdefaults#1664798) on that:

> A default object must be a property list—that is, an instance of (or for collections, a combination of instances of) NSData, NSString, NSNumber, NSDate, NSArray, or NSDictionary. If you want to store any other type of object, you should typically archive it to create an instance of NSData.

This means that for for custom types like our `Person`s, we'll need to write them in and read them out as `Data` objects &mdash; and define them in the first place so that they support such encoding and decoding. Which leads to Strategy 1...


### Fixing Project 10 with NSCoding

The main ideas here are that we want our `Person` type to conform to the `NSCoding` protocol by 1) being a `class` 🙂 and 2) implementing `NSCoding`'s `init(coder:)` and `encode(with:)` functions.

```swift
init?(coder aDecoder: NSCoder) {
    name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
    imageName = aDecoder.decodeObject(forKey: "imageName") as? String ?? ""
}

func encode(with aCoder: NSCoder) {
    aCoder.encode(name, forKey: "name")
    aCoder.encode(imageName, forKey: "imageName")
}
```

This unlocks the ability to read and write `Person`s to and from `UserDefaults` anywhere else in our app. There our many different ways to structure that in and of itself. For now, though, I made an extension off of `UIViewController`:

```swift
extension UIViewController {

    func save(
        people: [Person],
        toDefaults userDefaults: UserDefaults = UserDefaults.standard
    ) {
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: people, requiringSecureCoding: false) {
            userDefaults.setValue(savedData, forKey: "people")
        }
    }

    func getPeople(fromDefaults userDefaults: UserDefaults = UserDefaults.standard) -> [Person]? {
        if let savedPeople = userDefaults.object(forKey: "people") as? Data {
            if let decodedPeople = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPeople) as? [Person] {
                return decodedPeople
            }
        }

        return nil
    }
}
```

## 🔗 Additional/Related Links

[Apple Docs: UserDefaults](https://developer.apple.com/documentation/foundation/userdefaults)
