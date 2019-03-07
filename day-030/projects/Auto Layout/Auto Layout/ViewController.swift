//
//  ViewController.swift
//  Auto Layout
//
//  Created by Brian Sipple on 1/18/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    lazy var labelViews = [
        "label1": UILabel(),
        "label2": UILabel(),
        "label3": UILabel(),
        "label4": UILabel(),
        "label5": UILabel(),
    ]
    
    /// Toggle this to experiment with anchor constraints instead of vertical/horizontal VFL
    var useAnchorContraints = false
    
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
        labelViews["label1"]?.backgroundColor = UIColor.red
        labelViews["label1"]?.text = "THESE"
        
        labelViews["label2"]?.backgroundColor = UIColor.cyan
        labelViews["label2"]?.text = "ARE"
        
        labelViews["label3"]?.backgroundColor = UIColor.yellow
        labelViews["label3"]?.text = "SOME"
        
        labelViews["label4"]?.backgroundColor = UIColor.orange
        labelViews["label4"]?.text = "AWESOME"
        
        labelViews["label5"]?.backgroundColor = UIColor.purple
        labelViews["label5"]?.text = "LABELS"

        
        for label in labelViews.values {
            label.translatesAutoresizingMaskIntoConstraints = false
            label.sizeToFit()
            view.addSubview(label)
        }
    }
    
    
    func addHorizontalViewConstraints() {
        for labelKey in labelViews.keys {
            view.addConstraints(
                NSLayoutConstraint.constraints(
                    withVisualFormat: "H:|[\(labelKey)]|",
                    options: [],
                    metrics: nil,
                    views: labelViews
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
                views: labelViews
            )
        )
    }
    
    
    func addAnchorConstraints() {
        for labelNumber in 1...labelViews.count {
            let label = labelViews["label\(labelNumber)"]!
            
            label.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            label.heightAnchor.constraint(equalToConstant: 88).isActive = true
            
            if labelNumber > 1 {
                let labelAbove = labelViews["label\(labelNumber - 1)"]!
                
                // create a topAnchor constraint if we have a previous label (and thus, a bottomAnchor to offset from)
                label.topAnchor.constraint(equalTo: labelAbove.bottomAnchor, constant: 10).isActive = true
            }
        }
    }

}

