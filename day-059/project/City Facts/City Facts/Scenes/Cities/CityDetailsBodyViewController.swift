//
//  CityDetailsBodyViewController.swift
//  City Facts
//
//  Created by Brian Sipple on 4/13/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class CityDetailsBodyViewController: UIViewController {
    @IBOutlet weak var cityNameLabel: UILabel!
    
    var city: City!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard city != nil else {
            preconditionFailure("No city was passed to `CityDetailsViewController`")
        }
        
        setupUI()
    }
}


// MARK: - Private Helper Methods

private extension CityDetailsBodyViewController {
    func setupUI() {
        cityNameLabel.text = city.name
    }
}
