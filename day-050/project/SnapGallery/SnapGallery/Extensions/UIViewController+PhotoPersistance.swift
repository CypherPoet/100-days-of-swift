//
//  UIViewController+SavePhotos.swift
//  SnapGallery
//
//  Created by Brian Sipple on 3/30/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

extension UIViewController {
    func save(photos: [Photo], toDefaults userDefaults: UserDefaults = UserDefaults.standard) {
        let encoder = JSONEncoder()
        
        do {
            let photosData = try encoder.encode(photos)
            userDefaults.set(photosData, forKey: UserDefaultsKey.photos)
        } catch {
            print("Error while attempting to encode photos data:\n\n\(error.localizedDescription)")
        }
    }
    
    
    func loadPhotos(fromDefaults userDefaults: UserDefaults = UserDefaults.standard) -> [Photo] {
        let decoder = JSONDecoder()
        
        if let photosData = userDefaults.object(forKey: UserDefaultsKey.photos) as? Data {
            do {
                return try decoder.decode([Photo].self, from: photosData)
            } catch {
                showError(error, title: "Error while attempting to decode photos data")
            }
        }
        
        return [Photo]()
    }
}
