# Day 21: Project 2, Part Three

_Follow along at https://www.hackingwithswift.com/100/21_.

## 📒 Field Notes

This day covers the third and final part of `Project 2: Guess the Flag` in _[Hacking with Swift](https://www.hackingwithswift.com/read/2/overview)_.

I have a [separate repository](https://github.com/CypherPoet/book--hacking-with-swift) where I've been creating projects alongside the material in the book. And you can find Project 2 [here](https://github.com/CypherPoet/book--hacking-with-swift/tree/master/02-guess-the-flag/Guess%20the%20Flag).

However, the main focus of this day was extending the finished app according to a set of challenges. With that in mind, I copied the old finished project to this repo and got started.


### Challenge 1

> Try showing the player’s score in the navigation bar, alongside the flag to guess.

- 🔗[Commit](https://github.com/CypherPoet/100-days-of-swift/commit/0745d414b2a76e02bbf20176202ebbb92c77faac)



### Challenge 2

> Keep track of how many questions have been asked, and show one final alert controller after they have answered 10. This should show their final score

- 🔗[Commit](https://github.com/CypherPoet/100-days-of-swift/commit/27eb18c6ea6c1be3250e0fe0c782a7837d57cb17)


### Challenge 3

> When someone chooses the wrong flag, tell them their mistake in your alert message – something like “Wrong! That’s the flag of France,” for example.

- 🔗[Commit](https://github.com/CypherPoet/100-days-of-swift/commit/a292c6bb6238d197e580cc838e0a2b14c44d8fb2)


### Additional Retrospective

My original approach for this project was to create a dictionary of `flagFilePathsAndNames`, which ended up being used somewhat awkwardly &mdash; storing things like a `correctFlagKey` key and `flagChoiceKeys`.

Having since learned a lot more about modeling data in Swift, I took a stab at modeling a `Flag` struct that stored an `assetName` and `displayName` for the flag. This made it possible to keep the following three items in `ViewController`:

```swift
var flags: [Flag] = []
var flagChoices: [Flag] = []
var correctFlag: Flag!
```

These items, then, provided clear and definitive access for the properties of each flag:

```swift
func askQuestion() {
    flagChoices = Array(flags.shuffled()[..<3])
    correctFlagTag = Int.random(in: 0..<3)
    correctFlag = flagChoices[correctFlagTag]

    title = "Which flag belongs to \(correctFlag.country)?"

    for (index, button) in [button1, button2, button3].enumerated() {
        button?.setImage(UIImage(named: flagChoices[index].assetName), for: .normal)
    }
}
```
