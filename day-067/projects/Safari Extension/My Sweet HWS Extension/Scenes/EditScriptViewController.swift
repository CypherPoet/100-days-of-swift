//
//  EditScriptViewController.swift
//  My Sweet HWS Extension
//
//  Created by Brian Sipple on 4/29/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class EditScriptViewController: UIViewController {
    @IBOutlet weak var scriptTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var introLabel: UILabel!
    
    private lazy var notificationCenter = NotificationCenter.default

    private let keyboardNotificationNames = [
        UIResponder.keyboardWillHideNotification,
        UIResponder.keyboardWillChangeFrameNotification
    ]
    
    var injectionScript = Injection(title: "", evalString: "") {
        didSet {
            saveButton.isEnabled = !injectionScript.title.isEmpty && !injectionScript.evalString.isEmpty
        }
    }
    
    var pageSnapshot: PageSnapshot! {
        didSet { injectionScript.siteURL = pageSnapshot.url }
    }
}


// MARK: - Lifecycle

extension EditScriptViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let _ = pageSnapshot else {
            preconditionFailure("No page snapshot data found for new script")
        }
        
        scriptTextView.delegate = self
        
        setupNotificationObservers()
        setupUI()
    }
}


// MARK: - Event handling

extension EditScriptViewController {
    
    @objc func keyboardDidMove(notification: NSNotification) {
        if let edgeInsets = edgeInsetsFromKeyboardChange(notification) {
            scriptTextView.contentInset = edgeInsets
            scriptTextView.scrollIndicatorInsets = edgeInsets
            
            // scroll to the current position of the text entry cursor if it's off screen
            scriptTextView.scrollRangeToVisible(scriptTextView.selectedRange)
        }
    }
    
    
    @IBAction func titleTextChanged(_ textField: UITextField) {
        injectionScript.title = textField.text ?? ""
    }
}


// MARK: - UITextViewDelegate

extension EditScriptViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.3, animations: {
            self.introLabel.alpha = 0
        })
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        injectionScript.evalString = textView.text
    }
}


// MARK: - Private Helper Methods

private extension EditScriptViewController {
    
    func setupNotificationObservers() {
        for notificationName in keyboardNotificationNames {
            notificationCenter.addObserver(
                self,
                selector: #selector(keyboardDidMove(notification:)),
                name: notificationName,
                object: nil
            )
        }
    }
    
    
    func setupUI() {
        scriptTextView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        introLabel.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        introLabel.text = """
        Enter the JavaScript that you'd like to run on \(pageSnapshot.url.host ?? "this site").
        """
        
        title =  pageSnapshot.url.host
    }
}
