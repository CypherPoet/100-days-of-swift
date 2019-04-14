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

    enum ViewMode {
        case day, night
    }
    
    var city: City!
    lazy var dayNightSegmentView = makeDayNightSegmentControl()
    
    var currentViewMode: ViewMode = .day {
        didSet {
            headerImageView.image = UIImage(named: currentHeaderImageName)
            // TODO: update child view here?
        }
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: dayNightSegmentView)
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


// MARK: - Private Helper Methods

private extension CityDetailsViewController {
    func makeDayNightSegmentControl() -> UISegmentedControl {
        let segmentControl = UISegmentedControl(items: ["☀️ Day", "🌒 Night"])
        
        return segmentControl
    }
    
    
    func setupViews() {
        let cityDetailsBodyVC = CityDetailsBodyViewController()
        cityDetailsBodyVC.city = city

        add(child: cityDetailsBodyVC, toView: detailsBodyView)
    }

    
    func setupUI() {
        currentViewMode = .day
    }
}
