//
//  CitiesListViewController.swift
//  City Facts
//
//  Created by Brian Sipple on 4/13/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class CitiesListViewController: UICollectionViewController {
    var cities: [City] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCities()
    }
}


// MARK: - Data Source

extension CitiesListViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryboardID.cityCell, for: indexPath)
            as? CityCollectionViewCell
        else {
            fatalError("Failed to deque city cell from collection view")
        }
        
        cell.configure(with: cities[indexPath.item])
        
        return cell
    }
}


// MARK: - Navigation

extension CitiesListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let cityDetailsVC = segue.destination as? CityDetailsViewController,
            let selectedCell = sender as? CityCollectionViewCell,
            let indexPath = collectionView.indexPath(for: selectedCell)
        else {
            preconditionFailure("Unable to find indexPath for selected cell during segue to CityDetailsViewController")
        }

        cityDetailsVC.city = cities[indexPath.item]
    }
}


// MARK: - Private Helper Methods

extension CitiesListViewController {
    func loadCities() {
        cities = [City(name: "Atlantis", thumbnailImageName: "nyc-thumbnail", dayImageName: "nyc-day", nightImageName: "nyc-night")]
    }
}
