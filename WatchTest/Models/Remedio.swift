//
//  Remedio.swift
//  WatchTest
//
//  Created by ifce on 25/09/18.
//  Copyright © 2018 ifce. All rights reserved.
//

import UIKit

class Remedy: NSCopying {
    var name: String
    var interval: Int
    var remedyDescription: String
    var startDate: Date
    var taken: Bool
    
    init(name: String, interval: Int, description: String, startDate: Date, taken: Bool) {
        self.name = name
        self.interval = interval
        self.startDate = startDate
        self.remedyDescription = description
        self.taken = taken
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Remedy(name: self.name, interval: self.interval, description: self.remedyDescription, startDate: self.startDate, taken: self.taken)
        return copy
    }
}
