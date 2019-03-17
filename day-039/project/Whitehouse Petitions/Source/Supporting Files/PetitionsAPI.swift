//
//  PetitionsAPI.swift
//  Whitehouse Petitions
//
//  Created by Brian Sipple on 3/10/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation

enum PetitionsAPI {
    static let baseURL = "https://api.whitehouse.gov/v1/petitions.json"
    static let recentPetitions = "\(PetitionsAPI.baseURL)?limit=100"
    static let popularPetitions = "\(PetitionsAPI.baseURL)?signatureCountFloor=10000&limit=100"
}
