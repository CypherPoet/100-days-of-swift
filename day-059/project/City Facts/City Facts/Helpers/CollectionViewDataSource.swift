//
//  CollectionViewDataSource.swift
//  City Facts
//
//  Created by Brian Sipple on 4/15/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class CollectionViewDataSource<Model>: NSObject, UICollectionViewDataSource {
    typealias CellConfigurator = (Model, UICollectionViewCell) -> Void
    
    var models: [Model] = []
    
    private let cellReuseIdentifier: String
    private let cellConfigurator: CellConfigurator
    
    
    init(
        models: [Model],
        cellReuseIdentifier: String,
        cellConfigurator: @escaping CellConfigurator
    ) {
        self.models = models
        self.cellReuseIdentifier = cellReuseIdentifier
        self.cellConfigurator = cellConfigurator
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath)
        let model = models[indexPath.item]
        
        cellConfigurator(model, cell)
        
        return cell
    }
}
