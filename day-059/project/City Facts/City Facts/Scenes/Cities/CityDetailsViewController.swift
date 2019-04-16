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
    @IBOutlet weak var detailsBodyHeightConstraint: NSLayoutConstraint!
    
    var city: City!
    var detailsBodyViewController: CityDetailsBodyViewController!
    
    lazy var dayNightSegmentView = makeDayNightSegmentControl()
    
    var currentViewMode: CityViewMode = .day {
        didSet { viewModeChanged() }
    }
    
    private var originalNavbarTintColor: UIColor!
    private var originalNavbarBackgroundColor: UIColor!
}


// MARK: - Lifecycle

extension CityDetailsViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        originalNavbarTintColor = navigationController?.navigationBar.barTintColor
        originalNavbarBackgroundColor = navigationController?.navigationBar.backgroundColor
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.barTintColor = originalNavbarTintColor
        navigationController?.navigationBar.backgroundColor = originalNavbarBackgroundColor
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard city != nil else {
            preconditionFailure("No city was passed to `CityDetailsViewController`")
        }
        
        setupViews()
        setupUI()
    }
    
    
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)
        
        if let detailsBodyViewController = container as? CityDetailsBodyViewController {
//            detailsBodyHeightConstraint.constant = detailsBodyViewController.preferredContentSize.height
        }
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
//        detailsBodyViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        add(child: detailsBodyViewController, toView: detailsBodyView)
    }

    
    func setupUI() {
        navigationItem.titleView = dayNightSegmentView
        currentViewMode = .day
    }
    
    
    func viewModeChanged() {
        headerImageView.image = UIImage(named: currentHeaderImageName)
        detailsBodyViewController.currentViewMode = currentViewMode
        styleNavbar(for: currentViewMode)
        
        switch currentViewMode {
        case .day:
            dayNightSegmentView.selectedSegmentIndex = 0
        case .night:
            dayNightSegmentView.selectedSegmentIndex = 1
        }
    }
    
    
    func styleNavbar(for viewMode: CityViewMode) {
        switch viewMode {
        case .day:
            navigationController?.navigationBar.barTintColor = .white
            navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.2123888731, green: 0.234394908, blue: 0.3121399283, alpha: 1)
            view.backgroundColor = .white
            view.tintColor = UIColor.darkText
        case .night:
            navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.2123888731, green: 0.234394908, blue: 0.3121399283, alpha: 1)
            navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.8934791684, green: 0.5303660035, blue: 1, alpha: 1)
            view.backgroundColor = #colorLiteral(red: 0.2123888731, green: 0.234394908, blue: 0.3121399283, alpha: 1)
            view.tintColor = #colorLiteral(red: 0.8934791684, green: 0.5303660035, blue: 1, alpha: 1)
        }
    }
}
