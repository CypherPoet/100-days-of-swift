//
//  ViewController.swift
//  Debugging
//
//  Created by Brian Sipple on 4/21/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("👏", terminator: "")
        print("What", "do", "you", "know?", separator: "👏", terminator: "")
        print("👏", terminator: "")
        
        
        generateNumbers()
    }

    
    func generateNumbers() {
        for i in 1...100 {
            print("Got number \(i)")
        }
    }

}

