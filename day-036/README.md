# Day 36: _Project 8: 7 Swifty Words_, Part One

_Follow along at https://www.hackingwithswift.com/100/36_.


## 📒 Field Notes

This day covers the first part of `Project 8: 7 Swifty Words` in _[Hacking with Swift](https://www.hackingwithswift.com/read/8)_.

I have a [separate repository](https://github.com/CypherPoet/book--hacking-with-swift) where I've been creating projects alongside the material in the book. And you can find Project 8 [here](https://github.com/CypherPoet/book--hacking-with-swift/tree/master/08-seven-swifty-words/Seven%20Swifty%20Words). However, I also copied it over to this day's folder so I can extend from where I left off.

With that in mind, Day 36 focuses on a particular topic: building a UIKit user interface programmatically.


### Building a UIKit user interface programmatically

Our interface has the following items, stacked vertically:

- A score label
- Two labels for a list of clues and their corresponding answers
- The user's current answer
- Submit and Clear buttons
- A grid of letter groups that the user can choose from to assemble their answer.

To me, this arrangement demonstrates why storyboards and code can often be interwoven &mdash; and why knowing when to reach for either one can be a bit of an art, but an invaluable skill.

For one, given all of the anchoring constraints we're setting relative to other elements, it seems like doing everything in the storyboard might not even be possible. But while we could do everything in code, I don't think we should give up on the storyboard completely.

I settled on using the storyboard to mock up a basic skeleton of the UI &mdash; adding the labels, the submit/clear buttons, the answer text, and a container for the grid of letter groups &mdash; and _then_ dug in to create anchors and letter-group buttons in code.

Regardless of whether or not I could have moved more &mdash; or everything &mdash; to code, the ability, in particular, to have our code set layout constraints relative to other elements's anchors is some raw (and beautifully explicit) power that's hard to beat 💪.
