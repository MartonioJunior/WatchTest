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

class InterfaceController: WKInterfaceController {
    @IBOutlet var tableRemedies: WKInterfaceTable!
    @IBOutlet var noRemediesTodayLabel: WKInterfaceLabel!
    var remedies: [Remedy] = []
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
      if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
            
            let msg = MessageWatch(eventType : .getAll , remedy : nil )
            guard let data = try? JSONEncoder().encode(msg) else {return}
            print("get all")
            session.sendMessageData(data, replyHandler: { (dataResult) in
                guard let list = try? JSONDecoder().decode([Remedy].self, from: dataResult) else {return}
                self.remedies = list
                self.setRemediesTable()
                print("get all 2 ")
            }) { error in
                let wkAction = WKAlertAction(title: "OK", style: .default, handler: {
                    self.dismiss()
                })
                self.presentAlert(withTitle: "Unable to connect to device", message: "Make sure you are close to your device and try again later", preferredStyle: .alert, actions: [wkAction])
            }
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
        //WCSession.default.activate()
        //self.tableRemedies.setNumberOfRows(remedies.count, withRowType: "TableRemedy")
        setRemediesTable()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func setRemediesTable() {
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
        
        tableRemedies.setNumberOfRows(0, withRowType: "TableRemedy")
        for index in 0..<self.tableRemedies.numberOfRows {
            addRemedyToTable(remedy: remedies[index])
        }
    }
    
    func addRemedyToTable(remedy: Remedy){
        remedies.append(remedy)
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "hh:mm"
        let index = tableRemedies.numberOfRows
        tableRemedies.setNumberOfRows( index + 1 , withRowType: "TableRemedy")
        guard let controller = tableRemedies.rowController(at: index) as? RemedyRowController else { return }
        controller.remedy = remedy
        controller.nomeLabel.setText(remedy.name)
        let time = dateFormat.string(from: remedy.startDate)
        controller.timeLabel.setText(time)
    }
}

extension InterfaceController: WCSessionDelegate {
    func sessionReachabilityDidChange(_ session: WCSession) {
        print(session)
    }
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {

        print("Session activation complete")
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("Watch received: \(applicationContext)")
    }
 
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        DispatchQueue.main.async {
            guard let msg = try? JSONDecoder().decode(MessageWatch.self, from: messageData) else{return}
            switch msg.eventType {
            case .new :
                self.didAdd(remedy: msg.remedy!)
            case .delay:
                print("delay")
            case .getAll:
                print("getAll")
            case .taken:
                print("taken")
            }
        }
    }
    
    
    func didAdd(remedy : Remedy){
        addRemedyToTable(remedy: remedy)
    }
}

