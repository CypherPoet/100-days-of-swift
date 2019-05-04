//
//  PageSnapshot+makeFromJavaScriptData.swift
//  My Sweet HWS Extension
//
//  Created by Brian Sipple on 5/4/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation

extension PageSnapshot {
    static func make(from javaScriptData: NSDictionary) -> PageSnapshot {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: javaScriptData)
            let decoder = JSONDecoder()
    
            return try decoder.decode(PageSnapshot.self, from: jsonData)
        } catch {
            fatalError("Error while attempting to take page snapshot: \(error.localizedDescription)")
        }
    }
}
