//
//  HomeViewController.swift
//  Easy Browser
//
//  Created by Brian Sipple on 1/16/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {
    enum StoryboardId {
        static let cellReuse = "Cell"
        static let websiteViewController = "Website View"
    }
    
    lazy var webSites = makeWebsites()
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return webSites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StoryboardId.cellReuse)!
        
        cell.textLabel?.text = webSites[indexPath.row].displayName
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewController = storyboard?.instantiateViewController(withIdentifier: StoryboardId.websiteViewController) as? WebsiteViewController else {
            return
        }
        
        viewController.website = webSites[indexPath.row]
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    private func makeWebsites() -> [Website] {
        return [
            Website(displayName: "Hacking With Swift", url: URL(string: "https://www.hackingwithswift.com")!),
            Website(displayName: "Apple Developers", url: URL(string: "https://developer.apple.com")!),
            Website(displayName: "Google", url: URL(string: "https://www.google.com")!),
            Website(displayName: "SpaceX", url: URL(string: "https://www.spacex.com")!),
            Website(displayName: "Y'alls", url: URL(string: "https://www.yalls.org")!),
        ]
    }
}
