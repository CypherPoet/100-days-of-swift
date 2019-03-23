//
//  StormListViewController.swift
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

extension StormListViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagePaths.count
    }
    
    
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Picture", for: indexPath)
        
        cell.textLabel?.text = imagePaths[indexPath.row]
        
        return cell
    }
}


// MARK: - Collection View Delegate

extension StormListViewController {
    override func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard
            let detailViewController = storyboard?.instantiateViewController(withIdentifier: "Image Detail") as? StormDetailViewController
        else {
            fatalError("Failed to dequeue StormDetailViewController")
        }
        
        detailViewController.imagePath = imagePaths[indexPath.row]
        detailViewController.imageNumber = indexPath.row + 1
        detailViewController.totalImageCount = imagePaths.count
        
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}


// MARK: - Private Helper Methods

private extension StormListViewController {
    func loadImages() {
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
                    self.collectionView.reloadData()
                }
            } catch {
                DispatchQueue.main.async {
                    self.showError(error, title: "Error while loading images")
                }
            }
        }
    }
}
