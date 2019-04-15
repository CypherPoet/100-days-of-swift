//
//  CityListViewController.swift
//  City Facts
//
//  Created by Brian Sipple on 4/13/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class CityListViewController: UICollectionViewController {
    var dataSource = CityCollectionDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = dataSource
        loadCities()
    }
}


// MARK: - Navigation

extension CityListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let cityDetailsVC = segue.destination as? CityDetailsViewController,
            let selectedCell = sender as? CityCollectionViewCell,
            let indexPath = collectionView.indexPath(for: selectedCell)
        else {
            preconditionFailure("Unable to find indexPath for selected cell during segue to CityDetailsViewController")
        }

        cityDetailsVC.city = dataSource.cities[indexPath.item]
    }
}


// MARK: - Private Helper Methods

extension CityListViewController {
    
    func loadCities() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let dataURL = Bundle.main.url(forResource: "city-data", withExtension: "json") {
                do {
                    let cityLoader = CityLoader()
                    let cityData = try Data(contentsOf: dataURL)
                    
                    let cities = try cityLoader.decodeCities(from: cityData)
                    
                    DispatchQueue.main.async {
                        self?.dataSource.cities = cities
                        self?.collectionView.reloadData()
                    }
                } catch {
                    DispatchQueue.main.async {
                        self?.showError(error, title: "Error while trying to load city data")
                        print(error)
                    }
                }
            } else {
                preconditionFailure("Unable to find city data")
            }
        }
        
    }
}
