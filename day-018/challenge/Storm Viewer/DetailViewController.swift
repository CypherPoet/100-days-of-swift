//
//  DetailViewController.swift
//  Storm Viewer
//
//  Created by Brian Sipple on 1/12/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    var imagePath: String?
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        get {
            return navigationController?.hidesBarsOnTap ?? false
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = imagePath
        navigationItem.largeTitleDisplayMode = .never
        
        if let _imagePath = imagePath {
            imageView.image = UIImage(named: _imagePath)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
