//
//  BeaconRegion.swift
//  Detect A Beacon
//
//  Created by Brian Sipple on 6/8/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation
import CoreLocation

enum BeaconRegion {
    static let proximityUUID = UUID(uuidString: "b076738b-813c-42bc-bada-0a74d438048e")
    static let regionMajorCode: CLBeaconMajorValue = 123
    static let regionMinorCode: CLBeaconMinorValue = 456
    static let regionIdentifier = "com.MuseumOfSorcery"
    
    
    static func makeRegion() -> CLBeaconRegion {
        return CLBeaconRegion(
            proximityUUID: proximityUUID!,
            major: regionMajorCode,
            minor: regionMinorCode,
            identifier: regionIdentifier
        )
    }
}
