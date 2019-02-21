//
//  ViewController.swift
//  Storm Viewer
//

import UIKit

class ViewController: UITableViewController {
    var imagePaths = [String]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "Storm Viewer ⚡️"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        
        let images = try! fm.contentsOfDirectory(atPath: path)
        
        imagePaths = images.filter({ $0.hasPrefix("nssl") }).sorted()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imagePaths.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        
        cell.textLabel?.text = imagePaths[indexPath.row]
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // try loading the "Detail" view controller and typecasting it to be DetailViewController
        
        if let detailViewController = storyboard?.instantiateViewController(withIdentifier: "Image Detail") as? DetailViewController {
            // set the vc's `imagePath` property to match the image selected
            detailViewController.imagePath = imagePaths[indexPath.row]
            
            // push the detail VC onto the navigation controller
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}

