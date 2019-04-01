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
    
//    var title: String? = nil
    
    var title: String? = nil {
        didSet {
            smallFormattedTitle = makeSmallFormattedTitle()
            largeFormattedTitle = makeLargeFormattedTitle()
        }
    }
    
    lazy var smallFormattedTitle = makeSmallFormattedTitle()
    lazy var largeFormattedTitle = makeLargeFormattedTitle()
    
    init(imageName: String) {
        self.imageName = imageName
    }
}


// MARK: - Private Helper Methods

private extension Photo {
    func makeSmallFormattedTitle() -> NSAttributedString {
        if let title = title {
            let finalString = NSMutableAttributedString()
            
            for letter in title {
                finalString.append(DecoratedPhotoTitle.makeAttributedString(for: String(letter)))
            }
            
            return finalString
        } else {
            return DecoratedPhotoTitle.unnamedTitleString
        }
    }
    
    
    func makeLargeFormattedTitle() -> NSAttributedString {
        if let title = title {
            let finalString = NSMutableAttributedString()
            
            for letter in title {
                finalString.append(DecoratedPhotoTitle.makeAttributedString(for: String(letter)))
            }
            
            return finalString
        } else {
            return DecoratedPhotoTitle.unnamedTitleString
        }
    }
}
