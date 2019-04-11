//
//  UIButton+HideFromGame.swift
//  Seven Swifty Words
//
//  Created by Brian Sipple on 4/11/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

extension UIButton {
    func hideFromGame() {
        UIView.animate(
            withDuration: 0.125,
            delay: 0,
            options: [.curveEaseOut],
            animations: {
                self.alpha = 0
            }
        )
    }
    
    func unhideFromGame() {
        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            options: [.curveEaseOut],
            animations: {
                self.alpha = 1
            }
        )
    }
}
