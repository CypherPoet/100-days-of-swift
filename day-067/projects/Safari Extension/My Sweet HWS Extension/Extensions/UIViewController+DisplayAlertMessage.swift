//
//  UIViewController+DisplayMessage.swift
//  My Sweet HWS Extension
//
//  Created by Brian Sipple on 4/28/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//


import UIKit

extension UIViewController {
    func display(
        alertMessage: String,
        title: String = "",
        completionHandler: ((UIAlertAction) -> Void)? = nil
    ) {
        let alertController = UIAlertController(
            title: title,
            message: alertMessage,
            preferredStyle: .alert
        )
        
        alertController.addAction(
            UIAlertAction(title: "OK", style: .default, handler: completionHandler)
        )
        
        present(alertController, animated: true)
    }
}

