//
//  ViewController.swift
//  Storm Viewer
//

import UIKit

class StormListViewController: UICollectionViewController {
    var imagePaths = [String]()
    lazy var fileManager = FileManager.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Storm Viewer ⚡️"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        loadImages()
    }
    
}


// MARK: - Data Source

extension HomeViewController {
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


// MARK: - Private Helper Methods

extension HomeViewController {
    private func loadImages() {
        DispatchQueue.global().async { [weak self] in
            guard
                let self = self,
                let resourcePath = Bundle.main.resourcePath
            else { return }
            
            do {
                let resourceFilePaths = try self.fileManager.contentsOfDirectory(atPath: resourcePath)
                
                self.imagePaths = resourceFilePaths
                    .filter({ $0.hasPrefix("nssl") })
                    .sorted()
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                DispatchQueue.main.async {
                    self.showError(error, title: "Error while loading images")
                }
            }
        }
    }
}
