//
//  InjectionManager.swift
//  My Sweet HWS Extension
//
//  Created by Brian Sipple on 5/4/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class InjectionManager {
    private lazy var userDefaults = UserDefaults.standard
}


// MARK: - Computed Properties

extension InjectionManager {
    
    var presetURL: URL {
        guard let presetURL = Bundle.main.url(forResource: "injection-presets", withExtension: "json") else {
            preconditionFailure("Failed to load injection presets from Bundle")
        }
        
        return presetURL
    }
    
    
    var customInjectionsFromDefaults: [Injection]? {
        if let injectionData = userDefaults.data(forKey: Keys.UserDefaults.customInjections) {
            let decoder = JSONDecoder()
            
            do {
                return try decoder.decode([Injection].self, from: injectionData)
            } catch {
                fatalError("Error while attempting to decode injection data:\n\n\(error.localizedDescription)")
            }
        } else {
            return nil
        }
    }
}


// MARK: - Core Methods

extension InjectionManager {
    
    func loadPresets(
        on queue: DispatchQueue = .global(qos: .userInitiated),
        then completionHandler: @escaping ([Injection]) -> Void
    ) {
        queue.async { [weak self] in
            guard let self = self else { return }
            
            do {
                let presetData = try Data(contentsOf: self.presetURL)
                let decoder = JSONDecoder()
                let injections = try decoder.decode([Injection].self, from: presetData)
                
                completionHandler(injections)
            } catch {
                fatalError("Error while loading injection presets:\n\n\(error.localizedDescription)")
            }
        }
    }
    
    
    func loadCustomInjections(
        on queue: DispatchQueue = .global(qos: .userInitiated),
        then completionHandler: @escaping ([Injection]) -> Void
    ) {
        queue.async { [weak self] in
            let injections: [Injection] = self?.customInjectionsFromDefaults ?? []
            
            completionHandler(injections)
        }
    }

    
    func saveCustom(_ injections: [Injection]) {
        let encoder = JSONEncoder()

        do {
            let injectionData = try encoder.encode(injections)
            userDefaults.set(injectionData, forKey: Keys.UserDefaults.customInjections)
        } catch {
            fatalError("Error while saving custom injections:\n\n\(error.localizedDescription)")
        }
    }
}
