# Day 37: _Project 8: 7 Swifty Words_, Part Two

_Follow along at https://www.hackingwithswift.com/100/37_.


## 📒 Field Notes

This day covers the second part of `Project 8: 7 Swifty Words` in _[Hacking with Swift](https://www.hackingwithswift.com/read/8)_.

I have a [separate repository](https://github.com/CypherPoet/book--hacking-with-swift) where I've been creating projects alongside the material in the book. And you can find Project 8 [here](https://github.com/CypherPoet/book--hacking-with-swift/tree/master/08-seven-swifty-words/Seven%20Swifty%20Words). However, I also copied it over to Day 36's folder so I could extend from where I left off.

With that in mind, Day 37 focuses on several specific topics:

- Loading a level and adding button targets
- `firstIndex(of:)` and `joined()`
- Property observers: `didSet`


### Loading a Level and Adding Button Targets

Each level is represented by a text file that looks something like this:

```swift
HA|UNT|ED: Ghosts in residence
LE|PRO|SY: A Biblical skin disease
TW|ITT|ER: Short online chirping
OLI|VER: Has a Dickensian twist
ELI|ZAB|ETH: Head of state, British style
SA|FA|RI: The zoological web
POR|TL|AND: Hipster heartland
```

The words separated by a pipe (`|`) are the possible "letter groups" (which comprise a single "solution") that we need to represent as buttons,
and the text after the `: ` will be its corresponding "clue". Additionally, before the user discovers and answer, our answer label will show the number of letters that each solution word contains.

So we basically have one giant operation &mdash; parsing &mdash; that needs to yield a _set_ of informational pieces about the same data. My solution was to create a method that returned a tuple with that information, and then update the UI accordingly:

```swift
func loadLevel(number levelNumber: Int) ->
    (cluesText: String, solutionLengthsText: String, solutionLetterGroups: [String], solutionWords: [String])
{
  ... parsing logic ...
}
```

```swift
func setupLevel(number: Int) {
    let (cluesText, solutionLengthsText, solutionLetterGroups, solutionWords) = loadLevel(number: number)

    self.solutionWords = solutionWords
    cluesLabel.text = cluesText.trimmingCharacters(in: .whitespacesAndNewlines)
    answersLabel.text = solutionLengthsText.trimmingCharacters(in: .whitespacesAndNewlines)

    setLetterGroupButtonTitles(from: solutionLetterGroups)
}
```

#### Loading Level Data


This is where we can employ some of Swift's powerful data loading and String utilities &mdash; specifically:

- `String.components(separatedBy:)` to get break apart the solution/clue parts of our line, and again to break apart each letter group
    - ```swift
      let lineParts = line.components(separatedBy: ": ")
      let solutionPart = lineParts[0]
      solutionLetterGroups += solutionPart.components(separatedBy: "|")
      ```
- `String.replacingOccurrences(of:with:)` to find our full solution words:
    - ```swift
      let solutionWord = solutionPart.replacingOccurrences(of: "|", with: "")
      ```

There's a bit more going on in this method that I didn't touch on here. Again, feel free to check out the full project inside of the Day 36 folder.

#### Adding Button Targets

One reason I chose to still a few things with the storyboard is that I find it to be a much cleaner way of connecting UI elements to event handlers. We _could_ manually call `addTarget` when setting up our buttons in code, but for our `Submit` and `Clear` buttons, an outlet seems much more ideal:

```swift
@IBAction func clearTapped(_ sender: Any) {
}

@IBAction func submitTapped(_ sender: Any) {
}
```


### `firstIndex(of:)` and `joined()`

When the user taps the "Submit" button, we can see if our current answer text matches one of our words by using `Array.firstIndex(of:)`.

```swift
@IBAction func submitTapped(_ sender: Any) {
    guard let currentAnswer = currentAnswerField.text else { return }

    if let indexOfMatch = solutionWords.firstIndex(of: currentAnswer) {
        activatedButtons.removeAll()  // remove all from our array -- but keep them "hidden" on the UI
        addCorrectAnswer(indexOfMatch: indexOfMatch)
        bumpScore()
    } else {
        promptAfterIncorrect()
    }
}
```

⚠️ I felt like making a note of this, because I originally used `index(of:)`, which is now deprecated. `firstIndex(of:)` and `lastIndex(of:)` is the future &mdash; best to start living in it 😀.


### Property observers: `didSet`

I'll let the beauty of Swift speak for itself here:

```swift
var score = 0 {
    didSet {
        scoreLabel.text = "Score: \(score)"
    }
}
```

😍
