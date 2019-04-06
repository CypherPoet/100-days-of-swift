//
//  ViewController.swift
//  Instafilter
//
//  Created by Brian Sipple on 1/27/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit
import CoreImage

class HomeViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var intensitySlider: UISlider!
    
    var currentImageFilter: CIFilter!
    
    // 🔑 Creating a CIContext is expensive, so we'll create it once and reuse it throughout the app.
    lazy var imageFilterContext = CIContext()
    
    var currentImage: UIImage! {
        didSet {
            imageView.image = currentImage
            intensitySlider.isEnabled = true
            setNewFilterImage(using: currentImage)
        }
    }
    
    var currentImageFilterName = "" {
        didSet {
            currentImageFilter = CIFilter(name: currentImageFilterName)
            
            if let currentImage = currentImage {
                setNewFilterImage(using: currentImage)
            }
        }
    }
}


// MARK: - Computed Properties

extension HomeViewController {
    
    var currentFilterInfo: (key: String, value: Any)? {
        let inputKeys = currentImageFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) {
            return (kCIInputIntensityKey, intensitySlider.value)
            
        } else if inputKeys.contains(kCIInputRadiusKey) {
            return (kCIInputRadiusKey, intensitySlider.value * 200)
            
        } else if inputKeys.contains(kCIInputScaleKey) {
            return (kCIInputScaleKey, intensitySlider.value * 10)
            
        } else if inputKeys.contains(kCIInputCenterKey) {
            let vector = CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2)
            return (kCIInputCenterKey, vector)
        }
        
        return nil
    }
}


// MARK: - Lifecycle

extension HomeViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentImageFilterName = CoreImageFilterName.sepiaTone.rawValue
        intensitySlider.isEnabled = false
    }
}
    

// MARK: - Event handling

extension HomeViewController {

    @IBAction func importPictureTapped() {
        let picker = UIImagePickerController()
        
        picker.allowsEditing = true
        picker.delegate = self
        
        present(picker, animated: true)
    }
    
    
    @IBAction func changeFilter(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Choose a Filter", message: nil, preferredStyle: .actionSheet)
        
        makeFilterChoiceActions().forEach { alertController.addAction($0) }
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        
        present(alertController, animated: true)
    }
    
    
    @IBAction func saveImage(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(
            currentImage,
            self,
            #selector(image(_:didFinishSavingWithError:contextInfo:)),
            nil
        )
    }
    
    
    @IBAction func intensityChanged(_ sender: Any) {
        applyImageProcessing()
    }
}


// MARK: - Private Helper Methods

private extension HomeViewController {

    func applyImageProcessing() {
        guard let (filterKey, filterValue) = currentFilterInfo else {
            print("Unable to compute processing properties for current filter")
            return
        }
        
        print("Filter key: \(filterKey)")
        print("Filter value: \(filterValue)")
        
        guard let currentOutputImage = currentImageFilter.outputImage else {
            print("Unable to find output image in current filter.")
            return
        }
        
        currentImageFilter.setValue(filterValue, forKey: filterKey)
        
        if let processedImage = imageFilterContext.createCGImage(currentOutputImage, from: currentOutputImage.extent) {
            imageView.image = UIImage(cgImage: processedImage)
        }
    }
    
    
    func makeFilterChoiceActions() -> [UIAlertAction] {
        var actions = CoreImageFilterName.allCases.map {
            return UIAlertAction(title: $0.rawValue, style: .default) { [weak self] (action: UIAlertAction) in
                self?.currentImageFilterName = action.title!
            }
        }
        
        actions.append(UIAlertAction(title: "Cancel", style: .cancel))
        
        return actions
    }
    
    
    func setNewFilterImage(using image: UIImage) {
        let newImage = CIImage(image: image)
        
        currentImageFilter.setValue(newImage, forKey: kCIInputImageKey)
        applyImageProcessing()
    }
}


// MARK: - Save image to photos album delegate

extension HomeViewController {
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        if let error = error {
            alertController.title = "Save Error"
            alertController.message = error.localizedDescription
        } else {
            alertController.title = "Saved!"
            alertController.message = "Your altered image has been saved to your photos."
        }
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alertController, animated: true)
    }
}


// MARK: - UIImagePickerControllerDelegate

extension HomeViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        currentImage = image
        dismiss(animated: true)
    }
}


// MARK: - UINavigationControllerDelegate

extension HomeViewController: UINavigationControllerDelegate {}
