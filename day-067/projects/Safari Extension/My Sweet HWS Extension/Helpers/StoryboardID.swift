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
        static let injectionTableCell = "Injection Table Cell"
    }
    
    enum Segue {
        static let presentAddEditInjectionScriptView = "Present Add/Edit Injection Script"
        static let unwindFromSavingInjectionScript = "Unwind from saving injection script"
    }
}
