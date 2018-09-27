//
//  InterfaceController.swift
//  WatchTest WatchKit Extension
//
//  Created by ifce on 25/09/18.
//  Copyright © 2018 ifce. All rights reserved.
//

import WatchKit
import WatchConnectivity
import Foundation

var watchSession = WCSession.default

class InterfaceController: WKInterfaceController {
    @IBOutlet var tableRemedies: WKInterfaceTable!
    @IBOutlet var noRemediesTodayLabel: WKInterfaceLabel!
    var remedies: [Remedy] = []
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        watchSession.delegate = self
        watchSession.activate()
        watchSession.sendMessage(["getRemediesForToday" : "", "updateRemedy": remedies], replyHandler: { (response: [String:Any]) in
            self.remedies = response["remedies"] as! [Remedy]
        }) { (e) in
            let wkAction = WKAlertAction(title: "OK", style: .default, handler: {
                self.dismiss()
            })
            self.presentAlert(withTitle: "Unable to connect to device", message: "Make sure you are close to your device and try again later", preferredStyle: .alert, actions: [wkAction])
            self.remedies.append(Remedy(name: "Luftal", interval: 60, description: "Para dor de barriga", startDate: Date(), taken: false))
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        DispatchQueue.main.async {
            self.pushController(withName: "Detail", context: self.remedies[rowIndex])
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        self.remedies = (self.remedies.filter { (remedy: Remedy) -> Bool in
            return !remedy.taken
        }).sorted(by: { (r1, r2) -> Bool in
            let calendar = Calendar.current
            let r1Components = calendar.dateComponents([.hour,.minute], from: r1.startDate)
            let r2Components = calendar.dateComponents([.hour,.minute], from: r2.startDate)
            if r1Components.hour == r2Components.hour {
                return (r1Components.minute ?? 0) < (r2Components.minute ?? 0)
            } else {
                return (r1Components.hour ?? 0) < (r2Components.hour ?? 0)
            }
        })
        noRemediesTodayLabel.setText(remedies.count <= 0 ? "No remedies to take!" : "")
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "hh:mm"
        
        tableRemedies.setNumberOfRows(remedies.count, withRowType: "TableRemedy")
        
        for index in 0..<self.tableRemedies.numberOfRows {
            guard let controller = tableRemedies.rowController(at: index) as? RemedyRowController else { continue }
            let remedy = remedies[index]
            controller.remedy = remedy
            controller.nomeLabel.setText(remedy.name)
            let time = dateFormat.string(from: remedy.startDate)
            controller.timeLabel.setText(time)
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}

extension InterfaceController: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Session activation complete")
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("Watch received: \(applicationContext)")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let action = message.keys.first {
            if action.elementsEqual("didTakeRemedio") {
                guard let remedy = message[action] as? Remedy else {return}
                didTake(remedy: remedy)
            }
        }
    }
    
    func didTake(remedy : Remedy){
        print("remedio foi todamo \(remedy.name)")
    }
}

