//
//  InterfaceController.swift
//  WatchTest WatchKit Extension
//
//  Created by ifce on 25/09/18.
//  Copyright © 2018 ifce. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    @IBOutlet var tableRemedies: WKInterfaceTable!
    var remedies = [Remedy]()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        for index in 0..<tableRemedies.numberOfRows {
            guard let controller = tableRemedies.rowController(at: index) as? RemedyRowController else { continue }
            
            controller.remedy = remedies[index]
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
