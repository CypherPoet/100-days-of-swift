//
//  ProximityTheme.swift
//  Detect A Beacon
//
//  Created by Brian Sipple on 6/8/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit


enum ProximityTheme {
    case unknown
    case far
    case near
    case immediate
    
    
    var distanceLabelText: String {
        switch self {
        case .unknown:
            return "UNKNOWN"
        case .far:
            return "FAR"
        case .near:
            return "CLOSE"
        case .immediate:
            return "RIGHT HERE!"
        }
    }

    
    var labelTextColor: UIColor {
        switch self {
        case .unknown:
            return .systemGray
        case .far:
            return .systemGray2
        case .near:
            return .systemGray4
        case .immediate:
            return .systemGray6
        }
    }
    
    
    var backgroundColor: UIColor {
        switch self {
        case .unknown:
            return #colorLiteral(red: 0.3960249352, green: 0, blue: 1, alpha: 0.2492424242)
        case .far:
            return #colorLiteral(red: 0.3960249352, green: 0, blue: 1, alpha: 0.5)
        case .near:
            return #colorLiteral(red: 0.3960249352, green: 0, blue: 1, alpha: 0.7506628788)
        case .immediate:
            return #colorLiteral(red: 0.3960249352, green: 0, blue: 1, alpha: 1)
        }
    }
    
    
    var logoScale: CGFloat {
        switch self {
        case .unknown:
            return 0.7
        case .far:
            return 0.9
        case .near:
            return 1.2
        case .immediate:
            return 1.5
        }
    }
    
    
    var logoAlpha: CGFloat {
        switch self {
        case .unknown:
            return 0.2
        case .far:
            return 0.4
        case .near:
            return 0.75
        case .immediate:
            return 1.0
        }
    }
}
