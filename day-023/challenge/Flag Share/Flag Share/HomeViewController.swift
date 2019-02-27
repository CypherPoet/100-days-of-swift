//
//  ViewController.swift
//  Flag Share
//
//  Created by Brian Sipple on 2/26/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit


class FlagListViewController: UITableViewController {
    let cellReuseIdentifier = "Cell"
    let detailViewControllerIdentifier = "Flag Details"
    
    var flags: [Flag] = []
    

    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "Flags of the World"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        loadFlagData()
    }
    
    
    // MARK: - Table data
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flags.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)!
        let flag = flags[indexPath.row]
        
        cell.imageView?.image = UIImage(named: flag.assetName)!
        cell.textLabel?.text = flag.displayName
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewController = storyboard?.instantiateViewController(withIdentifier: detailViewControllerIdentifier)
            as? FlagDetailViewController
        {
            let flag = flags[indexPath.row]
            
            viewController.flag = flag
            
            navigationController?.pushViewController(viewController, animated: true)
        }
    }

    
    // MARK: - Helper functions
    
    func loadFlagData() {
        if let flagJSON = loadFlagJSON() {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                flags = try decoder.decode([Flag].self, from: flagJSON)
            } catch {
                print("Error decoding flag JSON data:\n\(error.localizedDescription)")
            }
        } else {
            print("Unable to find flag JSON data")
        }
    }

    
    func loadFlagJSON() -> Data? {
        if let filePath = Bundle.main.path(forResource: "flag-data", ofType: "json") {
            do {
                let flagDataURL = URL(fileURLWithPath: filePath)
                return try Data(contentsOf: flagDataURL)
            } catch {
                print("Error while loading flag json data:\n\(error.localizedDescription)")
            }
        }
        
        return nil
    }
}

