//
//  Person.swift
//  Names And Faces
//
//  Created by Brian Sipple on 1/24/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class Person: NSObject, Codable {
    var name: String
    var imageName: String
    
    init(name: String, imageName: String) {
        self.name = name
        self.imageName = imageName
    }
}
