//
//  ActionViewController.swift
//  My Sweet HWS Extension
//
//  Created by Brian Sipple on 1/30/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {
    @IBOutlet weak var scriptTextView: UITextView!
    
    private lazy var notificationCenter = NotificationCenter.default
    private var injectionPresets: [Injection] = []
    private var selectedJavaScriptText: String = ""
    
    private let keyboardNotificationNames = [
        UIResponder.keyboardWillHideNotification,
        UIResponder.keyboardWillChangeFrameNotification
    ]
    
    var currentPageSnapshot: PageSnapshot! {
        didSet {
            if let pageSnapshot = currentPageSnapshot {
                didTake(pageSnapshot)
            }
        }
    }
}


// MARK: - Computeds

extension ActionViewController {
    
    var userJavaScriptExtensionItem: NSExtensionItem {
        let argument: NSDictionary = ["userJavaScript": selectedJavaScriptText]

        // 🔑 This is what will be sent as the argument to our script's `finalize` function
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        
        let customJSProvider = NSItemProvider(
            item: webDictionary,
            typeIdentifier: kUTTypePropertyList as String
        )
        
        let extensionItem = NSExtensionItem()
        extensionItem.attachments = [customJSProvider]
        
        return extensionItem
    }
    
    
    var scriptPresetActions: [UIAlertAction] {
        return injectionPresets.map { injection in
            return UIAlertAction(title: injection.title, style: .default, handler: { [weak self] _ in
                self?.selectedJavaScriptText = injection.evalString
                self?.exitExtension()
            })
        }
    }
}


// MARK: - Lifecycle

extension ActionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNotificationObservers()
        loadInjectionOptions()
        processItemProvider()
    }
}


// MARK: - Event/Action handling

extension ActionViewController {
    
    @IBAction func promptForScriptPresets(_ sender: UIBarButtonItem) {
        let alertVC = UIAlertController(
            title: "JavaScript Presets",
            message: "Select a script to run on \(currentPageSnapshot.title)",
            preferredStyle: .actionSheet
        )
        
        scriptPresetActions.forEach { alertVC.addAction($0) }
        
        present(alertVC, animated: true)
    }
    

    @IBAction func extensionCompleted() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        exitExtension()
    }
    
    
    @objc func keyboardDidMove(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        
        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keybardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            // 🔑 workaround for hardware keyboards being connected
            scriptTextView.contentInset = UIEdgeInsets.zero
        } else {
            scriptTextView.contentInset = UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: keybardViewEndFrame.height,
                right: 0
            )
        }
        
        scriptTextView.scrollIndicatorInsets = scriptTextView.contentInset
        
        // scroll to the current positoin of the text entry cursor if it's off screen
        scriptTextView.scrollRangeToVisible(scriptTextView.selectedRange)
    }
}


// MARK: - Private Helper Methods

private extension ActionViewController {
    
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
    
    
    func loadInjectionOptions() {
        guard let presetURL = Bundle.main.url(forResource: "injection-presets", withExtension: "json") else {
            preconditionFailure("Failed to load injection presets from Bundle")
        }
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            do {
                let presetData = try Data(contentsOf: presetURL)
                let decoder = JSONDecoder()
                let injections = try decoder.decode([Injection].self, from: presetData)
                
                DispatchQueue.main.async {
                    self?.injectionPresets = injections
                }
            } catch {
                fatalError("Error while loading injection presets:\n\n\(error.localizedDescription)")
            }
        }

    }
    
    
    func processItemProvider() {
        // `inputItems` should be an array of data that the parent app is sending to our extension to use
        guard let inputItem = extensionContext!.inputItems.first as? NSExtensionItem else { return }
        
        // Our input item contains an array of attachments, which are given to us wrapped up as an `NSItemProvider`
        guard let itemProvider = inputItem.attachments?.first else { return }
        
        let typeIdentifier = kUTTypePropertyList as String
        
        // After finding the provider, we need to ask it to actually provide us with its item
        itemProvider.loadItem(
            forTypeIdentifier: typeIdentifier,
            options: nil,
            completionHandler: { [weak self] (dict, error) in
                guard
                    let itemDictionary = dict as? NSDictionary,
                    let javaScriptData = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary
                else {
                    DispatchQueue.main.async {
                        self?.display(alertMessage: "Failed to find data for current webpage.")
                    }
                    return
                }
                
                if let pageSnapshot = self?.pageSnapshot(from: javaScriptData) {
                    DispatchQueue.main.async {
                        self?.currentPageSnapshot = pageSnapshot
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.display(alertMessage: "Failed to find data for current webpage.")
                    }
                }
            }
        )
    }
    
    
    func pageSnapshot(from javaScriptData: NSDictionary) -> PageSnapshot? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: javaScriptData)
            let decoder = JSONDecoder()
            
            return try decoder.decode(PageSnapshot.self, from: jsonData)
        } catch {
            print("Error while attempting to take page snapshot: \(error.localizedDescription)")
            return nil
        }
    }
    
    
    func didTake(_ pageSnapshot: PageSnapshot) {
        title = pageSnapshot.title
    }
    
    
    func exitExtension() {
        extensionContext!.completeRequest(
            returningItems: [userJavaScriptExtensionItem],
            completionHandler: nil
        )
    }
}
