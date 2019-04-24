//
//  StormDetailViewController.swift
//  Storm Viewer
//
//  Created by Brian Sipple on 1/12/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class StormDetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var viewCountLabel: UILabel!
    
    lazy var userDefaults = UserDefaults.standard
    
    var displayImage: DisplayImage!
    var imageNumber: Int!
    var totalImageCount: Int!
}


// MARK: - Lifecycle

extension StormDetailViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavbar()
        imageView.image = UIImage(named: displayImage.imagePath)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnTap = true
        viewCountLabel.text = "View Count: \(displayImage.timesViewed + 1)"
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        displayImage.timesViewed += 1
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.hidesBarsOnTap = false
    }
}



// MARK: - Computed Properties

extension StormDetailViewController {
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        get {
            return navigationController?.hidesBarsOnTap ?? false
        }
    }
}


// MARK: - Event handling

extension StormDetailViewController {
    @objc func shareButtonTapped() {
        guard let imageData = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print("No image data found")
            return
        }
        
        let viewController = UIActivityViewController(activityItems: [imageData, displayImage.imageName], applicationActivities: nil)
        
        viewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(viewController, animated: true)
    }
}


// MARK: - Private Helper Methods

extension StormDetailViewController {
    func setupNavbar() {
        title = "Picture \(imageNumber!) of \(totalImageCount!)"
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonTapped))
    }
}
