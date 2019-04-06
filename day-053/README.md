# Day 53: _Project 13: Instafilter_, Part Two

_Follow along at https://www.hackingwithswift.com/100/53_.


## 📒 Field Notes

> This day covers the second part of `Project 13: Instafilter` in _[Hacking with Swift](https://www.hackingwithswift.com/read/13)_.
>
> I previously created projects alongside the material in the book in a [separate repository](https://github.com/CypherPoet/book--hacking-with-swift). And you can find Project 13 [here](https://github.com/CypherPoet/book--hacking-with-swift/tree/master/13-instafilter). Even better, though, I copied it over to Day 52's folder so I could extend it from where I left off.
>
> With that in mind, Day 53 focuses on several specific topics:
>
> - Applying filters: CIContext, CIFilter
> - Saving to the iOS photo library


### Applying filters: CIContext, CIFilter

For image processing, it's useful to think of the ways Core Image is separate from `UIImage`. Essentially, `UIImage`s are the "high-level" bookends to the "low-level" processing that Core Image and Core Graphics do in between:

- A `CIImage` is _instantiated_ with a `UIImage`.
- A `CIImage` is _set_ as one of the values on a `CIImageFilter`.
- `CIImageFilter`s have an `outputImage` that's lying in wait to be processed by the `CIContext`.
- The processed image is a `CGImage` (CG being "Core Graphics").
- This `CGImage` can then be converted into another `UIImage` &mdash; thus completing the filtering cycle ♻.

There are _far_ more details than that, but alas, I'd be better off deferring to Apple's [Core Image Programming Guide](https://developer.apple.com/library/archive/documentation/GraphicsImaging/Conceptual/CoreImaging/ci_intro/ci_intro.html#//apple_ref/doc/uid/TP30001185).


With respect to our app, it means we need ways to handle all of these properties, and have them available when the processing is applied. My `applyImageProcessing` method &mdash; while abstracting some details elsewhere &mdash; looks like this:

```swift
func applyImageProcessing() {
    guard let (filterKey, filterValue) = currentFilterInfo else {
        print("Unable to compute processing properties for current filter")
        return
    }

    guard let currentOutputImage = currentImageFilter.outputImage else {
        print("Unable to find output image in current filter.")
        return
    }

    currentImageFilter.setValue(filterValue, forKey: filterKey)

    if let processedImage = imageFilterContext.createCGImage(currentOutputImage, from: currentOutputImage.extent) {
        imageView.image = UIImage(cgImage: processedImage)
    }
}
```


### Saving to the iOS photo library

For this, we start with an extremely straightforward method, `UIImageWriteToSavedPhotosAlbum` &mdash; but then we need to configure a callback in a way that's slightly less straightforward:

```swift
UIImageWriteToSavedPhotosAlbum(
    currentImage,
    self,
    #selector(image(_:didFinishSavingWithError:contextInfo:)),
    nil
)

...

@objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)

    if let error = error {
        alertController.title = "Save Error"
        alertController.message = error.localizedDescription
    } else {
        alertController.title = "Saved!"
        alertController.message = "Your altered image has been saved to your photos."
    }

    alertController.addAction(UIAlertAction(title: "OK", style: .default))

    present(alertController, animated: true)
}
```

Admittedly, this callback style _does_ make a lot of sense when you're familiar with Apple's naming conventions for delegate methods. But still... I can see where the Objective-C-ness can be a bit off-putting.

.... Choppy like an image run through the `CIPixelate` filter we just made 🥁.
