//
//  Remedio.swift
//  WatchTest
//
//  Created by ifce on 25/09/18.
//  Copyright © 2018 ifce. All rights reserved.
//

import UIKit

class Remedy {
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
}
