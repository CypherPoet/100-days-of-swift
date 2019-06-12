# Day 75: _Project 22: Detect-A-Beacon_, Part One


This day covers the second and final part of `Project 22: Detect-A-Beacon` in _[Hacking with Swift](https://www.hackingwithswift.com/read/22)_.
You can follow along directly [here](https://www.hackingwithswift.com/100/75).


## 📒 Field Notes

> I previously created projects alongside _Hacking with Swift_ in a [separate repository](https://github.com/CypherPoet/book--hacking-with-swift). For _100 Days of Swift_, however, I've been extending things further and adding my projects to this repo under each "Part One" folder.
>
> With that in mind, Day 75 focuses on several specific topics:
>
> - Requesting Location: Core Location
> - Hunting the Beacon: CLBeaconRegion


### Requesting Location: Core Location

Consent is important. Especially when it comes to location tracking. Given that our app is all about tracking its proximity to a beacon, however... we're going to need those permissions 🙂.

Specifically, we'll need to acquire the `Privacy - Location When In Use Usage Description` and `Privacy - Location Always and When In Use Usage Description` permissions. It seems like a bit much, but this configuration allows us to detect beacons in the background &mdash; while still allowing users to manually specify `When In Use`, either during our initial request, or later in Settings.


### Hunting the Beacon: CLBeaconRegion

With an initializer that takes arguments for `proximityUUID`, `major`, `minor`, `identifier`, `CLBeaconRegion` allows us to describe the location and identity of a beacon at several levels of granularity.

Assuming the following...

- A beacon matching the information defined on our `CLBeaconRegion` is running on another device
- The device that our app is running on is capable of monitoring and ranging (measuring distance) beacons.
- Our app has permissions to read the current device location.

... we can tell our `CLLocationManager` instance to start monitoring and ranging:

```swift
locationManager.startMonitoring(for: beaconRegion)
locationManager.startRangingBeacons(in: beaconRegion)
```

From there, our `CLLocationManagerDelegate` can be set up to receive events such as `didRangeBeacons`, where we can infer our proximity to a ranged beacon:


```swift
func locationManager(
    _ manager: CLLocationManager,
    didRangeBeacons beacons: [CLBeacon],
    in region: CLBeaconRegion
) {
    let beaconProximity = beacons.first?.proximity ?? CLProximity.unknown

    updateUI(for: beaconProximity)
}
```
