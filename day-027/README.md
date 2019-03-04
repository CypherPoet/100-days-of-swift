# Day 27: Project 5, Part One

_Follow along at https://www.hackingwithswift.com/100/27_.


## 📒 Field Notes

This day covers the first part of `Project 5: Word Scramble` in _[Hacking with Swift](https://www.hackingwithswift.com/read/5)_.

I have a [separate repository](https://github.com/CypherPoet/book--hacking-with-swift) where I've been creating projects alongside the material in the book. And you can find Project 5 [here](https://github.com/CypherPoet/book--hacking-with-swift/tree/master/05-word-scramble/Word%20Scrable). However, I also copied it over to this day's folder so I can extend from where I left off.

With that in mind, Day 27 focuses on several specific topics:

- Capture lists in Swift: What’s the difference between weak, strong, and unowned references?
- Reading from disk: `contentsOfFile`
- Entering words with `UIAlertController`


### Capture lists in Swift

Just as important as [understanding closures themselves](../day-007/README.md), understanding how closure capture lists _retain_ their values is a fundamental part of building applications in Swift. Paul Hudson's [recent article for this day](https://www.hackingwithswift.com/articles/179/capture-lists-in-swift-whats-the-difference-between-weak-strong-and-unowned-references) provides a thorough breakdown of `weak`, `strong`, and `unowned` references, and is well worth the read.

In short everything is strong by default. If we don't specify `weak` or `unowned`, Swift will assume that we don't want a reference to be cleaned up unexpectedly.

Specifying `weak` is essentially acknowledging that we're okay with a reference being cleaned up at some point, and that our code inside the closure will treat it like an `Optional`:

```swift
func makeSing() -> () -> Void {
    let singer = Singer(name: "Taylor")

    return { [weak singer] in
        singer?.sing()
    }
}
```

Most of the time, `weak` is a sane &mdash; and accurate &mdash; designation. But we can get closer to the edge with `unowned`. This tells the compiler that we're okay with the object being cleaned up at some point, because we're _sure_ it won't be cleaned up before our code will use it. Okay... if you say so... 😎:

```swift
func makeSing() -> () -> Void {
    let singer = Singer(name: "Taylor")

    return  { [unowned singer] in
        singer.sing()
    }
}
```

On one hand, we get a terser syntax &mdash; we don't have to treat the captured value as an `Optional`, much like implicit unwrapping &mdash; but it also means are code will crash if the reference is, indeed, `nil` (as is the case for the example above, where `singer` won't live beyond the `makeSing` function).


### Reading from disk: `contentsOfFile`

After using `Bundle.main.path(forResource:ofType:)` to find the path of our words file our Bundle (which, I've found, is somewhat magical when getting started with iOS &mdash; so the more practice, the better), we can get a giant string of the words by using `String.contentsOfFile`:

```swift
if let startWords = try? String(contentsOfFile: pathToStartWords) {
  allWords = startWords.components(separatedBy: "\n")
}
```

So declarative. So expressive. So powerful. This is the kind of thing that feels like cheating 😀.


### Entering words with `UIAlertController`

The action that handles the user pressing our "Add" button needs to display an instance of `UIAlertController` &mdash; which, itself, contains a text field for the answer and a submit button.

When the submit button is pressed, we need another action to handle the value of the text in the `UIAlertController` instance before iOS gets rid of it.

And that's where avoiding strong reference cycles becomes important. Because iOS will get rid of the `UIAlertController` instance at some point, we need to make sure our closure for handling text input &mdash; which lives _on the `UIAlertController` instance that's being destroyed_ &mdash; doesn't try to stay strongly attached.

```swift
let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak alertController] _ in
    guard let answer = alertController?.textFields?[0].text else {
        return
    }

    self?.handleSubmit(answer)
}
```
