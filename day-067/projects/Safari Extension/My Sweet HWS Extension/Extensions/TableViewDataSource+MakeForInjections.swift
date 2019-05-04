//
//  TableViewDataSource+MakeForInjections.swift
//  My Sweet HWS Extension
//
//  Created by Brian Sipple on 5/4/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation


extension TableViewDataSource where Model == Injection {
    static func make(for injections: [Injection]) -> TableViewDataSource<Injection> {
        return TableViewDataSource(
            models: injections,
            cellReuseIdentifier: StoryboardID.ReuseIdentifier.injectionTableCell,
            cellConfigurator: { (injection, cell) in
                cell.textLabel?.text = injection.title
            }
        )
    }
}
