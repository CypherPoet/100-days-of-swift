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
    
    lazy var filterChoiceActions: [UIAlertAction] = makeFilterChoiceActions()
    
    
    var currentImage: UIImage! {
        didSet {
            imageView.image = self.currentImage
            intensitySlider.isEnabled = true
            currentImageFilter.setValue(CIImage(image: self.currentImage), forKey: kCIInputImageKey)
        }
    }
    
    var currentImageFilterName = "" {
        didSet {
            currentImageFilter = CIFilter(name: self.currentImageFilterName)
            
            if let currentImage = currentImage {
                let newImage = CIImage(image: currentImage)
                
                currentImageFilter.setValue(newImage, forKey: kCIInputImageKey)
                applyImageProcessing()
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
        
        currentImageFilterName = "CISepiaTone"
        setupUI()
    }
}
    

// MARK: - Event handling

extension HomeViewController {
    
    @IBAction func changeFilter(_ sender: Any) {
        let controller = UIAlertController(title: "Choose a Filter", message: nil, preferredStyle: .actionSheet)
        
        filterChoiceActions.forEach { controller.addAction($0) }
        
        present(controller, animated: true)
    }
    
    
    @IBAction func save(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(
            currentImage,
            self,
            #selector(imageSaved(_:didFinishSavingWithError:contextInfo:)),
            nil
        )
    }
    
    
    @IBAction func intensityChanged(_ sender: Any) {
        applyImageProcessing()
    }
}


// MARK: - Private Helper Methods

private extension HomeViewController {
    
    func setupUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(importPicture)
        )
        
        intensitySlider.isEnabled = false
    }
    
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        
        picker.allowsEditing = true
        picker.delegate = self
        
        present(picker, animated: true)
    }
    
    
    func applyImageProcessing() {
        guard let (filterKey, value) = currentFilterInfo else { return }
        
        currentImageFilter.setValue(value, forKey: filterKey)
        
        if let cgImage = imageFilterContext.createCGImage(
            currentImageFilter.outputImage!,
            from: currentImageFilter.outputImage!.extent
            ) {
            let processedImage = UIImage(cgImage: cgImage)
            
            currentImage = processedImage
        }
    }
    
    
    func makeFilterChoiceActions() -> [UIAlertAction] {
        var actions = [
            "CIBumpDistortion",
            "CIGaussianBlur",
            "CIPixellate",
            "CIMotionBlur",
            "CISepiaTone",
            "CITwirlDistortion",
            "CIUnsharpMask",
            "CIVignette",
        ].map {
            UIAlertAction(title: $0, style: .default) { [weak self] (action: UIAlertAction) in
                self?.currentImageFilterName = action.title!
            }
        }
        
        actions.append(UIAlertAction(title: "Cancel", style: .cancel))
        
        return actions
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
        applyImageProcessing()
        
        dismiss(animated: true)
    }
    
    
    @objc func imageSaved(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
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


// MARK: - UINavigationControllerDelegate

extension HomeViewController: UINavigationControllerDelegate {}
