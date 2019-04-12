//
//  HomeViewController.swift
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
    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var angleSlider: UISlider!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var currentFilterButton: UIButton!
    
    var currentImageFilter: CIFilter!
    
    // 🔑 Creating a CIContext is expensive, so we'll create it once and reuse it throughout the app.
    lazy var imageFilterContext = CIContext()
    
    var currentImage: UIImage! {
        didSet {
            intensitySlider.isEnabled = true
            radiusSlider.isEnabled = true
            angleSlider.isEnabled = true
            saveButton.isEnabled = true
            
            imageView.image = currentImage
            
            setNewFilterImage(using: currentImage)
        }
    }
    
    var currentImageFilterName: CoreImageFilterName = .sepiaTone {
        didSet {
            currentImageFilter = CIFilter(name: currentImageFilterName.rawValue)
            currentFilterButton.setTitle("\(filterDisplayNames[currentImageFilterName]!) 🔽", for: .normal)
            
            if let currentImage = currentImage {
                setNewFilterImage(using: currentImage)
            }
        }
    }
}


// MARK: - Computed Properties

extension HomeViewController {
    
    var currentFilterValuePairs: [(key: String, value: Any)] {
        var pairs: [(key: String, value: Any)] = []
        let inputKeys = currentImageFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) {
            pairs.append((kCIInputIntensityKey, intensitySlider.value))
        }
        if inputKeys.contains(kCIInputRadiusKey) {
            pairs.append((kCIInputRadiusKey, radiusSlider.value))
        }
        if inputKeys.contains(kCIInputAngleKey) {
            pairs.append((kCIInputAngleKey, Double.radians(fromDegrees: Double(angleSlider.value))))
        }
        if inputKeys.contains(kCIInputScaleKey) {
            pairs.append((kCIInputScaleKey, intensitySlider.value * 10))
        }
        if inputKeys.contains(kCIInputCenterKey) {
            let vector = CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2)
            pairs.append((kCIInputCenterKey, vector))
        }
        
        return pairs
    }
}


// MARK: - Lifecycle

extension HomeViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentImageFilterName = CoreImageFilterName.sepiaTone
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
    
    
    @IBAction func filterSliderChanged(_ sender: Any) {
        applyImageProcessing()
    }
}


// MARK: - Private Helper Methods

private extension HomeViewController {

    func applyImageProcessing() {
        guard !currentFilterValuePairs.isEmpty else {
            return assertionFailure("Unable to compute processing properties for current filter")
        }
    
        guard let currentOutputImage = currentImageFilter.outputImage else {
            return assertionFailure("Unable to find output image in current filter.")
        }
        
        for (filterKey, filterValue) in currentFilterValuePairs {
            print("Filter key: \(filterKey)")
            print("Filter value: \(filterValue)")
            
            currentImageFilter.setValue(filterValue, forKey: filterKey)
        }
        
        if let processedImage = imageFilterContext.createCGImage(currentOutputImage, from: currentOutputImage.extent) {
            imageView.image = UIImage(cgImage: processedImage)
        }
    }
    
    
    func makeFilterChoiceActions() -> [UIAlertAction] {
        var actions = CoreImageFilterName.allCases.map { filterName in
            return UIAlertAction(title: filterDisplayNames[filterName], style: .default) { [weak self] (action: UIAlertAction) in
                self?.currentImageFilterName = filterName
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

        DispatchQueue.main.async { [weak self] in
            UIView.animate(
                withDuration: 0.5,
                delay: 0.25,
                options: [],
                animations: { self?.imageView.alpha = 1 }
            )
        }
    }
}


// MARK: - UINavigationControllerDelegate

extension HomeViewController: UINavigationControllerDelegate {}
