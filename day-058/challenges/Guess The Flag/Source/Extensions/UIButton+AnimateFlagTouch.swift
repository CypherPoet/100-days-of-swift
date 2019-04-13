//
//  UIButton+AnimateFlagTouch.swift
//  Guess the Flag
//
//  Created by Brian Sipple on 4/12/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit


extension UIButton {

    func animateFlagTouchDown() {
        UIView.animate(
            withDuration: 0.2,
            delay: 0.0,
            options: [.curveEaseOut],
            animations: {
                self.transform = CGAffineTransform.init(scaleX: 0.8, y: 0.8)
            }
        )
    }


    func animateFlagTouchUp() {
        UIView.animate(
            withDuration: 0.2,  // 📝 A further adavancement would be to store these durations as constants
            delay: 0.0,
            usingSpringWithDamping: 0.19,
            initialSpringVelocity: 7.0,
            options: [.curveEaseIn],
            animations: {
                self.transform = CGAffineTransform.identity
            }
        )
    }
    
}
