# Day 25: Project 4, Part Two

_Follow along at https://www.hackingwithswift.com/100/25_.


## 📒 Field Notes

This day covers the second part of `Project 4, Easy Browser` in _[Hacking with Swift](https://www.hackingwithswift.com/read/4/overview)_.

I have a [separate repository](https://github.com/CypherPoet/book--hacking-with-swift) where I've been creating projects alongside the material in the book. And you can find Project 4 [here](https://github.com/CypherPoet/book--hacking-with-swift/tree/master/04-easy-browser). However, this day focused specifically on a number of topics:

- Monitoring page loads: UIToolbar and UIProgressView
- Refactoring for the win

### Monitoring page loads: UIToolbar and UIProgressView

Built-in, at the ready, all view controllers contain a `UIToolbar` with an array of `toolbarItems` that, when set to be shown, automatically appears at the bottom of the view.

This is extremely handy (obviously... it's called a toolbar), and this project uses it to introduce a way to show a web page progress loader:

```swift
func setupToolbar() {
    progressView = UIProgressView(progressViewStyle: .default)
    progressView.sizeToFit()

    let progressButton = UIBarButtonItem(customView: progressView)
    let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))

    toolbarItems = [progressButton, spacer, refresh]
    navigationController?.isToolbarHidden = false
}
```

Now initially, I would have imagined that `WKNavigationDelegate`s received a callback for whenever page loading progress advances. But they don't. I can see why that would make sense in hindsight: That's a lot of functions potentially being fired and potentially not needed. In any case, it's up to us, then to _explicitly_ observe changes. Since we can't use `didSet` &mdash; that only works for instance properties of a class itself &mdash; we need to use another pattern: [Key-Value Observing](https://developer.apple.com/documentation/swift/cocoa_design_patterns/using_key-value_observing_in_swift) (AKA KVO).


Basically, this consists of the following steps:

- Calling `NSObject.addObserver` in our UIViewController's `viewWillAppear` hook &mdash; passing in an `observer` object to observe, a `keyPath` for the property we're interested in.

  ```swift
  override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)

      webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
  }
  ```

- Overriding `NSObject.observeValue(forKeyPath:of:change:context:)`, using its arguments to figure out what fired, and handle accordingly.
  ```swift
  override func observeValue(
      forKeyPath keyPath: String?,
      of object: Any?,
      change: [NSKeyValueChangeKey : Any]?,
      context: UnsafeMutableRawPointer?
  ) {
      if keyPath == "estimatedProgress" {
          progressView.progress = Float(webView.estimatedProgress)
      }
  }
  ```

- Calling `NSObject.removeObserver` in our UIViewController's `viewWillAppear` hook &mdash; passing in the same object/keypath pair we used for `addObserver`:
  ```swift
  override func viewDidDisappear(_ animated: Bool) {
      super.viewDidDisappear(animated)

      webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
  }
  ```


⚠️ Swift 4 introduced a much more [concise style of performing KVO](https://developer.apple.com/documentation/swift/cocoa_design_patterns/using_key-value_observing_in_swift). I'm very interested in exploring that next.


### Refactoring for the win

After a user reaches an initial website, they can try to go anywhere &mdash; but we want our menu options to function as a whitelist. This can be achieved by overriding `WKNavigationDelegate.webView(_:decidePolicyFor:decisionHandler:)`, and making sure that the hostname of the site that's currently trying to be reached is contained within one of the sites in our `siteNames` list:

```swift
func webView(
    _ webView: WKWebView,
    decidePolicyFor navigationAction: WKNavigationAction,
    decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
) {
    let url = navigationAction.request.url

    if let host = url?.host {
        for siteName in siteNames {
            if host.contains(siteName) {
                decisionHandler(.allow)
                return
            }
        }
    }

    decisionHandler(.cancel)
}
```

🔑 A further optimization, IMO, would be to make `structs` for each white-listed site &mdash;with separate, decoupled properties for `host` and `displayName`. That would make `if host.contains(siteName)` a lot less magical, and not reliant on the implementation detail of `siteName`.


## 🔗 Related Links

- [Apple Docs: Using Key-Value Observing in Swift](https://developer.apple.com/documentation/swift/cocoa_design_patterns/using_key-value_observing_in_swift)
