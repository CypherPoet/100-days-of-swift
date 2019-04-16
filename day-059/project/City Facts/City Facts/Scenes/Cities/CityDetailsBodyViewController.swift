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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        calculatePreferredSize()
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
        descriptionText.text = city.description + city.description + city.description
    }
    
    
    func viewModeChanged() {
        switch currentViewMode {
        case .day:
            view.backgroundColor = .white
            viewLabels.forEach { $0.textColor = #colorLiteral(red: 0.2123888731, green: 0.234394908, blue: 0.3121399283, alpha: 1) }
            descriptionText.textColor = #colorLiteral(red: 0.2123888731, green: 0.234394908, blue: 0.3121399283, alpha: 1)
        case .night:
            view.backgroundColor = #colorLiteral(red: 0.2123888731, green: 0.234394908, blue: 0.3121399283, alpha: 1)
            viewLabels.forEach { $0.textColor = #colorLiteral(red: 0.8934791684, green: 0.5303660035, blue: 1, alpha: 1) }
            descriptionText.textColor = #colorLiteral(red: 0.8934791684, green: 0.5303660035, blue: 1, alpha: 1)
        }
    }
    
    
    func calculatePreferredSize() {
        let targetSize = CGSize(
            width: view.bounds.width,
            height: UIView.layoutFittingCompressedSize.height
        )
        
        preferredContentSize = view.systemLayoutSizeFitting(targetSize)
    }
}
