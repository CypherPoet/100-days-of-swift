//
//  UIButton+WikipediaMapCallout.swift
//  Capital Cities
//
//  Created by Brian Sipple on 4/17/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

extension UIButton {
    static var wikipediaMapCallout: UIButton {
        let buttonFrame = CGRect(x: 0, y: 0, width: 200, height: 40)
        let button = UIButton(frame: buttonFrame)
        
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 16),
            .foregroundColor: UIColor(hue: 0.72, saturation: 0.61, brightness: 0.95, alpha: 1.00),
        ]
        
        let attributedTitle = NSAttributedString(string: "View More on Wikipedia", attributes: titleAttributes)
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.lineBreakMode = .byWordWrapping
        
        return button
    }
}
