//
//  Double+Radians.swift
//  Instafilter
//
//  Created by Brian Sipple on 4/7/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation

extension Double {
    static func radians(fromDegrees degrees: Double) -> Double {
        return (degrees / 180.0) * .pi
    }
}
