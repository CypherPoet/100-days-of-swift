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
        if let detailViewController = storyboard?.instantiateViewController(withIdentifier: "Image Detail") as? DetailViewController {
            detailViewController.imagePath = imagePaths[indexPath.row]
            detailViewController.imageNumber = indexPath.row + 1
            detailViewController.totalImageCount = imagePaths.count
            
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}

