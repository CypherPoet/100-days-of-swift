//
//  Photo.swift
//  SnapGallery
//
//  Created by Brian Sipple on 3/30/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class Photo: Codable {
    var imageName: String
    
    var title: String? = nil {
        didSet {
            formattedTitle = makeFormattedTitle()
        }
    }
    
    lazy var formattedTitle = makeFormattedTitle()
    
    init(imageName: String) {
        self.imageName = imageName
    }
}


// MARK: - Private Helper Methods

private extension Photo {
    func makeFormattedTitle() -> NSAttributedString {
        if let title = title {
            return DecoratedPhotoTitle.makeAttributedString(forTitle: title)
        } else {
            return DecoratedPhotoTitle.unnamedTitleString
        }
    }
}
