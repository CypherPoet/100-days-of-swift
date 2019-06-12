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
    @IBOutlet weak var nearestDistanceHeader: UILabel!
    @IBOutlet weak var nearestDistanceLabel: UILabel!

    lazy var locationManager: CLLocationManager = CLLocationManager()
    lazy var beaconRegion = BeaconRegion.makeRegion()
    
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
        
        updateUI(for: .unknown)
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
    
    
    func startMonitoring() {
        if canMonitorForBeacons {
            if !didAlertUserAboutMonitoring {
                didAlertUserAboutMonitoring = true
                
                let alertMessage = """
                    \nBeginning to perform monitoring for beacon region.\n
                    *** Region identifier ***\n \(beaconRegion.identifier)\n\n
                    *** Region Proximity UUID ***\n \(beaconRegion.proximityUUID)
                    """
                
                display(alertMessage: alertMessage, titled: "📡📡📡")
            }
            
            
            beaconRegion.notifyEntryStateOnDisplay = true
            
            // start monitoring for the existence of beacons in the region
            locationManager.startMonitoring(for: beaconRegion)
            
            // start measuring the distance between us and the beacon
            locationManager.startRangingBeacons(in: beaconRegion)
        } else {
            print("Unable to perform beacon monitoring")
        }
    }
    
    
    func updateUI(for beaconProximity: CLProximity) {
        switch beaconProximity {
        case .unknown:
            self.nearestDistanceLabel.text = ProximityTheme.unknown.distanceLabelText
            self.nearestDistanceLabel.textColor = ProximityTheme.unknown.distanceLabelColor
            self.nearestDistanceHeader.textColor = ProximityTheme.unknown.distanceLabelColor
            self.view.backgroundColor = ProximityTheme.unknown.backgroundColor
        case .far:
            self.nearestDistanceLabel.text = ProximityTheme.far.distanceLabelText
            self.nearestDistanceLabel.textColor = ProximityTheme.far.distanceLabelColor
            self.nearestDistanceHeader.textColor = ProximityTheme.far.distanceLabelColor
            self.view.backgroundColor = ProximityTheme.far.backgroundColor
        case .near:
            self.nearestDistanceLabel.text = ProximityTheme.near.distanceLabelText
            self.nearestDistanceLabel.textColor = ProximityTheme.near.distanceLabelColor
            self.nearestDistanceHeader.textColor = ProximityTheme.near.distanceLabelColor
            self.view.backgroundColor = ProximityTheme.near.backgroundColor
        case .immediate:
            self.nearestDistanceLabel.text = ProximityTheme.immediate.distanceLabelText
            self.nearestDistanceLabel.textColor = ProximityTheme.immediate.distanceLabelColor
            self.nearestDistanceHeader.textColor = ProximityTheme.immediate.distanceLabelColor
            self.view.backgroundColor = ProximityTheme.immediate.backgroundColor
        @unknown default:
            self.nearestDistanceLabel.text = ProximityTheme.unknown.distanceLabelText
            self.nearestDistanceLabel.textColor = ProximityTheme.unknown.distanceLabelColor
            self.nearestDistanceHeader.textColor = ProximityTheme.unknown.distanceLabelColor
            self.view.backgroundColor = ProximityTheme.unknown.backgroundColor
        }
    }
}


// MARK: - CLLocationManagerDelegate

extension HomeViewController: CLLocationManagerDelegate {
    
    func locationManager(
        _ manager: CLLocationManager,
        didChangeAuthorization status: CLAuthorizationStatus
    ) {
        if status == .authorizedAlways {
            startMonitoring()
        } else {
            print("Unable to start scanning after authorization change. Current auth status: \(status.rawValue)")
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("didEnterRegion")
        guard let region = region as? CLBeaconRegion else { return }
        
        if canPerformBeaconRanging {
            locationManager.startRangingBeacons(in: region)
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
        
        UIView.animate(withDuration: 0.8) { self.updateUI(for: beaconProximity) }
    }
    
    
}

