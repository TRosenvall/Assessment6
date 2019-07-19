//
//  Entry.swift
//  Assessment6
//
//  Created by Timothy Rosenvall on 7/19/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import Foundation

class Entry: Codable {
    // Class Properties
    let name: String
    
    // Class Initializer
    init(name: String) {
        self.name = name
    }
}

extension Entry: Equatable {
    static func == (lhs: Entry, rhs: Entry) -> Bool {
        return lhs.name == rhs.name
    }
}
