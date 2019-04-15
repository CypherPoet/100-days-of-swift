//
//  CityLoader.swift
//  City Facts
//
//  Created by Brian Sipple on 4/15/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation

struct CityLoader {
    func decodeCities(from data: Data) throws -> [City] {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let resultsContainer = try decoder.decode(Container.self, from: data)
        
        return resultsContainer.cities
    }
}


private struct Container: Decodable {
    var cities: [City]
    
    enum CodingKeys: CodingKey {
        case cities
    }
}
