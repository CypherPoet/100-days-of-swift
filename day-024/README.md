# Day 24: Project 4, Part One

_Follow along at https://www.hackingwithswift.com/100/24_.


## 📒 Field Notes

This day covers the first part of `Day 24: Project 4, Part One` in _[Hacking with Swift](https://www.hackingwithswift.com/read/4/overview)_.

I have a [separate repository](https://github.com/CypherPoet/book--hacking-with-swift) where I've been creating projects alongside the material in the book. And you can find Project 4 [here](https://github.com/CypherPoet/book--hacking-with-swift/tree/master/04-easy-browser). However, this day focused specifically on a number of topics:

- Creating a simple browser with WKWebView
- Choosing a website: UIAlertController action sheets


### Creating a simple browser with WKWebView

When it comes to using web views in iOS, Apple has two primary solutions: `WKWebView`, and [`SFSafariViewController`](https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller). The latter appears to have been designed, in many respects, as an improvement upon `WKWebView`, so naturally this project got me curious about how the two currently fit within the iOS ecosystem. That said, the focus here is so streamlined that it seems like either choice will do. And so... we begin...

```swift
import WebKit
```

Doing this inside of our `ViewController.swift` file allows us to override the view controller's default `view` with an instance of `WKWebView` &mdash; and then sign us up as its `navigationDelegate`:

```swift
override func loadView() {
    webView = WKWebView()
    webView.navigationDelegate = self
    view = webView
}
```

Which introduces delegation. By subscribing as a delegate, we're promising the `webView` instance that our `ViewController` instance can handle specific functions that it calls on its `navigationDelegate`. We communicate this honesty to the compiler by declaring that our class conforms to a protocol, in this case `WKNavigationDelegate`:

```swift
class ViewController: UIViewController, WKNavigationDelegate {
```

🔑 Because this can look confusing, however, (Swift, probably fortunately, doesn't support multiple inheritance), I prefer separating protocol conformance out of the initial class body, and into a following extension:

```swift
extension ViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {

    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

    }
}
```

Not only does this make the protocol conformance more clear &mdash; it also keeps the methods we _implement_ for conformance in a self-contained, more focused place. Win-win 😎.

Anyway... right... loading a webpage.... With the `webView` set up as our main view, loading up a webpage is simply a matter of feeding a `URLRequest` to `webView.load`:

```swift
let url = URL(string: "https://www.hackingwithswift.com")!
webView.load(URLRequest(url: url))
webView.allowsBackForwardNavigationGestures = true
```


### Choosing a website: UIAlertController action sheets

Functioning as a webpage chooser, this project goes on to introduce the `.actionSheet` style of `UIAlertController`.

```swift
let alertController = UIAlertController(
    title: "Surf the Web!",
    message: nil,
    preferredStyle: .actionSheet
)
```

Not surprisingly, its usage is as clean and seamless, as the standard alert dialog. We feed actions the the action sheet via `UIAlertAction`:

```swift
for siteName in siteNames {
    alertController.addAction(UIAlertAction(title: siteName, style: .default, handler: openPage))
}
```

And the `handler` callback we assign can use the `action.title` to derive information about the site to load:

```swift
func openPage(action: UIAlertAction) {
    guard let domainName = action.title else { return }
    guard let pageURL = URL(string: "https://\(domainName)") else { return }

    webView.load(URLRequest(url: pageURL))
}
```

Sans the need for some better error handling in our `else` clauses, our app is surfing the Web like a ~~floater in the kiddie pool~~ pro 🏄‍.


## 🔗 Related Links

- [MacStories: iOS 9 and Safari View Controller: The Future of Web Views](https://www.macstories.net/stories/ios-9-and-safari-view-controller-the-future-of-web-views/)
