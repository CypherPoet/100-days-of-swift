# Day 52: _Project 13: Instafilter_, Part One

_Follow along at https://www.hackingwithswift.com/100/52_.


## 📒 Field Notes

> This day covers the first part of `Project 13: Instafilter` in _[Hacking with Swift](https://www.hackingwithswift.com/read/13)_.
>
> I have a [separate repository](https://github.com/CypherPoet/book--hacking-with-swift) where I've been creating projects alongside the material in the book. And you can find Project 13 [here](https://github.com/CypherPoet/book--hacking-with-swift/tree/master/13-instafilter). However, I also copied it over to Day 52's folder so I could extend from where I left off.
>
> With that in mind, Day 52 focuses on several specific topics:
>
> - Designing the interface
> - Importing a picture


### Designing the Interface

Given that we have an image container sitting atop a "panel" of UI controls, this might be a situation where a few stack views could be used to ensure everything lays out well on all devices and size classes.

But we might not even need that.

For our purposes, the image container, the slider, and the two buttons underneath can be aligned quite nicely by using Xcode's **Editor > Resolve Auto Layout Issues > Reset To Suggested Constraints** option.

Being meticulous, I did some extra tweaking from there, but this feature can serve as a useful starting point when crafting Auto Layout constraints 👍.


### Importing a Picture

Importing images is pretty straightforward thanks to `UIImagePickerController`, so the _real_ focus here is on what an image means to our app: We'll be importing it, allowing it to be manipulated through the UI slider control, and then allowing users to save their finished photo.

In other words... we're just getting started 😼.


## 🔗 Additional/Related Links

- [Awesome Computer Vision](https://github.com/jbhuang0604/awesome-computer-vision): A curated list of awesome computer vision resources


