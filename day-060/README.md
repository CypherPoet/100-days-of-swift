# Day 60: _Project 16: Capital Cities_, Part One

_Follow along at https://www.hackingwithswift.com/100/60_.


## 📒 Field Notes

> This day covers the first part of `Project 16: Capital Cities` in _[Hacking with Swift](https://www.hackingwithswift.com/read/16)_.
>
> I previously created projects alongside _Hacking with Swift_ in a [separate repository](https://github.com/CypherPoet/book--hacking-with-swift), and you can find Project 16 [here](https://github.com/CypherPoet/book--hacking-with-swift/tree/master/19-capital-cities/Capital%20Cities). Even better, though, I copied it over to Day 60's folder so I could extend it for _100 Days of Swift_.
>
> With that in mind, Day 60 focuses on several specific topics:
>
> - Up and running with MapKit
> - Annotations and accessory views: MKPinAnnotationView


### Up and Running with MapKit

To place annotations on a map, [we need annotation objects and annotation views](https://developer.apple.com/documentation/mapkit/mapkit_annotations/annotating_a_map_with_custom_data).

Making annotation objects is rather straightforward. Objects need to be subclasses of `NSObject` that conform to the `MKAnnotation` protocol &mdash; which means they need to contain a `coordinate` and, optionally, a `name` and `subtitle`.

When these objects are loaded in our view controller, we can grab an outlet to a map view and start annotating:

```swift
mapView.addAnnotations(annotations)
```


### Annotations and Accessory Views: MKPinAnnotationView

With a view controller that conforms to `MKMapViewDelegate`, and registers as a `delegate` of an `MKMapView` instance, we get notified when that instance loads the map, add annotations, reveals annotation overlays, and more.

Again, the consistent delegation patterns of Apple's APIs allow us to interact with underlying parts of our app in a familiar way. The map equals the territory, so to speak 🙂.


```swift
extension MainViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let capitalAnnotation = annotation as? CapitalAnnotation else {
            return nil
        }

        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationReuseIdentifier) {
            annotationView.annotation = capitalAnnotation

            return annotationView
        } else {
            return makeNewCapitalAnnotationView(capitalAnnotation)
        }
    }


    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let capitalAnnotation = view.annotation as? CapitalAnnotation {
            showDetailModal(forAnnotation: capitalAnnotation)
        }
    }


    func makeNewCapitalAnnotationView(_ capitalAnnotation: CapitalAnnotation) -> MKPinAnnotationView {
        let annotationView = MKPinAnnotationView(annotation: capitalAnnotation, reuseIdentifier: self.annotationReuseIdentifier)

        let button = UIButton(type: .detailDisclosure)

        annotationView.canShowCallout = true
        annotationView.rightCalloutAccessoryView = button

        return annotationView
    }


    func showDetailModal(forAnnotation annotation: CapitalAnnotation) {
        let alertController = UIAlertController(title: annotation.title, message: annotation.shortDescription, preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: "OK", style: .default))

        self.present(alertController, animated: true)
    }
}
```

## 🔗 Additional/Related Links

- [Apple Docs: Annotating a Map with Custom Data](https://developer.apple.com/documentation/mapkit/mapkit_annotations/annotating_a_map_with_custom_data)
