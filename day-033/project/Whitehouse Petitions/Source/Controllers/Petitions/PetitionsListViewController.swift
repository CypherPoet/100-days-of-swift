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

    var petitions: [Petition] = []
    lazy var petitionsLoader = PetitionsLoader()
    

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPetitions()
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        let petition = petitions[indexPath.row]
        
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = "\(petition.signatureCount) signatures"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailViewController = storyboard?
            .instantiateViewController(withIdentifier: detailViewControllerIdentifier)
            as? PetitionDetailViewController
        {
            let petition = petitions[indexPath.row]
            
            detailViewController.petition = petition
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
    
    
    // MARK: - Core Methods
    
    func loadPetitions() {
        if let apiURL = URL(string: apiURLString) {
            do {
                // TODO: GCD this up as a background task
                let jsonData = try Data(contentsOf: apiURL)
                
                // TODO: Use GCD to return to the main thread here
                parsePetitions(fromJSON: jsonData)
            } catch {
                print("Error while loading data from API:\n\n\(error.localizedDescription)")
            }
        } else {
            fatalError("Unable to construct URL to api using \"\(apiURLString)\"")
        }
    }
    
    
    func parsePetitions(fromJSON json: Data) {
        do {
            petitions = try petitionsLoader.decodeResults(from: json)
            tableView.reloadData()
        } catch {
            print("Error while parsing petitions data:\n\n\(error.localizedDescription)")
        }
    }
    
    
    // MARK: - Event handling
    
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
