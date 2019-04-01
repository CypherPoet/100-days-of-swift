//
//  PhotoViewController.swift
//  SnapGallery
//
//  Created by Brian Sipple on 4/1/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    @IBOutlet weak var photoImageView: UIImageView!
    
    var photoImage: UIImage! = nil
    var attributedPhotoTitle: NSAttributedString! = nil
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        setupNavbar()
    }
}


// MARK: - Private Helper Methods

extension PhotoDetailViewController {
    func setupNavbar() {
        navigationController?.navigationBar.backItem?.title = "Back"
        
        let titleLabel = UILabel()
        titleLabel.attributedText = attributedPhotoTitle
        titleLabel.baselineAdjustment = .alignCenters
        
        navigationItem.titleView = titleLabel
    }
    
    
    func setupUI() {
        photoImageView.image = photoImage
    }
}
