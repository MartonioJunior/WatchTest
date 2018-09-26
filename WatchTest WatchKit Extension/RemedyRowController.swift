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
    
    var remedy: Remedy? {
        didSet {
            guard let remedy = remedy else { return }
            nomeLabel.setText(remedy.name)
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "hh:mm"
            let time = dateFormat.string(from: remedy.startDate)
            timeLabel.setText(time)
        }
    }
}
