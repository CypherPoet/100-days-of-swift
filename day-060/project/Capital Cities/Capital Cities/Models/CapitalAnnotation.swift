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
    static let reuseIdentifier = "Capital City Annotation"
    
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var shortDescription: String
    var wikipediaURL: URL
    
    
    init(title: String, coordinate: CLLocationCoordinate2D, shortDescription: String, wikipediaURL: URL) {
        self.title = title
        self.coordinate = coordinate
        self.shortDescription = shortDescription
        self.wikipediaURL = wikipediaURL
    }
    
    
    required convenience init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        let name = try rootContainer.decode(String.self, forKey: .name)
        let shortDescription = try rootContainer.decode(String.self, forKey: .shortDescription)
        
        let latitude = try rootContainer.decode(Double.self, forKey: .latitude)
        let longitude = try rootContainer.decode(Double.self, forKey: .longitude)
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let wikipediaURL = try rootContainer.decode(URL.self, forKey: .wikipediaURL)
        
        self.init(title: name, coordinate: coordinate, shortDescription: shortDescription, wikipediaURL: wikipediaURL)
    }
}


extension CapitalAnnotation: MKAnnotation {}


extension CapitalAnnotation: Decodable {
    enum CodingKeys: String, CodingKey {
        case name
        case latitude
        case longitude
        case shortDescription = "short_description"
        case wikipediaURL = "wikipedia_url"
    }
}
