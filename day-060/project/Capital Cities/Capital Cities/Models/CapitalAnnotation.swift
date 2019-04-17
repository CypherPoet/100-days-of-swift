//
//  Capital.swift
//  Capital Cities
//
//  Created by Brian Sipple on 2/5/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit
import MapKit


class CapitalAnnotation: NSObject {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var shortDescription: String
    
    
    init(title: String, coordinate: CLLocationCoordinate2D, shortDescription: String) {
        self.title = title
        self.coordinate = coordinate
        self.shortDescription = shortDescription
    }
    
    
    required convenience init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        let name = try rootContainer.decode(String.self, forKey: .name)
        let shortDescription = try rootContainer.decode(String.self, forKey: .shortDescription)
        
        let latitude = try rootContainer.decode(Double.self, forKey: .latitude)
        let longitude = try rootContainer.decode(Double.self, forKey: .longitude)
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        self.init(title: name, coordinate: coordinate, shortDescription: shortDescription)
    }
}


extension CapitalAnnotation: MKAnnotation {}


extension CapitalAnnotation: Decodable {
    enum CodingKeys: String, CodingKey {
        case name
        case latitude
        case longitude
        case shortDescription = "short_description"
    }
}
