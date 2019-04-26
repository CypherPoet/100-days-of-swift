# Day 66: Milestone for Projects 16-18


_Follow along at https://www.hackingwithswift.com/100/66_.


## 📒 Field Notes

> This day resolves around recapping the content covered while going through Projects 16-18 in _[Hacking with Swift](https://www.hackingwithswift.com/read)_, and then implementing a challenge project.

Regarding the recap, I won't try to rehash what I wrote up already &mdash; but a few extra things are worth noting.


### Being Assertive with `assert`

Because the compiler automatically removes assertions when building apps for release, there's essentially no cost to using `assert` liberally (other than _potentially_ impacting readability, that is.).

But I'm still a bit conflicted &mdash; and right now, I'm not finding many opportunities to use `assert`. If I'm ever worried about something so nonsensical that it's worth crashing the app over, I usually treat that as a code smell and try to think of ways I can refactor a piece of code altogether.

But it's also possible that this is something that requires more intuition, and is built through practice. So consider this a note-to-self to keep `assert` in mind 🙂.


## 🥅 Challenge Project

From https://www.hackingwithswift.com/guide/7/3/challenge:

> Make a shooting gallery game using SpriteKit: create three rows on the screen, then have targets slide across from one side to the other. If the user taps a target, make it fade out and award them points.


⚠️This is still in progress. I'll be chipping away at it while I continue with the rest of _100 Days of Swift_ &mdash; but feel free to peruse the finished project [here](./project) when it's done ✌️.

</br>
</br>
<!--
<div style="text-align: center;">
  <img src="./screenshot-1.png" width="45%"/>
  <img src="./screenshot-2.png" width="45%"/>
  <img src="./screenshot-3.png" width="45%"/>
</div>
 -->
