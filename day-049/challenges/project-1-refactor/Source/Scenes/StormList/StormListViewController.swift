//
//  StormListViewController.swift
//  Storm Viewer
//

import UIKit

class StormListViewController: UICollectionViewController {
    var displayImages: [DisplayImage] = []
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
        return displayImages.count
    }
    
    
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryboardID.stormCell, for: indexPath)
                as? StormCollectionViewCell
        else {
            fatalError("Failed to dequeue StormCollectionViewCell")
        }
        
        let displayImage = displayImages[indexPath.row]
        
        cell.stormImageView.image = UIImage(named: displayImage.imagePath)
        cell.stormLabel?.text = displayImage.imageName
        
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
            let detailViewController = storyboard?
                .instantiateViewController(withIdentifier: StoryboardID.stormDetailViewController)
                as? StormDetailViewController
        else {
            fatalError("Failed to dequeue StormDetailViewController")
        }
        
        detailViewController.displayImage = displayImages[indexPath.row]
        detailViewController.imageNumber = indexPath.row + 1
        detailViewController.totalImageCount = displayImages.count
        
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
                
                self.displayImages = resourceFilePaths
                    .filter({ $0.hasPrefix("nssl") })
                    .sorted()
                    .map({ DisplayImage(imagePath: $0) })
                
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
