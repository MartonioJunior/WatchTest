//
//  DetailInterfaceController.swift
//  WatchTest WatchKit Extension
//
//  Created by ifce on 26/09/18.
//  Copyright © 2018 ifce. All rights reserved.
//

import UIKit
import WatchKit

class DetailInterfaceController: WKInterfaceController {
    var remedy: Remedy?
    @IBOutlet var titleLabel: WKInterfaceLabel!
    @IBOutlet var descriptionLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        guard let medicine = context as? Remedy else {
            return
        }
        titleLabel.setText(medicine.name)
        descriptionLabel.setText(medicine.remedyDescription)
        remedy = medicine
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func delayRemedy() {
        guard let remedyDate = remedy?.startDate else { return }
        remedy?.startDate = remedyDate.addingTimeInterval(600)
        updateAndReturn()
    }
    
    @IBAction func takeRemedy() {
        remedy?.taken = true
        updateAndReturn()
    }
    
    func updateAndReturn() {
        watchSession.sendMessage(["updateRemedy": remedy], replyHandler: { (response: [String:Any]) in
            self.pop()
        }) { (error) in
            let wkAction = WKAlertAction(title: "OK", style: .default, handler: {
                self.pop()
            })
            self.presentAlert(withTitle: "Unable to connect to device", message: "Make sure you are close to your device and try again later", preferredStyle: .alert, actions: [wkAction])
        }
    }
}
