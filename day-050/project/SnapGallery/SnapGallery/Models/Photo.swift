//
//  Photo.swift
//  SnapGallery
//
//  Created by Brian Sipple on 3/30/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation

struct Photo: Codable {
    var title: String
    var imageName: String
}


// MARK: - Computed Properties

extension Photo {
    
    
    /// Uses NSAttributedString to generate a randomly styled display title at a "small"
    /// size -- preferably for use inside a collection view grid
    var smallFormattedTitle: String {
        // TODO: Implement
        return ""
    }
    
    var largeFormattedTitle: String {
        // TODO: Implement
        return ""
    }
}
