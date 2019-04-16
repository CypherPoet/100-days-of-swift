//
//  City.swift
//  City Facts
//
//  Created by Brian Sipple on 4/13/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation

struct City {
    var name: String
    var country: String
    var population: Int
    var yearFounded: Int
    var lastCensusYear: Int
    var description: String
    var thumbnailImageName: String
    var dayImageName: String
    var nightImageName: String
}


// MARK: - Computed Properties

extension City {
    var formattedYearFounded: String {
        if yearFounded == 0 {
            return "0"
        } else {
            return "\(yearFounded) \(yearFounded > 0 ? "CE" : "BCE")"
        }
    }
    
    var formattedPopulation: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: NSNumber(value: population))!
    }
}

extension City: Decodable {}
