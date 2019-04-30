//
//  UIViewController+KeyboardViewChanges.swift
//  My Sweet HWS Extension
//
//  Created by Brian Sipple on 4/30/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /**
        Helper for computing a set of edge insets when a keyboard change notification fires.
     
        Use with observing notifications such as `UIResponder.keyboardWillHideNotification` and
        `UIResponder.keyboardWillChangeFrameNotification`
     
        (See: https://developer.apple.com/documentation/uikit/uiresponder/1621619-keyboarddidchangeframenotificati)
     */
    func edgeInsetsFromKeyboardChange(_ notification: NSNotification) -> UIEdgeInsets? {
        guard
            let userInfo = notification.userInfo,
            let frameValue = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)
        else { return nil }
        
        let keyboardScreenEndFrame = frameValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            return UIEdgeInsets.zero
        } else {
            return UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: keyboardViewEndFrame.height,
                right: 0
            )
        }
    }
}
