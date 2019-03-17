//
//  PetitionsListViewController.swift
//  Whitehouse Petitions
//
//  Created by Brian Sipple on 3/10/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class PetitionsListViewController: UITableViewController {
   
    // MARK: - Instance Properties
    
    let cellReuseIdentifier = "Petition Cell"
    let detailViewControllerIdentifier = "Petition Detail"
    var apiURLString = PetitionsAPI.recentPetitions

    var allPetitions: [Petition] = []
    var visiblePetitions: [Petition] = []
    
    lazy var filterAlertController = makeFilterAlertController()
    
    var filterText = "" {
        didSet { filterTextChanged() }
    }

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPetitions()
    }
}


// MARK: - Table view data source

extension PetitionsListViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visiblePetitions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        let petition = visiblePetitions[indexPath.row]
        
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = "\(petition.signatureCount) signatures"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailViewController = storyboard?
            .instantiateViewController(withIdentifier: detailViewControllerIdentifier)
            as? PetitionDetailViewController
        {
            let petition = visiblePetitions[indexPath.row]
            
            detailViewController.petition = petition
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}


// MARK: - Private Helper Methods

private extension PetitionsListViewController {

    func loadPetitions() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard
                let self = self,
                let apiURL = URL(string: self.apiURLString)
            else { return }
            
            do {
                let petitionsLoader = PetitionsLoader()
                let jsonData = try Data(contentsOf: apiURL)
                
                self.allPetitions = try petitionsLoader.decodeResults(from: jsonData)
                self.visiblePetitions = self.allPetitions
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                DispatchQueue.main.async {
                    self.showError(error, title: "Error while loading data from API")
                }
            }
        }
    }
}


// MARK: - Event handling

extension PetitionsListViewController {
    
    func makeFilterAlertController() -> UIAlertController {
        let alertController = UIAlertController(title: "Search by title", message: nil, preferredStyle: .alert)
        
        let submitAction =  UIAlertAction(
            title: "Search",
            style: .default,
            handler: { [weak self, weak alertController] (_ action: UIAlertAction) in
                self?.filterText = alertController?.textFields?.first?.text ?? ""
            }
        )

        alertController.addTextField()
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(submitAction)
        
        return alertController
    }
    
    func filterTextChanged() {
        if filterText.isEmpty {
            visiblePetitions = allPetitions
        } else {
            visiblePetitions = allPetitions.filter { $0.title.contains(filterText) }
        }
        
        tableView.reloadData()
    }

    
    @IBAction func searchButtonTapped(_ sender: Any) {
        present(filterAlertController, animated: true)
    }
    
    
    @IBAction func showCredits(_ sender: Any) {
        let alertController = UIAlertController(
            title: "Credits",
            message: """
                This data is sourced from the White House's "We the People" API.
                
                You can read, sign, or create your own petitions at https://petitions.whitehouse.gov.
                """,
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alertController, animated: true)
    }
}
