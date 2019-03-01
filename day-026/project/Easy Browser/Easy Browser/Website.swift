//
//  Website.swift
//  Easy Browser
//
//  Created by Brian Sipple on 3/1/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation

struct Website {
    static var allWebsites: [Website] = []
    
    var displayName: String
    var url: URL
    
    var hostName: String? {
        return self.url.host
    }
    
    init(displayName: String, url: URL) {
        self.displayName = displayName
        self.url = url
        
        Website.allWebsites.append(self)
    }
}
