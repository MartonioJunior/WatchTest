//
//  RemedyRowController.swift
//  WatchTest WatchKit Extension
//
//  Created by ifce on 25/09/18.
//  Copyright © 2018 ifce. All rights reserved.
//

import UIKit
import WatchKit

class RemedyRowController: NSObject {
    @IBOutlet var nomeLabel: WKInterfaceLabel!
    @IBOutlet var timeLabel: WKInterfaceLabel!
    var remedy: Remedy?
}
