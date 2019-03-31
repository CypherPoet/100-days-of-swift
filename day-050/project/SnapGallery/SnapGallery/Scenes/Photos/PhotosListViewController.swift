//
//  ViewController.swift
//  SnapGallery
//
//  Created by Brian Sipple on 3/30/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class PhotosListViewController: UICollectionViewController {
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    private let itemsPerRow: CGFloat = 2

    private lazy var imagePicker = makeImagePicker()
    
    private var photos: [Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    @IBAction func addPhotoTapped(_ sender: Any) {
        present(imagePicker, animated: true)
    }
}


// MARK: - Data Source

extension PhotosListViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: StoryboardID.photoCell, for: indexPath) as? PhotoCollectionViewCell
        else {
            fatalError("Unable to dequeue Photo Cell")
        }
        
        let photo = photos[indexPath.row]
        
        cell.photoImageView.image = UIImage(contentsOfFile: url(forFileName: photo.imageName).path)
        cell.photoLabel.text = photo.smallFormattedTitle
        
        return cell;
    }
}


// MARK: - Collection View Flow Layout Delegate

extension PhotosListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let itemWidth = availableWidth / itemsPerRow
        
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return sectionInsets
    }
    
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return sectionInsets.left
    }
}


// MARK: - Image Picker Delegate

extension PhotosListViewController: UIImagePickerControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        guard let imagePicked = info[.editedImage] as? UIImage else { return }
        
        let fileName = UUID().uuidString
        let imageURL = url(forFileName: fileName)
        
        if let jpegData = imagePicked.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imageURL)
        }
        
        photos.append(Photo(title: "", imageName: fileName))
        
        save(photos: photos)
        collectionView.reloadData()
        
        picker.dismiss(animated: true)
    }
}

extension PhotosListViewController: UINavigationControllerDelegate {}


// MARK: - Private Helper Methods

private extension PhotosListViewController {
    func makeImagePicker() -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        }
        
        return imagePicker
    }
}
