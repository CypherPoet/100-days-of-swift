# Day 28: Project 5, Part Two

_Follow along at https://www.hackingwithswift.com/100/28_.


## 📒 Field Notes

This day covers the second part of `Project 5: Word Scramble` in _[Hacking with Swift](https://www.hackingwithswift.com/read/5)_.

I have a [separate repository](https://github.com/CypherPoet/book--hacking-with-swift) where I've been creating projects alongside the material in the book. And you can find Project 5 [here](https://github.com/CypherPoet/book--hacking-with-swift/tree/master/05-word-scramble/Word%20Scrable). However, I also copied it over to this repo in [Day 27](./../day-027/README.md) so I could extend from where I left off.

With that in mind, Day 28 focuses on several specific topics:

- Structuring our validations
- Writing our validations


### Structuring our validations

In addition to... you know... [being an anagram](https://g.co/kgs/vcf9q1), our answers need to pass a certain set of criteria in order to be valid:

- Can't be empty
- Can't be previously used
- Is valid English
- Can't be _exactly_ the same as the subject word

There are several ways to approach this. One is to keep nesting `if` blocks for each of our checks, and then handling the `else` cases as they unwind below.

I chose to keep things a bit flatter, however. I created a separate `showSubmissionError` function that each check could call &mdash; and, simultaneously, break out of the function &mdash; if needed. This combination of approaches allowed for growing the different types of validation pretty much indefinitely:

```swift
func handleSubmit(_ input: String) -> Void {
    let answer = input.lowercased()

    if answer.isEmpty {
        return showSubmissionError(title: "Try again!", message: "Your answer can't be empty.")
    }

    if answer == currentSubject {
        return showSubmissionError(title: "Mix it up!", message: "Your answer shouldn't match the original word")
    }

    if !isOriginal(word: answer) {
        return showSubmissionError(
            title: "Be original!",
            message: "You've already used \"\(answer)\" as an anagram for \"\(currentSubject)\""
        )
    }

    if !isValidEnglish(word: answer) {
        return showSubmissionError(title: "Unknown word", message: "\"\(answer)\" wasn't recognized as a valid English word")
    }

    if !isValidAnagram(subject: currentSubject, answer: answer) {
        return showSubmissionError(title: "Try again!", message: "\"\(answer)\" is not a valid anagram for \"\(currentSubject)\"")
    }

    let indexPath = IndexPath(row: 0, section: 0)

    usedWords.insert(answer, at: 0)
    tableView.insertRows(at: [indexPath], with: .automatic)
}
```

This also could have been styled as a series of `else-if`s, with a final `else`, instead of `if`s with `return`s. But I liked how the latter pattern functioned as sort of a middle ground between `guard` and `if-else` 🤷‍.


#### Row Insertion

Given that our answer table is driven by the `usedWords` array, we _could_ just call `tableView.reloadData()` after updating the array. But we're in a unique position to do much better. We know we want to slide the word in at the top, and iOS gives us built-in animation when calling `tableView.insertRows(at:with:)` using the `.automatic` (system-default animation) value for `with`. That allows for performing a slight-of-hand magic trick with just a few lines of code:

```swift
let indexPath = IndexPath(row: 0, section: 0)

usedWords.insert(answer, at: 0)
tableView.insertRows(at: [indexPath], with: .automatic)
```


### Writing our validations

#### Is it original?

```swift
func isOriginal(word: String) -> Bool {
    return !usedWords.contains(word)
}
```

Pretty straightforward. But even though this is only a single line, it's nice to encapsulate the intricate array inspection behind a more descriptive function name.


#### Is it an anagram?

To be an anagram, a word has to be a different arrangement of part or all of the letters of its original word.

Again... so many ways to do it. But one principle I like to follow is sorting before searching. This can be more performant with large data, but even with small strings like the ones we're dealing with, it can make incrementing and computing indexes a lot more organized. With that in mind, I can up with a solution based upon going through two separate arrays: `sortedSubjectLetters` and `sortedAnswerLetters`:

```swift
func isValidAnagram(subject: String, answer: String) -> Bool {
    guard answer.count <= subject.count else { return false }

    let sortedSubjectLetters = String(subject.sorted())
    var sortedAnswerLetters = String(answer.sorted())

    while !sortedAnswerLetters.isEmpty {
        let charToMatch = sortedAnswerLetters.first!

        if !sortedSubjectLetters.contains(charToMatch) {
            return false
        }

        let numCharsToDrop = sortedAnswerLetters.lastIndex(of: charToMatch)!.encodedOffset + 1

        sortedAnswerLetters = String(sortedAnswerLetters.dropFirst(numCharsToDrop))
    }
    return true
}
```


#### Is it valid English?

Depends on who you ask 😛.

In all seriousness, though, it can be hard to know where to start with a question like this. Fortunately, we can use UIKit's built-in spell-checking utilities to get the effect we're looking for. Consider it a form of conceding to authority:

```swift
func isValidEnglish(word: String) -> Bool {
    let checker = UITextChecker()
    let range = NSMakeRange(0, word.utf16.count)
    let misspelledRange = checker.rangeOfMisspelledWord(
        in: word,
        range: range,
        startingAt: 0,
        wrap: false,
        language: "en"
    )

    return misspelledRange.location == NSNotFound
}
```

Admittedly, this solution also needs to use a few more Objective-C internals than I'd prefer. But it works &mdash; and emphasizes the importance of abstracting such tomfoolery (totally a valid word) to a modular function.


## 🔗 Related Links

- [Anagram Solver](https://www.thewordfinder.com/anagram-solver/)


