//
//  BeaconRegion.swift
//  Detect A Beacon
//
//  Created by Brian Sipple on 6/8/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation
import CoreLocation

enum CustomBeacon {
    case alpha
    case beta
    case omega
    
    static let regionIdentifier = "Beacon Proximity:"
    

    var regionMajorCode: CLBeaconMajorValue { 123 }
    

    var regionMinorCode: CLBeaconMinorValue {
        switch self {
        case .alpha:
            return 456
        case .beta:
            return 457
        case .omega:
            return 458
        }
    }
    
    
    var proximityUUID: UUID {
        switch self {
        case .alpha:
            return UUID(uuidString: "b076738b-813c-42bc-bada-0a74d438048e")!
        case .beta:
            return UUID(uuidString: "658b3909-206a-4268-beec-25b54ece1d90")!
        case .omega:
            return UUID(uuidString: "f17e9ffd-ea81-425d-9254-12a8c2bb54f6")!
        }
    }
    
    
    var identityConstraint: CLBeaconIdentityConstraint {
        .init(
            uuid: self.proximityUUID,
            major: self.regionMajorCode,
            minor: self.regionMinorCode
        )
    }
    
    
    var region: CLBeaconRegion {
        .init(
            beaconIdentityConstraint: identityConstraint,
            identifier: Self.regionIdentifier
        )
    }
}
