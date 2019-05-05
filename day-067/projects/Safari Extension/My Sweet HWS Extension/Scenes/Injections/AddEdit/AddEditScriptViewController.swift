//
//  EditScriptViewController.swift
//  My Sweet HWS Extension
//
//  Created by Brian Sipple on 4/29/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class AddEditScriptViewController: UIViewController {
    @IBOutlet weak var scriptTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    
    var viewModel: AddEditInjectionViewModel!
    var savedInjection: Injection?
    
    private lazy var notificationCenter = NotificationCenter.default

    private let keyboardNotificationNames = [
        UIResponder.keyboardWillHideNotification,
        UIResponder.keyboardWillChangeFrameNotification
    ]
}


// MARK: - Computed Properties

extension AddEditScriptViewController {
    var canSaveChanges: Bool {
        return (
            titleTextField.hasText &&
            scriptTextView.hasText
        )
    }
    
    var injectionChanges: AddEditInjectionViewModel.Changes {
        return (
            title: titleTextField.text ?? "",
            scriptText: scriptTextView.text ?? ""
        )
    }
    
    
    var isNewInjection: Bool {
        return viewModel.isNewInjection
    }
}


// MARK: - Lifecycle

extension AddEditScriptViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure(with: viewModel)
        
        scriptTextView.delegate = self
        
        setupNotificationObservers()
        setupUI()
    }
}


// MARK: - Event handling

extension AddEditScriptViewController {
    
    @objc func keyboardDidMove(notification: NSNotification) {
        if let edgeInsets = edgeInsetsFromKeyboardChange(notification) {
            scriptTextView.contentInset = edgeInsets
            scriptTextView.scrollIndicatorInsets = edgeInsets
            
            // scroll to the current position of the text entry cursor if it's off screen
            scriptTextView.scrollRangeToVisible(scriptTextView.selectedRange)
        }
    }
    
    
    @IBAction func titleTextChanged(_ textField: UITextField) {
        saveButton.isEnabled = canSaveChanges
    }
    
    
    @IBAction func saveButtonTapped(_ button: UIBarButtonItem) {
        // 🔑 This is where a light-weight observable paradigm REALLY starts to come in handy
        // (e.g.: https://github.com/DeclarativeHub/Bond)
        viewModel.update(with: injectionChanges) { [weak self] outcome in
            guard let self = self else { return }
            
            switch outcome {
            case .success(let injection):
                self.savedInjection = injection
                self.performSegue(withIdentifier: StoryboardID.Segue.unwindFromSavingInjectionScript, sender: self)
            case .failure:
                // 📝 Note: Also a failure: This current level of validation and error handling 😂
                self.display(alertMessage: "The data you entered was invalid", title: "Save failed")
            }
        }
    }
}


// MARK: - UITextViewDelegate

extension AddEditScriptViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.3, animations: {
            self.introLabel.alpha = 0
        })
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        saveButton.isEnabled = canSaveChanges
    }
}


// MARK: - Private Helper Methods

private extension AddEditScriptViewController {
    
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
        scriptTextView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        introLabel.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        saveButton.isEnabled = canSaveChanges
    }
    
    
    func configure(with viewModel: AddEditInjectionViewModel) {
        introLabel.text = viewModel.introLabelText
        title =  viewModel.pageTitle
        
        titleTextField.text = viewModel.injection.title
        scriptTextView.text = viewModel.injection.evalString
    }
}
