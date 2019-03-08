//
//  ViewController.swift
//  Auto Layout
//
//  Created by Brian Sipple on 1/18/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    lazy var labels = [
        "label1": UILabel(),
        "label2": UILabel(),
        "label3": UILabel(),
        "label4": UILabel(),
        "label5": UILabel(),
    ]
    
    /// Toggle this to experiment with anchor constraints instead of vertical/horizontal VFL
    var useAnchorContraints = true
    
    override var prefersStatusBarHidden: Bool {
        return true
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        createViews()
        
        if useAnchorContraints {
            addAnchorConstraints()
        } else {
            addHorizontalViewConstraints()
            addVerticalViewConstraints()
        }
    }
    
    
    func createViews() {
        labels["label1"]?.backgroundColor = UIColor.red
        labels["label1"]?.text = "THESE"
        
        labels["label2"]?.backgroundColor = UIColor.cyan
        labels["label2"]?.text = "ARE"
        
        labels["label3"]?.backgroundColor = UIColor.yellow
        labels["label3"]?.text = "SOME"
        
        labels["label4"]?.backgroundColor = UIColor.orange
        labels["label4"]?.text = "AWESOME"
        
        labels["label5"]?.backgroundColor = UIColor.purple
        labels["label5"]?.text = "LABELS"

        
        for label in labels.values {
            label.translatesAutoresizingMaskIntoConstraints = false
            label.sizeToFit()
            view.addSubview(label)
        }
    }
    
    
    func addHorizontalViewConstraints() {
        for labelKey in labels.keys {
            view.addConstraints(
                NSLayoutConstraint.constraints(
                    withVisualFormat: "H:|[\(labelKey)]|",
                    options: [],
                    metrics: nil,
                    views: labels
                )
            )
        }
    }
    
    
    /**
        Creates an Auto Layout VFL string with the following constraints:
             - Each of the 5 labels should be "(labelHeight)" points high, with a priority of "999"
             - The bottom of our last label must be at least 10 points away from the
               bottom of the view controller's view.
     
         📝 When specifying the size of a space, we need to use the "-" before and
         after the size: a simple space, "-", becomes "-(>=10)-".
     */
    func addVerticalViewConstraints() {
        let metrics = ["labelHeight": 88]
        
        let layoutStringPrefix = "V:|"
        let layoutStringHeights = "[label1(labelHeight@999)]-[label2(label1)]-[label3(label1)]-[label4(label1)]-[label5(label1)]"
        let layoutStringSuffix = "->=10-|"
        
        let layoutString = "\(layoutStringPrefix)\(layoutStringHeights)\(layoutStringSuffix)"
        
        print(layoutString)
        
        view.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: layoutString,
                options: [],
                metrics: metrics,
                views: labels
            )
        )
    }
    
    
    func addAnchorConstraints() {
        for labelNumber in 1...labels.count {
            let label = labels["label\(labelNumber)"]!
            
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 6).isActive = true
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -6).isActive = true
            
            label.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.2, constant: -10).isActive = true
            label.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true

            if labelNumber > 1 {
                let labelAbove = labels["label\(labelNumber - 1)"]!
                
                /// create a topAnchor constraint if we have a label above us (and thus, a bottomAnchor to offset from)
                label.topAnchor.constraint(equalTo: labelAbove.bottomAnchor, constant: 10).isActive = true
                
                if labelNumber == labels.count {
                    /// anchor the last label against the bottom `safeAreaLayoutGuide`
                    label.bottomAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10).isActive = true
                }
            } else {
                /// anchor the first label against the top `safeAreaLayoutGuide`
                label.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
            }
        }
    }

}

