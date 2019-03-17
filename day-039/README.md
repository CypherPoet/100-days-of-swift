# Day 39: _Project 9: Grand Central Dispatch_, Part One

_Follow along at https://www.hackingwithswift.com/100/39_.


## 📒 Field Notes

This day covers the first part of `Project 9: Grand Central Dispatch` in _[Hacking with Swift](https://www.hackingwithswift.com/read/9)_.

It extends on the _Whitehouse Petitions_ app we created in Project 7, and I copied the project from Day 33 to this directory as a starting point.

With that in mind, Day 39 focuses on several specific topics:

- Why is locking the UI bad?
- GCD 101: `async()`
- Back to the main thread: `DispatchQueue.main`
- Easy GCD using `performSelector(inBackground:)`


### Why is locking the UI bad?

Mainly, because we only get one main UI thread &mdash; and it needs to be able to handle whatever is most critical to the user's experience at any given moment: updating element styles, animating, responding to touches, etc.

The last thing we want to do is hijack this thread for arbitrary &mdash; potentially long-running &mdash; operations. So instead, we should make use of threads that run in the background.

🔑 I've always considered the concept of a main, UI thread as being analogous to consciousness: We don't want to have to focus on breathing, blinking, heart-beating, and saving memories all the time, so we let our brain dispatch those signals on background threads while we focus on writing beautiful Swift code 😀.


### GCD 101: `async()`

To the extent that the brain has various dispatcher mechanisms, Apple's GCD (Grand Central Dispatch) is the Swift analog. In addition to the main thread, GCD exposes four background threads that we can queue up tasks on by specifying a "Quality of Service" (using the `qos` argument):

```swift
DispatchQueue.global(qos: .userInitiated).async {
  ... perform stuff here ...
}
```

The full documentation for each QoS type can be [found here](https://developer.apple.com/library/archive/documentation/Performance/Conceptual/EnergyGuide-iOS/PrioritizeWorkWithQoS.html), and explains things really well.

For loading our petitions, we have a data fetching task that _needs_ to complete before our app becomes useful. We don't want to block the main thread, and the task might take a solid few seconds, but we still want to signal that it's rather critical.

`.userInitiated` fits the bill.


### Back to the main thread: `DispatchQueue.main`

`DispatchQueue.main` is basically the multithreading version of `break`: When we're ready to start touching the UI thread again, we can use this to shoot right back to it:

```swift
DispatchQueue.main.async {
    self.tableView.reloadData()
}
```

🔑 Notice the use of `main.async`. `main` also exposes a `sync` function, but this is for when we'd want to have the runtime "wait here" while we do something inside of the closure. `main.async` ensures that we're still just queuing up one more task in a non-blocking manner and moving along.
