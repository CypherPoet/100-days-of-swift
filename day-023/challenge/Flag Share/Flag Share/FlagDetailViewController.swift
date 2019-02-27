//
//  FlagDetailViewController.swift
//  Flag Share
//
//  Created by Brian Sipple on 2/26/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class FlagDetailViewController: UIViewController {
    @IBOutlet var flagImageView: UIImageView!
    
    var flag: Flag! = nil
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        flagImageView.image = UIImage(named: flag.assetName)
        setupNavbar()
    }
    
    
    // MARK: - Event handling
    
    @objc func shareButtonTapped() {
        let activityController = UIActivityViewController(
            activityItems: [flagImageView.image!, flag.displayName],
            applicationActivities: nil
        )
        
        activityController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(activityController, animated: true)
    }
    

    // MARK: - Helper functions
    
    func setupNavbar() {
        title = flag.displayName
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(shareButtonTapped)
        )
    }
}
