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
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var yearFoundedLabel: UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    @IBOutlet weak var lastCensusYearLabel: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    
    @IBOutlet var viewLabels: [UILabel]!
    
    var city: City!
    
    var currentViewMode: CityViewMode = .day {
        didSet { viewModeChanged() }
    }
    
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
        countryNameLabel.text = "Country: \(city.country)"
        yearFoundedLabel.text = "Year Founded: \(city.formattedYearFounded)"
        populationLabel.text = "Population: \(city.formattedPopulation)"
        lastCensusYearLabel.text = "(Last Census: \(city.lastCensusYear))"
        descriptionText.text = city.description
    }
    
    
    func viewModeChanged() {
        switch currentViewMode {
        case .day:
            view.backgroundColor = Style.DayView.backgroundColor
            viewLabels.forEach { $0.textColor = Style.DayView.textColor }
            descriptionText.textColor = Style.DayView.textColor
        case .night:
            view.backgroundColor = Style.NightView.backgroundColor
            viewLabels.forEach { $0.textColor = Style.NightView.textColor }
            descriptionText.textColor = Style.NightView.textColor
        }
    }
}
