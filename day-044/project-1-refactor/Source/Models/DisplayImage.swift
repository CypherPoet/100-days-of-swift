//
//  ImagePath.swift
//  Storm Viewer
//
//  Created by Brian Sipple on 3/23/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation

struct DisplayImage {
    var imagePath: String
    
    var imageName: String {
        if let dotIndex = imagePath.firstIndex(of: ".") {
            return String(imagePath.prefix(upTo: dotIndex))
        }
        
        return imagePath
    }
}
