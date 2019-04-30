//
//  MainActionViewController.swift
//  My Sweet HWS Extension
//
//  Created by Brian Sipple on 1/30/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit
import MobileCoreServices

class MainActionViewController: UITableViewController {
    @IBOutlet weak var siteHistoryButton: UIBarButtonItem!
    
    private lazy var userDefaults = UserDefaults.standard
    
    private var injectionPresets: [Injection] = []
    private var previousSiteInjections: [Injection] = []
    
    private var customSiteInjections: [Injection] = [] {
        didSet {
            userDefaults.set(customSiteInjections, forKey: Keys.UserDefaults.customInjections)
        }
    }
    
    private var selectedJavaScriptText: String = ""
    
    var currentPageSnapshot: PageSnapshot! {
        didSet {
            if let pageSnapshot = currentPageSnapshot {
                didTake(pageSnapshot)
            }
        }
    }
}


// MARK: - Computeds

extension MainActionViewController {
    
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
}


// MARK: - Lifecycle

extension MainActionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadInjectionPresets()
        loadPreviousSiteInjections()
        loadCustomInjections()
        processItemProvider()
    }
}


// MARK: - Event/Action handling

extension MainActionViewController {
    
    @IBAction func promptForScriptPresets(_ sender: UIBarButtonItem) {
        let alertVC = UIAlertController(
            title: "JavaScript Presets",
            message: "Select a script to run on \(currentPageSnapshot.title)",
            preferredStyle: .actionSheet
        )
        
        alertActionsFor(injectionPresets).forEach { alertVC.addAction($0) }
        
        present(alertVC, animated: true)
    }
    
    
    @IBAction func promptForPreviousSiteScripts(_ sender: UIBarButtonItem) {
        let alertVC = UIAlertController(
            title: "Site History",
            message: "Script you previously ran on \(currentPageSnapshot.title)",
            preferredStyle: .actionSheet
        )
        
        alertActionsFor(previousSiteInjections).forEach { alertVC.addAction($0) }
        
        present(alertVC, animated: true)
    }
    

    @IBAction func extensionCompleted() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        exitExtension()
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        extensionContext?.completeRequest(returningItems: nil)
    }
}


// MARK: - Navigation

extension MainActionViewController {
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == StoryboardID.Segue.presentEditInjectionScriptView,
            let editScriptVC = segue.destination.children.first as? EditScriptViewController
        else { return }
        
        editScriptVC.pageSnapshot = currentPageSnapshot
    }
    
    
    @IBAction func unwindFromCancelNewScript(unwindSegue: UIStoryboardSegue) {}
    
    
    @IBAction func unwindFromSaveNewScript(unwindSegue: UIStoryboardSegue) {
        guard let editScriptVC = unwindSegue.source as? EditScriptViewController else { return }
        
//        if editScriptVC.isNewScript {
            customInjectionCreated(editScriptVC.injectionScript)
//        } else {
//            // get selected index path
//            // update custom scripts array at the selected row
//        }
    }
}


// MARK: - Private Helper Methods

private extension MainActionViewController {
    
    func loadInjectionPresets() {
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
    
    
    func loadPreviousSiteInjections() {
        if let injections = userDefaults.object(forKey: Keys.UserDefaults.siteSpecificInjections) as? [Injection] {
            previousSiteInjections = injections
        } else {
            siteHistoryButton.isEnabled = false
        }
    }
    
    
    func loadCustomInjections() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let injections = self?
                .userDefaults.object(forKey: Keys.UserDefaults.customInjections)
                as? [Injection]
            {
                DispatchQueue.main.async {
                    self?.customSiteInjections = injections
                    self?.tableView.reloadData()
                }
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
    
    
    func alertActionsFor(_ injections: [Injection]) -> [UIAlertAction] {
        return injections.map { injection in
            return UIAlertAction(title: injection.title, style: .default, handler: { [weak self] _ in
                self?.selectedJavaScriptText = injection.evalString
                self?.exitExtension()
            })
        }
    }
    
    
    func customInjectionCreated(_ injection: Injection) {
        let indexPath = IndexPath(row: 0, section: 0)
        
        customSiteInjections.insert(injection, at: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
}
