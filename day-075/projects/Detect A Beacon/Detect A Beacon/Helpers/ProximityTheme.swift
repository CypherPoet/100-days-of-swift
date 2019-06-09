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

    
    var distanceLabelColor: UIColor {
        switch self {
        case .unknown:
            return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        case .far:
            return #colorLiteral(red: 0.1695539951, green: 0.182798177, blue: 0.2005673051, alpha: 1)
        case .near:
            return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        case .immediate:
            return #colorLiteral(red: 0.8756549954, green: 0.8758021593, blue: 0.8756355643, alpha: 1)
        }
    }
    
    
    var backgroundColor: UIColor {
        switch self {
        case .unknown:
            return #colorLiteral(red: 0.4559803605, green: 0.5050186515, blue: 0.4953667521, alpha: 1)
        case .far:
            return #colorLiteral(red: 0.7027224898, green: 0.6036098003, blue: 1, alpha: 1)
        case .near:
            return #colorLiteral(red: 0.5806189775, green: 0.426497519, blue: 1, alpha: 1)
        case .immediate:
            return #colorLiteral(red: 0.4703221917, green: 0.2544962764, blue: 1, alpha: 1)
        }
    }
}
