//
//  CityDetailsViewController.swift
//  City Facts
//
//  Created by Brian Sipple on 4/13/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class CityDetailsViewController: UIViewController {
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var detailsBodyView: UIView!
    
    var city: City!
    var detailsBodyViewController: CityDetailsBodyViewController!
    
    lazy var dayNightSegmentView = makeDayNightSegmentControl()
    
    var currentViewMode: CityViewMode = .day {
        didSet { viewModeChanged() }
    }
}


// MARK: - Lifecycle

extension CityDetailsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard city != nil else {
            preconditionFailure("No city was passed to `CityDetailsViewController`")
        }
        
        setupViews()
        setupUI()
    }
}


// MARK: - Computed Properties

extension CityDetailsViewController {
    var currentHeaderImageName: String {
        return currentViewMode == .day ? city.dayImageName : city.nightImageName
    }
}


// MARK: - Navigation

extension CityDetailsViewController {
}


// MARK: - Event handling

extension CityDetailsViewController {
    @objc func contentModeChanged(_ sender: UISegmentedControl) {
        currentViewMode = sender.selectedSegmentIndex == 0 ? .day : .night
    }
}


// MARK: - Private Helper Methods

private extension CityDetailsViewController {
    func makeDayNightSegmentControl() -> UISegmentedControl {
        let segmentControl = UISegmentedControl(items: ["☀️ Day", "🌒 Night"])
        
        segmentControl.sizeToFit()
        segmentControl.addTarget(self, action: #selector(contentModeChanged(_:)), for: .valueChanged)
        
        return segmentControl
    }
    
    
    func setupViews() {
        detailsBodyViewController = CityDetailsBodyViewController()
        detailsBodyViewController.city = city

        add(child: detailsBodyViewController, toView: detailsBodyView)
    }

    
    func setupUI() {
        navigationItem.titleView = dayNightSegmentView
        currentViewMode = .day
    }
    
    
    func viewModeChanged() {
        headerImageView.image = UIImage(named: currentHeaderImageName)
        detailsBodyViewController.currentViewMode = currentViewMode
        
        switch currentViewMode {
        case .day:
            dayNightSegmentView.selectedSegmentIndex = 0
        case .night:
            dayNightSegmentView.selectedSegmentIndex = 1
        }
    }
}
