//
//  AddEditInjectionViewModel.swift
//  My Sweet HWS Extension
//
//  Created by Brian Sipple on 5/4/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

class AddEditInjectionViewModel {
    var injection: Injection
    var isNewInjection: Bool
    var pageSnapshot: PageSnapshot
    
    
    init(injection: Injection, isNewInjection: Bool, pageSnapshot: PageSnapshot) {
        self.injection = injection
        self.isNewInjection = isNewInjection
        self.pageSnapshot = pageSnapshot
    }
}


// MARK: - Computed Properties

extension AddEditInjectionViewModel {
    
    var pageTitle: String {
        return pageSnapshot.url.host ?? pageSnapshot.url.absoluteString
    }

    
    var introLabelText: String {
        if injection.evalString.isEmpty {
            return """
            Enter the JavaScript that you'd like to run on \(pageSnapshot.url.host ?? "this site").
            """
        }
        return ""
    }
    
    
    var isInjectionValid: Bool {
        return (
            !injection.title.isEmpty &&
            !injection.evalString.isEmpty
        )
    }
}


// MARK: - Core Methods

extension AddEditInjectionViewModel {
    typealias Changes = (title: String, scriptText: String)
    
    struct InvalidInjection: Error {}
    
    func update(
        with changes: Changes,
        then completionHandler: (Result<Injection, Error>) -> Void
    ) {
        injection.title = changes.title
        injection.evalString = changes.scriptText
        injection.siteURL = pageSnapshot.url
        
        if isInjectionValid {
            completionHandler(.success(injection))
        } else {
            completionHandler(.failure(InvalidInjection()))
        }
    }
}
