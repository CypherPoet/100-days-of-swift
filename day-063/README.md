# Day 63: _Project 17: Space Race_, Part Two

_Follow along at https://www.hackingwithswift.com/100/63_.


## 📒 Field Notes

> This day covers the second and final part of `Project 17: Space Race` in _[Hacking with Swift](https://www.hackingwithswift.com/read/17)_.
>
> I previously created projects alongside _Hacking with Swift_ in a [separate repository](https://github.com/CypherPoet/book--hacking-with-swift), and you can find Project 17 [here](https://github.com/CypherPoet/book--hacking-with-swift/tree/master/23-space-race). Even better, though, I copied it over to Day 62's folder so I could extend it for _100 Days of Swift_.
>
> With that in mind, Day 63 focuses on extending the project with a set of challenges.


## 🥅 Challenges

### Challenge 1

> Stop the player from cheating by lifting their finger and tapping elsewhere – try implementing `touchesEnded()` to make it work.

- 🔗 [Commit](https://github.com/CypherPoet/100-days-of-swift/commit/eecdd7eee4a418acde27f69cade883c0db91f0bf)


### Challenge 2

> Make the timer start at one second, but then, after 20 enemies have been made, subtract 0.1 seconds from it so it’s triggered every 0.9 seconds. After making 20 more, subtract another 0.1, and so on. Note: you should call `invalidate()` on `gameTimer` before giving it a new value, otherwise you end up with multiple timers.

- 🔗 [Commit](https://github.com/CypherPoet/100-days-of-swift/commit/65a056b7eca2aa42aa44ab5e245e7b7699b17735)


### Challenge 3

> Stop creating space debris after the player has died.

- 🔗 [Already Covered 🙂](https://github.com/CypherPoet/100-days-of-swift/blob/65a056b7eca2aa42aa44ab5e245e7b7699b17735/day-062/project/Space%20Race/Space%20Race/Scenes/MainGameScene.swift#L80)
