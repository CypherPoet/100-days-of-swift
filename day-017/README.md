# Day 17: Project 1, Part Two

_Follow along at https://www.hackingwithswift.com/100/17_.


## 📒 Field Notes

This day continues with the projects in [Hacking with Swift](https://www.hackingwithswift.com/read).

I have a [separate repository](https://github.com/CypherPoet/book--hacking-with-swift) where I've been creating projects alongside the material in the book. And you can find Project 1 [here](https://github.com/CypherPoet/book--hacking-with-swift/tree/master/01-Storm-Viewer). However, this day focused specifically on a number of topics:

- Building a detail screen
- Loading images with UIImage
- Final tweaks: hidesBarsOnTap, safe area margins


### Building a detail screen

Using storyboards and code together, the general flow for this includes creating a new file/class for our ViewController, adding a ViewController to the storyboard, and then syncing the two by selecting the ViewController's class in the storyboard Identity Inspector.

We can continue this process at a more granular level: creating elements in storyboard, and then wiring up outlet connections to our code.

As I've become more immersed in the Swift community, I've noticed how everyone seems to have differing opinions regarding the usages of storyboards vs keeping everything in code.

Personally, I'm on the side of "it depends" 🙂. I love finding ways that the two can be used together, and I think it's best to be mindful of which use cases benefit which domain.

Anyway, another important topic covered here was the way our DetailViewController declared its `imageView` outlet as an implicitly unwrapped optional:

```swift
class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!

    ...
}
```

We do this because when the `DetailViewController` is first created, the `imageView` _hasn't_ been created yet. At the same time, though, iOS needs to know how much memory to devote to the `DetailViewController`.

So &mdash; because we know that the `imageView` _will_ exist by the time we want to use it &mdash; an implicitly unwrapped optional is a perfect way to make a declaration that satisfies both the operating system and our future needs.


### Loading images with UIImage

This section covered a way to load a detail view with an image name after its image was selected out of a parent table view:

```swift
override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let detailViewController = storyboard?.instantiateViewController(withIdentifier: "Image Detail") as? DetailViewController {
        detailViewController.imageName = imageNames[indexPath.row]
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
```

Our `DetailViewController` can then be set up to take the `imageName` it's handed and load a `UIImage` for its own `imageView`:

```swift

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!

    var imagePath: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        if  imageName != nil {
            imageView.image = UIImage(named: imageName)
        }
    }
}
```

I'm curious about how standard this approach is. For computing a selected image and then setting it on a controller with a simple image view, it seems solid. But I'm wondering what patterns exist for transitioning between more complex views... in more complex view hierarchies... with much more dynamic data... without necessarily being coupled to the `storyboard`. Probably a bit out of our scope here. But I've heard good things about the [Coordinator Pattern](https://www.hackingwithswift.com/articles/71/how-to-use-the-coordinator-pattern-in-ios-apps) in iOS, and it's on my to-do list to explore in depth. For now, though, our storm viewing is operational ⚡️!


## 🔗 Related Links

- [Hacking with Swift: How to adjust image content mode using aspect fill, aspect fit and scaling](https://www.hackingwithswift.com/example-code/uikit/how-to-adjust-image-content-mode-using-aspect-fill-aspect-fit-and-scaling)
