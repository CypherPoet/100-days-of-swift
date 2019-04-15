//
//  CityTableDataSource.swift
//  City Facts
//
//  Created by Brian Sipple on 4/15/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class CityCollectionDataSource: NSObject {
    var cities: [City] = []
}

extension CityCollectionDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cities.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryboardID.cityCell, for: indexPath)
            as? CityCollectionViewCell
            else {
                fatalError("Failed to deque city cell from collection view")
        }
        
        cell.configure(with: cities[indexPath.item])
        
        return cell
    }
}
