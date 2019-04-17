//
//  MainViewController.swift
//  Capital Cities
//
//  Created by Brian Sipple on 2/5/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit
import MapKit


class MainViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    let annotationReuseIdentifier = "Capital"
    
    let mapStyleChoices = [
        "Standard": MKMapType.standard,
        "Satellite": MKMapType.satellite,
        "Satellite Flyover": MKMapType.satelliteFlyover,
        "Hybrid": MKMapType.hybrid,
        "Hybrid Flyover": MKMapType.hybridFlyover,
        "Muted Standard": MKMapType.mutedStandard,
    ]
}


// MARK: - Lifecycle

extension MainViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAnnotations()
    }
}


// MARK: - Event handling

extension MainViewController {
    
    @IBAction func selectMapStyle(_ sender: Any) {
        let chooser = UIAlertController(title: "Choose a map style.", message: nil, preferredStyle: .actionSheet)

        for choiceName in mapStyleChoices.keys.sorted() {
            chooser.addAction(UIAlertAction(title: choiceName, style: .default, handler: switchMapStyle))
        }
        
        present(chooser, animated: true)
    }
}


// MARK: - Private Helper Methods

private extension MainViewController {
    
    func loadAnnotations() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let dataURL = Bundle.main.url(forResource: "capital-data", withExtension: "json") {
                do {
                    let decoder = JSONDecoder()
                    let data = try Data(contentsOf: dataURL)
                    
                    let annotations = try decoder.decode([CapitalAnnotation].self, from: data)
                    
                    DispatchQueue.main.async {
                        self?.annotationsDidLoad(annotations)
                    }
                } catch {
                    DispatchQueue.main.async {
                        self?.showError(error, title: "Error while trying to load city data")
                        print(error)
                    }
                }
            } else {
                preconditionFailure("Unable to find capital data")
            }
        }
    }
    
    
    func annotationsDidLoad(_ annotations: [CapitalAnnotation]) {
        mapView.addAnnotations(annotations)
    }
    

    func switchMapStyle(action choiceAction: UIAlertAction) {
        guard let mapType = mapStyleChoices[choiceAction.title ?? ""] else {
            preconditionFailure("Couldn't get MKMapType from choice.")
        }
        
        mapView.mapType = mapType
    }
}


// MARK: -  MKMapViewDelegate

extension MainViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let capitalAnnotation = annotation as? CapitalAnnotation else {
            return nil
        }
        
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationReuseIdentifier) {
            annotationView.annotation = capitalAnnotation
            
            return annotationView
        } else {
            return makeNewCapitalAnnotationView(capitalAnnotation)
        }
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let capitalAnnotation = view.annotation as? CapitalAnnotation {
            showDetailModal(forAnnotation: capitalAnnotation)
        }
    }
    
    
    func makeNewCapitalAnnotationView(_ capitalAnnotation: CapitalAnnotation) -> MKPinAnnotationView {
        let annotationView = MKPinAnnotationView(annotation: capitalAnnotation, reuseIdentifier: self.annotationReuseIdentifier)

        let button = UIButton(type: .detailDisclosure)
        
        annotationView.canShowCallout = true
        annotationView.rightCalloutAccessoryView = button
        
        return annotationView
    }
    
    
    func showDetailModal(forAnnotation annotation: CapitalAnnotation) {
        let alertController = UIAlertController(title: annotation.title, message: annotation.shortDescription, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alertController, animated: true)
    }
}
