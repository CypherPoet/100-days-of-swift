//
//  InjectionViewModel.swift
//  My Sweet HWS Extension
//
//  Created by Brian Sipple on 5/4/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation


class InjectionListViewModel {
    private let injectionManager: InjectionManager
    
    typealias CompletionHandler = (([Injection]) -> Void)
    
    var injectionPresets: [Injection] = []
    var customInjections: [Injection] = []
    
    var currentPageSnapshot: PageSnapshot
    

    init(
        currentPageSnapshot: PageSnapshot,
        injectionManager: InjectionManager = InjectionManager()
    ) {
        self.currentPageSnapshot = currentPageSnapshot
        self.injectionManager = injectionManager
    }
}


// MARK: - Computed Properties

extension InjectionListViewModel {
    
    var title: String {
        return currentPageSnapshot.title
    }
    
    
    var sortedCustomInjections: [Injection] {
        return customInjections.sorted { $0.title < $1.title }
    }
    
    
    var previousSiteInjections: [Injection] {
        return customInjections.filter { $0.siteURL?.host == currentPageSnapshot.url.host }
    }
    
    
    var hasPreviousSiteInjections: Bool {
        return !previousSiteInjections.isEmpty
    }
}


// MARK: - Core Methods

extension InjectionListViewModel {

    func start(then completionHandler: @escaping CompletionHandler) {
        injectionManager.loadPresets { [weak self] (presets) in
            guard let self = self else { return }
            
            self.injectionPresets = presets
            
            self.injectionManager.loadCustomInjections { (injections) in
                self.customInjections = injections

                completionHandler(injections)
            }
        }
    }
    
    
    func addCustom(
        _ injection: Injection,
        then completionHandler: @escaping CompletionHandler
    ) {
        customInjections.append(injection)
        injectionManager.saveCustom(customInjections)
        
        completionHandler(customInjections)
    }
    

    func updateCustom(
        _ injection: Injection,
        at index: Int,
        then completionHandler: @escaping CompletionHandler
    ) {
        customInjections[index] = injection
        injectionManager.saveCustom(customInjections)

        completionHandler(customInjections)
    }


    func delete(
        customInjectionAt index: Int,
        then completionHandler: @escaping CompletionHandler
    ) {
        customInjections.remove(at: index)
        injectionManager.saveCustom(customInjections)
        
        completionHandler(customInjections)
    }
}
