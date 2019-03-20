//
//  ViewController.swift
//  Names And Faces
//
//  Created by Brian Sipple on 1/23/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class HomeViewController: UICollectionViewController {
    var people: [Person] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewPerson)
        )
    }
}


// MARK: - Data Source

extension HomeViewController {

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        guard let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: StoryboardID.personCell, for: indexPath) as? PersonCell
        else {
            fatalError("Unable to deque person cell")
        }
        
        let person = people[indexPath.item]
        
        cell.personImageView.image = UIImage(contentsOfFile: getURL(forFile: person.imageName).path)
        cell.personNameLabel.text = person.name
        
        setStyles(forCell: cell)
        
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        promptForName(of: person)
    }
}


// MARK: - Private Helper Methods

private extension HomeViewController {
    
    @objc func addNewPerson() {
        let imagePicker = UIImagePickerController()
        
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        }
        
        present(imagePicker, animated: true)
    }
    
    
    func getDocumentsDirectoryURL() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    
    func getURL(forFile fileName: String) -> URL {
        return getDocumentsDirectoryURL().appendingPathComponent(fileName)
    }
    
    
    func setStyles(forCell cell: PersonCell) {
        cell.personImageView.layer.borderColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3).cgColor
        cell.personImageView.layer.borderWidth = 2
        cell.personImageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
    }
    
    
    func promptForName(of person: Person) {
        let alertController = UIAlertController(title: "Who is this?", message: nil, preferredStyle: .alert)
        
        alertController.addTextField()
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alertController.addAction(
            UIAlertAction(title: "OK", style: .default) { [unowned self, alertController] _ in
                let newName = alertController.textFields![0].text!
                
                person.name = newName
                self.collectionView?.reloadData()
            }
        )
        
        present(alertController, animated: true)
    }
}


// MARK: - UIImagePickerControllerDelegate

extension HomeViewController: UIImagePickerControllerDelegate {
    /*
     Handles the completion of adding an image to the picker. Our flow:
     - Extract the image from the dictionary that is passed as a parameter.
     - Generate a unique filename for it.
     - Convert it to a JPEG
     - Write that JPEG to disk.
     - Dismiss the view controller.
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let imagePicked = info[.editedImage] as? UIImage else { return }
        
        let fileName = UUID().uuidString
        let imageURL = getURL(forFile: fileName)
        
        if let jpegData = imagePicked.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imageURL)
        }
        
        people.append(Person(name: "Unknown", imageName: fileName))
        collectionView?.reloadData()
        
        picker.dismiss(animated: true)
        
    }
}


// MARK: - UINavigationControllerDelegate

extension HomeViewController: UINavigationControllerDelegate {
    
}
