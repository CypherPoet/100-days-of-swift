//
//  ImagePath.swift
//  Storm Viewer
//
//  Created by Brian Sipple on 3/23/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation

class DisplayImage {
    var imagePath: String
    
    var timesViewed: Int = 0 {
        didSet {
            UserDefaults.standard.set(timesViewed, forKey: showCountUserDefaultsKey)
        }
    }
    
    init(imagePath: String) {
        self.imagePath = imagePath
        self.timesViewed = UserDefaults.standard.integer(forKey: showCountUserDefaultsKey)
    }
}


// MARK: - Computed Properties

extension DisplayImage {
    var imageName: String {
        if let dotIndex = imagePath.firstIndex(of: ".") {
            return String(imagePath.prefix(upTo: dotIndex))
        }
        
        return imagePath
    }
    
    var showCountUserDefaultsKey: String {
        return "Show Count -- \(imageName)"
    }
}
