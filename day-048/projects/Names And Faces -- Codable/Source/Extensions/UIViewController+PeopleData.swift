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
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: people, requiringSecureCoding: false) {
            userDefaults.setValue(savedData, forKey: "people")
        }
    }
    
    func getPeople(fromDefaults userDefaults: UserDefaults = UserDefaults.standard) -> [Person]? {
        if let savedPeople = userDefaults.object(forKey: "people") as? Data {
            if let decodedPeople = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPeople) as? [Person] {
                return decodedPeople
            }
        }
        
        return nil
    }
}
