//
//  PetitionsLoader.swift
//  Whitehouse Petitions
//
//  Created by Brian Sipple on 3/10/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation

struct PetitionsLoader {
    func decodeResults(from data: Data) throws -> [Petition] {
        struct Container: Decodable {
            let results: [Petition]
        }
        
        let decoder = JSONDecoder()
        let container = try decoder.decode(Container.self, from: data)
        
        return container.results
    }
}
