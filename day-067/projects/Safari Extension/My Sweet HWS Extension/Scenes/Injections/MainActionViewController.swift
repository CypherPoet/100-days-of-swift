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
    
    private var dataSource: TableViewDataSource<Injection>!
    private var selectedJavaScriptText: String = ""
    
    private var viewModel: InjectionListViewModel!
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
        
        processItemProvider()
    }
}


// MARK: - Event/Action handling

extension MainActionViewController {
    
    @IBAction func promptForScriptPresets(_ sender: UIBarButtonItem) {
        let alertVC = UIAlertController(
            title: "JavaScript Presets",
            message: "Select a script to run on \(viewModel.title)",
            preferredStyle: .actionSheet
        )
        
        alertActionsFor(viewModel.injectionPresets).forEach { alertVC.addAction($0) }
        
        present(alertVC, animated: true)
    }
    
    
    @IBAction func promptForPreviousSiteScripts(_ sender: UIBarButtonItem) {
        let alertVC = UIAlertController(
            title: "Site History",
            message: "Scripts previously ran on \(viewModel.title)",
            preferredStyle: .actionSheet
        )
        
        alertActionsFor(viewModel.previousSiteInjections).forEach { alertVC.addAction($0) }
        
        present(alertVC, animated: true)
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        extensionContext?.completeRequest(returningItems: nil)
    }
}


// MARK: - Navigation

extension MainActionViewController {
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == StoryboardID.Segue.presentAddEditInjectionScriptView,
            let viewController = segue.destination.children.first as? AddEditScriptViewController
        else { return }
        
        viewController.pageSnapshot = viewModel.currentPageSnapshot
    }
    
    
    @IBAction func unwindFromCancelNewScript(unwindSegue: UIStoryboardSegue) {}
    
    
    @IBAction func unwindFromSaveNewScript(unwindSegue: UIStoryboardSegue) {
        guard let editScriptVC = unwindSegue.source as? AddEditScriptViewController else { return }
        
//        if editScriptVC.isNewScript {
            customInjectionCreated(editScriptVC.injectionScript)
//        } else {
//            // get selected index path
//            // update custom scripts array at the selected row
//        }
    }
}



// MARK: - UITableViewDelegate

extension MainActionViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let injection = dataSource.models[indexPath.row]
        
        selectedJavaScriptText = injection.evalString
        print("New `selectedJavaScriptText`: \(selectedJavaScriptText)")
        exitExtension()
    }
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete", handler: deleteActionSelected)
        let edit = UITableViewRowAction(style: .normal, title: "Edit", handler: editActionSelected)
        
        edit.backgroundColor = .blue
        
        return [delete, edit]
    }
}


// MARK: - Private Helper Methods

private extension MainActionViewController {
    
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
                
                let pageSnapshot: PageSnapshot = .make(from: javaScriptData)
                
                DispatchQueue.main.async {
                    self?.setupViewModel(with: pageSnapshot)
                }
            }
        )
    }
    
    
    func setupViewModel(with pageSnapshot: PageSnapshot) {
        viewModel = InjectionListViewModel(currentPageSnapshot: pageSnapshot)
        title = viewModel.title
        
        viewModel.start { [weak self] (injections) in
            guard let self = self else { return }
            
            let dataSource: TableViewDataSource<Injection> = .make(for: injections)
            
            DispatchQueue.main.async {
                self.dataSource = dataSource
                self.tableView.dataSource = dataSource
                self.siteHistoryButton.isEnabled = self.viewModel.hasPreviousSiteInjections
                self.tableView.reloadData()
            }
        }
    }
    
    
    func exitExtension() {
        extensionContext!.completeRequest(
            returningItems: [userJavaScriptExtensionItem],
            completionHandler: nil
        )
    }
    
    
    func alertActionsFor(_ injections: [Injection]) -> [UIAlertAction] {
        let injectionActions = injections.map { injection in
            return UIAlertAction(title: injection.title, style: .default, handler: { [weak self] _ in
                self?.selectedJavaScriptText = injection.evalString
                self?.exitExtension()
            })
        }
        
        return injectionActions + [UIAlertAction(title: "Cancel", style: .cancel)]
    }
    
    
    func customInjectionCreated(_ injection: Injection) {
        viewModel.saveCustom(injection) { [weak self] _ in
            let indexPath = IndexPath(row: 0, section: 0)
            
            self?.dataSource.models.insert(injection, at: 0)
            self?.tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    
    func deleteActionSelected(action: UITableViewRowAction, indexPath: IndexPath) {
        viewModel.delete(customInjectionAt: indexPath.row) { [weak self] _ in
            DispatchQueue.main.async {
                self?.dataSource.models.remove(at: indexPath.row)
                self?.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    
    func editActionSelected(action: UITableViewRowAction, indexPath: IndexPath) {
        performSegue(withIdentifier: StoryboardID.Segue.presentAddEditInjectionScriptView, sender: self)
    }
}
