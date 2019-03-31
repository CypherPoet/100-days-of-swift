//
//  UIViewController+URLForFileName.swift
//  SnapGallery
//
//  Created by Brian Sipple on 3/30/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

extension UIViewController {
    func url(forFileName fileName: String) -> URL {
        guard let documentsDirectoryURL = FileManager
            .default.urls(for: .documentDirectory, in: .userDomainMask).first
            else {
                fatalError("Unable to find documents director URL")
        }
        
        return documentsDirectoryURL.appendingPathComponent(fileName)
    }
}

