# Day 29: Project 5, Part Three

_Follow along at https://www.hackingwithswift.com/100/29_.


## 📒 Field Notes

This day covers the final part of `Project 5: Word Scramble` in _[Hacking with Swift](https://www.hackingwithswift.com/read/5)_.

I have a [separate repository](https://github.com/CypherPoet/book--hacking-with-swift) where I've been creating projects alongside the material in the book. And you can find Project 5 [here](https://github.com/CypherPoet/book--hacking-with-swift/tree/master/05-word-scramble/Word%20Scrable). However, I also copied it over to this repo in [Day 27](./../day-027/README.md) so I could extend from where I left off.

With that in mind, the main focus of this day was extending the finished app according to a set of challenges.


## 🥅 Challenges

### Challenge 1

> Disallow answers that are shorter than three letters or are just our start word. For the three-letter check, the easiest thing to do is put a check into `isReal()` that returns false if the word length is under three letters. For the second part, just compare the start word against their input word and return false if they are the same.

- 🔗[Commit](https://github.com/CypherPoet/100-days-of-swift/commit/847dc5dd7bfcee7e1e3f37f44235ae2eb1f94b9f) (I actually decided to allowed two-letter words. I can't justify rejecting "Pi" 🙂).


### Challenge 2

> Refactor all the else statements we just added so that they call a new method called showErrorMessage(). This should accept an error message and a title, and do all the UIAlertController work from there.

- [✅ Already covered](https://github.com/CypherPoet/100-days-of-swift/blob/847dc5dd7bfcee7e1e3f37f44235ae2eb1f94b9f/day-027/project/Word%20Scrable/Word%20Scrable/HomeViewController.swift#L182)


### Challenge 3

> Add a left bar button item that calls startGame(), so users can restart with a new word whenever they want to.

- 🔗[Commit](https://github.com/CypherPoet/100-days-of-swift/commit/756fbb181ddcc81b10df3cce61de319903f0b228)
