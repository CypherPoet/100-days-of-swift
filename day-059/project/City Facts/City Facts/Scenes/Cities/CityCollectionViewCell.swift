//
//  CityCollectionViewCell.swift
//  City Facts
//
//  Created by Brian Sipple on 4/13/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class CityCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    

    func configure(with city: City) {
        imageView.image = UIImage(named: city.thumbnailImageName)
        cityNameLabel.text = city.name
    }
}
