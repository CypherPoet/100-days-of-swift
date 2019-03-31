//
//  Photo.swift
//  SnapGallery
//
//  Created by Brian Sipple on 3/30/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation

struct Photo: Codable {
    var title: String? = nil
    var imageName: String
    
    init(imageName: String) {
        self.imageName = imageName
    }
}


// MARK: - Computed Properties

extension Photo {
    /// Uses NSAttributedString to generate a randomly styled display title at a "small"
    /// size -- preferably for use inside a collection view grid
    var smallFormattedTitle: String {
        if let title = title {
            // TODO: Implement
            return title
        }
        
        return "Unnamed Image"
    }
    
    
    var largeFormattedTitle: String {
        if let title = title {
            // TODO: Implement
            return title
        }
        
        return "Unnamed Image"
    }
}
