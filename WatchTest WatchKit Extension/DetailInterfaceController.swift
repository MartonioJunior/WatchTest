//
//  DetailInterfaceController.swift
//  WatchTest WatchKit Extension
//
//  Created by ifce on 26/09/18.
//  Copyright © 2018 ifce. All rights reserved.
//

import UIKit
import WatchKit
import WatchConnectivity

class DetailInterfaceController: WKInterfaceController {
    var remedy: Remedy?
    var watchSession : WCSession!
    @IBOutlet var titleLabel: WKInterfaceLabel!
    @IBOutlet var descriptionLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        if WCSession.isSupported() {
            watchSession = WCSession.default
            watchSession.delegate = self
            watchSession.activate()
        }
        
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
        let msg = MessageWatch(eventType: .delay, remedy: remedy)
        updateAndReturn(msg: msg)
    }
    
    @IBAction func takeRemedy() {
        let msg = MessageWatch(eventType: .taken, remedy: remedy)
        updateAndReturn(msg: msg)
    }
    
    func updateAndReturn(msg: MessageWatch) {
        guard let data = try? JSONEncoder().encode(msg) else {return}
        watchSession.sendMessageData(data, replyHandler: { resultData in
            guard let msg = try? JSONDecoder().decode(Remedy.self, from: resultData) else {return}
            self.remedy?.startDate = msg.startDate
            self.remedy?.taken = msg.taken
            self.pop()
        }) { (error) in
            let wkAction = WKAlertAction(title: "OK", style: .default, handler: {
                self.pop()
            })
            self.presentAlert(withTitle: "Unable to connect to device", message: "Make sure you are close to your device and try again later", preferredStyle: .alert, actions: [wkAction])
        }
    }
}


// MARK: - <#WCSessionDelegate#>
extension DetailInterfaceController : WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }    
}
