# Day 21: Project 2, Part Three

_Follow along at https://www.hackingwithswift.com/100/21_.

## 📒 Field Notes

This day covers the third and final part of `Project 2: Guess the Flag` in _[Hacking with Swift](https://www.hackingwithswift.com/read/2/overview)_.

I have a [separate repository](https://github.com/CypherPoet/book--hacking-with-swift) where I've been creating projects alongside the material in the book. And you can find Project 2 [here](https://github.com/CypherPoet/book--hacking-with-swift/tree/master/02-guess-the-flag/Guess%20the%20Flag).

However, the main focus of this day was extending the finished app according to a set of challenges. With that in mind, I copied the old finished project to this repo and got started.

### Challenge 1

> Try showing the player’s score in the navigation bar, alongside the flag to guess.




### Retrospective

My original approach for this project was to create a dictionary of ``, which ended up being used somewhat awkwardly &mdash; storing the ... key... etc.

Having since learned a lot more about modeling data in Swift, I'd probably recommend structuring each "flag" as a `Flag` `struct`, keeping a `[Flag]` list, and accessing both the display name and flag image file name from there.

