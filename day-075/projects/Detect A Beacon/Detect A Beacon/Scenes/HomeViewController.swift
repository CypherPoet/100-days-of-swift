//
//  ViewController.swift
//  Detect A Beacon
//
//  Created by Brian Sipple on 2/8/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit
import CoreLocation


class HomeViewController: UIViewController {
    @IBOutlet weak var beaconNameLabel: UILabel!
    @IBOutlet weak var beaconDistanceLabel: UILabel!
    @IBOutlet var beaconLogoImage: UIImageView!
    
    lazy var locationManager: CLLocationManager = CLLocationManager()
    
    lazy var beaconRegions = makeBeaconRegions()
    
    var didAlertUserAboutMonitoring = false
}


// MARK: - Computeds

extension HomeViewController {
    
    var canMonitorForBeacons: Bool {
        return CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self)
    }
    
    /**
        "Ranging" refers to the ability for our app to determine the
        distance between our device and another location -- in this case that of the beacon.
     */
    var canPerformBeaconRanging: Bool {
        return CLLocationManager.isRangingAvailable()
    }
    
}


// MARK: - Lifecycle

extension HomeViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI(for: beaconRegions[0], with: .unknown)
        setupLocationManager()
    }
}



// MARK: - Private Helpers

private extension HomeViewController {
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
//        locationManager.allowsBackgroundLocationUpdates = true
    }
    
    
    func setupMonitoring() {
        guard canMonitorForBeacons else {
            display(
                alertMessage: "Beacon monitoring is currently unavailable.",
                titled: "Uh-oh",
                confirmButtonTitle: "Try Again Later"
            )
            
            return
        }
    
        if didAlertUserAboutMonitoring {
            startMonitoring()
        } else {
            didAlertUserAboutMonitoring = true
            
            let alertMessage = """
                \nBeginning to perform monitoring for beacon region.\n
                *** Region Proximity UUIDs ***\n
                """
            
            display(
                alertMessage: alertMessage,
                titled: "📡📡📡",
                confirmationHandler: { [weak self] _ in
                    self?.startMonitoring()
                }
            )
        }
    }
    
    
    func startMonitoring() {
        for beaconRegion in beaconRegions {
            beaconRegion.notifyEntryStateOnDisplay = true
            
            // start monitoring for the existence of beacons in the region
            locationManager.startMonitoring(for: beaconRegion)
        }
    }
    
    
    func updateUI(for region: CLBeaconRegion, with beaconProximity: CLProximity) {
        beaconNameLabel.text = region.identifier
        
        let proximityTheme: ProximityTheme
        
        switch beaconProximity {
        case .unknown:
            proximityTheme = .unknown
        case .far:
            proximityTheme = .far
        case .near:
            proximityTheme = .near
        case .immediate:
            proximityTheme = .immediate
        @unknown default:
            proximityTheme = .unknown
        }
        
        animateUI(using: proximityTheme)
    }
    
    
    func animateUI(using proximityTheme: ProximityTheme) {
        UIView.animate(
            withDuration: 0.65,
            delay: 0,
            options: [.curveEaseOut],
            animations: {
                self.beaconLogoImage.transform = CGAffineTransform.identity.scaledBy(
                    x: proximityTheme.logoScale,
                    y: proximityTheme.logoScale
                )
                
                self.beaconLogoImage.alpha = proximityTheme.logoAlpha
                self.beaconDistanceLabel.text = proximityTheme.distanceLabelText
                self.beaconDistanceLabel.textColor = proximityTheme.labelTextColor
                self.beaconNameLabel.textColor = proximityTheme.labelTextColor
                self.view.backgroundColor = proximityTheme.backgroundColor
            }
        )
    }

    
    func makeBeaconRegions() -> [CLBeaconRegion] {
        return [
            CustomBeacon.alpha.region,
            CustomBeacon.beta.region,
            CustomBeacon.omega.region
        ]
    }
}


// MARK: - CLLocationManagerDelegate

extension HomeViewController: CLLocationManagerDelegate {
    
    func locationManager(
        _ manager: CLLocationManager,
        didChangeAuthorization status: CLAuthorizationStatus
    ) {
        if status == .authorizedAlways {
            DispatchQueue.main.async { self.startMonitoring() }
        } else {
            print("Unable to start scanning after authorization change. Current auth status: \(status.rawValue)")
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("didEnterRegion")
        guard let region = region as? CLBeaconRegion else { return }
        
        if canPerformBeaconRanging {
            locationManager.startRangingBeacons(satisfying: region.beaconIdentityConstraint)
        } else {
            print("Unable to perform beacon ranging")
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Did exit region")
    }
    
    
    func locationManager(
        _ manager: CLLocationManager,
        didRangeBeacons beacons: [CLBeacon],
        in region: CLBeaconRegion
    ) {
        let beaconProximity = beacons.first?.proximity ?? CLProximity.unknown
        print("Did range beacons. Proximity: \(beaconProximity)")
        
        updateUI(for: region, with: beaconProximity)
    }
}

