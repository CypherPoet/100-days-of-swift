//
//  UIViewController+PeopleData.swift
//  Names And Faces
//
//  Created by Brian Sipple on 3/28/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func save(
        people: [Person],
        toDefaults userDefaults: UserDefaults = UserDefaults.standard
    ) {
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(people)
            userDefaults.set(data, forKey: "people")
        } catch {
            print("Failed to saved people")
        }
    }
    
    func getPeople(fromDefaults userDefaults: UserDefaults = UserDefaults.standard) -> [Person]? {
        let decoder = JSONDecoder()
        
        if let peopleData = userDefaults.object(forKey: "people") as? Data {
            do {
                return try decoder.decode([Person].self, from: peopleData)
            } catch {
                showError(error, title: "Error while loading saved people")
            }
        }
        
        print("No people data found in UserDefaultsloaded.")
        return nil
    }
}
