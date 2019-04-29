//
//  Injection.swift
//  My Sweet HWS Extension
//
//  Created by Brian Sipple on 4/28/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation

/**
 💉 A model for custom JavaScript code that we'll try to inject into
 a website in Safari
 */
struct Injection: Codable {
    var title: String
    var evalString: String
    var siteURL: URL?
    
    
    init(
        title: String,
        evalString: String,
        siteURL: URL? = nil
    ) {
        self.title = title
        self.evalString = evalString
        self.siteURL = siteURL
    }
}
