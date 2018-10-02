//
//  Remedio.swift
//  WatchTest
//
//  Created by ifce on 25/09/18.
//  Copyright © 2018 ifce. All rights reserved.
//

import Foundation

class Remedy : Codable {
    var name: String
    var interval: Int
    var remedyDescription: String
    var startDate: Date
    var taken: Bool
    var id: UUID
    
    init(id: UUID, name: String, interval: Int, description: String, startDate: Date, taken: Bool) {
        self.id = id
        self.name = name
        self.interval = interval
        self.startDate = startDate
        self.remedyDescription = description
        self.taken = taken
    }
    
    convenience init(withCDRemedy remdy : CDRemedy){
        let interval = Int(remdy.interval)
        self.init(id: remdy.id ?? UUID(), name: remdy.name!, interval: interval, description: remdy.remedyDescription ?? "sem descrição" , startDate: remdy.startDate!, taken: remdy.taken)
    }
}


extension CDRemedy {
    func asRemedy() -> Remedy {
        return Remedy(withCDRemedy: self)
    }
}
