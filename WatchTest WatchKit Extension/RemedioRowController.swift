//
//  RemedioRowController.swift
//  WatchTest WatchKit Extension
//
//  Created by ifce on 25/09/18.
//  Copyright © 2018 ifce. All rights reserved.
//

import UIKit
import WatchKit

class RemedioRowController: NSObject {
    @IBOutlet var nomeLabel: WKInterfaceLabel!
    @IBOutlet var timeLabel: WKInterfaceLabel!
    
    var remedio: Remedio? {
        didSet {
            guard let remedio = remedio else { return }
            nomeLabel.setText(remedio.nome)
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "hh:mm"
            dateFormat.string(from: remedio.dataInicio)
            timeLabel.setText(remedio.dataInicio)
        }
    }
}
