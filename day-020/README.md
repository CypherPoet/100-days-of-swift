# Day 20: Project 2, Part Two

_Follow along at https://www.hackingwithswift.com/100/20_.


## 📒 Field Notes

This day covers the second part of `Project 2: Guess the Flag` in _[Hacking with Swift](https://www.hackingwithswift.com/read/2/overview)_.

I have a [separate repository](https://github.com/CypherPoet/book--hacking-with-swift) where I've been creating projects alongside the material in the book. And you can find Project 2 [here](https://github.com/CypherPoet/book--hacking-with-swift/tree/master/02-guess-the-flag/Guess%20the%20Flag). However, this day focused specifically on a number of topics:

- Presenting random flags to guess
- Creating an `IBAction` for flags


### Presenting Random Flags

One of the primary challenges we face is figuring out how to choose 3 unique flags at random to present to the user. With our flag choices set as an array, we _could_ use `randomElement` to pick out a name &mdash; but then we still have to make sure each pick is unique. The solution for this is only a bit more intricate: we can first shuffle the array, and then just take the first three elements:

```swift
let flagChoices = Array(flagNames.shuffled()[..<3])
```

And to ensure that our answer has a random position:

```swift
let correctFlagChoice = flagChoices.randomElement()
```


### Creating an `IBAction` for flags

Similar to creating `@IBOutlet` connections from Interface Builder to code, we can also create `@IBAction` connections &mdash; bindings between interface events and the functions that handle them.

```swift
@IBAction func buttonTapped(_ sender: UIButton) {
}
```

_Unlike_ outlets, however, we don't want a different handle for each button &mdash; we want to be able to have the same function handle taps on all of our buttons. Fortunately, Xcode allows us to create connections from several different elements to a single `@IBAction` handler. In retrospect, of course it would &mdash; but it's one of those things that feels delightful the first time you learn about it 🙂.

Anyways, because these functions are called with a `sender` &mdash; the interface element that was the target of the event &mdash; we can take advantage of the sender's `tag` attribute to infer which specific flag was tapped. Here was the original code that I came up with:

```swift
@IBAction func buttonTapped(_ sender: UIButton) {
    let flagKeyChosen = flagChoiceKeys[sender.tag]

    if flagKeyChosen == correctFlagKey {
        handleChoice(wasCorrect: true)
    } else {
        handleChoice(wasCorrect: false)
    }
}
```

Looking back, I have more thoughts about how I'd structure some of the data here, which I'll try to address in the next day's wrap-up. (It's always nice to be able to look back at old code and know better.) For now, though, this covers some important concepts related to interface events and action handling &mdash; which Storyboards, divisive though they may be, allow us to connect in some _very_ useful ways 🙌.
