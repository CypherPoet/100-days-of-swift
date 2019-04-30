//
//  StoryboardID.swift
//  My Sweet HWS Extension
//
//  Created by Brian Sipple on 4/29/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation

enum StoryboardID {
    enum ReuseIdentifier {
        static let scriptTableCell = "Script Table Cell"
    }
    
    enum Segue {
        static let presentEditInjectionScriptView = "Present Edit Injection Script View"
        static let unwindFromSavingInjectionScript = "Unwind from saving injection script"
    }
}
