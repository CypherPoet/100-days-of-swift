//
//  Petition.swift
//  Whitehouse Petitions
//
//  Created by Brian Sipple on 3/10/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
