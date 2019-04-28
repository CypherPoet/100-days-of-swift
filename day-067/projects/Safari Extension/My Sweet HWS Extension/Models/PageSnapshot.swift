//
//  PageSnapshot.swift
//  My Sweet HWS Extension
//
//  Created by Brian Sipple on 4/28/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation


struct PageSnapshot {
    var title: String
    var url: URL
    
    enum CodingKeys: String, CodingKey {
        case title
        case url
    }

    
    init(title: String, url: URL) {
        self.title = title
        self.url = url
    }
}


extension PageSnapshot: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let title = try container.decode(String.self, forKey: .title)
        let urlString = try container.decode(String.self, forKey: .url)
        let url = URL(string: urlString)!
        
        self.init(title: title, url: url)
    }
}
