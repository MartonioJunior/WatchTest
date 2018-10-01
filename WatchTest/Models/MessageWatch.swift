//
//  MessageWatch.swift
//  WatchTest
//
//  Created by Ramires Moreira on 10/1/18.
//  Copyright © 2018 ifce. All rights reserved.
//

import Foundation

enum Event : Int , Codable {
    case new
    case getAll
    case taken
    case delay

}

struct MessageWatch : Codable {
    let eventType : Event
    let remedy : Remedy?
}
