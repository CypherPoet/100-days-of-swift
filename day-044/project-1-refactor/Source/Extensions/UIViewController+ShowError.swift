//
//  UIViewController+ShowError.swift
//  Storm Viewer
//
//  Created by Brian Sipple on 3/17/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

extension UIViewController {
    func showError(
        _ error: Error,
        title: String = "",
        completionHandler: ((UIAlertAction) -> Void)? = nil
        ) {
        let alertController = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: completionHandler))
        present(alertController, animated: true)
    }
}
