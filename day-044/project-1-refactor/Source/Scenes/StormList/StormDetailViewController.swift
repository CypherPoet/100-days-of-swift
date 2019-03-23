//
//  StormDetailViewController.swift
//  Storm Viewer
//
//  Created by Brian Sipple on 1/12/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class StormDetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    var imagePath: String!
    var imageNumber: Int!
    var totalImageCount: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavbar()
        imageView.image = UIImage(named: imagePath)
    }
}


// MARK: - Computed Properties

extension StormDetailViewController {
    
    var imageName: String {
        if let index = imagePath.firstIndex(of: ".") {
            return String(imagePath.prefix(upTo: index))
        } else {
            return imagePath
        }
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        get {
            return navigationController?.hidesBarsOnTap ?? false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
}


// MARK: - Event handling

extension StormDetailViewController {
    @objc func shareButtonTapped() {
        guard let imageData = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print("No image data found")
            return
        }
        
        let viewController = UIActivityViewController(activityItems: [imageData, imageName], applicationActivities: nil)
        
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
