# Day 68: _Project 19: JavaScript Injection_, Part Two

_Follow along at https://www.hackingwithswift.com/100/68_.


## 📒 Field Notes

> This day covers the second part of `Project 19: JavaScript Injection` in _[Hacking with Swift](https://www.hackingwithswift.com/read/19)_.
>
> I previously created projects alongside _Hacking with Swift_ in a [separate repository](https://github.com/CypherPoet/book--hacking-with-swift), and you can find Project 19 [here](https://github.com/CypherPoet/book--hacking-with-swift/tree/master/16-safari-extension). Even better, though, I copied it over to Day 67's folder so I could extend it for _100 Days of Swift_.
>
> With that in mind, Day 68 focuses on several specific topics:
>
> - Establishing communication
> - Finalizing our Extension Action


### Establishing Communication

For Safari to process our extension's JavaScript, it needs to follow a few rules:

- Define a custom JavaScript class.
- Have this class implement a `run` function.
- Create a global object (done in JavaScript with the `var` keyword) that’s named `ExtensionPreprocessingJS`.
- Assign a new instance of our custom JavaScript class to the `ExtensionPreprocessingJS` object.

I was able to find Apple’s official documentation for how all of this is supposed to work [here](https://developer.apple.com/library/archive/documentation/General/Conceptual/ExtensibilityPG/ExtensionScenarios.html#//apple_ref/doc/uid/TP40014214-CH21-SW1) (see the “Accessing a Webpage” section), and then implement the following:

```js
class ExtensionAction {
  run(params) {
    /**
     * Pass data to our extension when the script is run on the page.
     *
     * Here, we'll pass:
     *   - the URL of the current page,
     *   - the page title
     */
    params.completionFunction({
      URL: document.URL,
      title: document.title
    });
  }

  /**
   * Handle anything passed back from an extension when it's runtime completes
   */
  finalize(params) {
    eval(params.userJavaScript);
  }
};


var ExtensionPreprocessingJS = new ExtensionAction();

```


### Finalizing our Extension Action

The `extensionContext` gives us a `completeRequest` method where we can return `NSExtensionItem`s to Safari. We'll return an item with an "attachment"... which is an `NSItemProvider`... which contains a `NSDictionary`... which contains an item keyed by `NSExtensionJavaScriptFinalizeArgumentKey`.

This item is also an `NSDictionary` &mdash; and _that's_ what will be passed to our JavaScript action class's `finalize` method:

```swift
navigationItem.rightBarButtonItem = UIBarButtonItem(
    barButtonSystemItem: .done, target: self, action: #selector(extensionCompleted)
)
```

```swift
@IBAction func extensionCompleted() {
    // Return any edited content to the host app.
    // This template doesn't do anything, so we just echo the passed in items.
    extensionContext!.completeRequest(
        returningItems: [userJavaScriptExtensionItem],
        completionHandler: nil
    )
}
```

```swift
var userJavaScriptExtensionItem: NSExtensionItem {
    let argument: NSDictionary = ["userJavaScript": scriptTextView.text]

    // 🔑 This is what will be sent as the argument to our script's `finalize` function
    let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]

    let customJSProvider = NSItemProvider(
        item: webDictionary,
        typeIdentifier: kUTTypePropertyList as String
    )

    let extensionItem = NSExtensionItem()
    extensionItem.attachments = [customJSProvider]

    return extensionItem
}
```
