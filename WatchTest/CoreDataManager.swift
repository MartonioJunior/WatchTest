//
//  CoreDataManager.swift
//  WatchTest
//
//  Created by Ada 2018 on 26/09/2018.
//  Copyright © 2018 ifce. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    
    func initializeContainer (entity: String) -> NSManagedObject? {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return nil
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let entity =
            NSEntityDescription.entity(forEntityName: entity,
                                       in: managedContext)!
        let object = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        return object
    }
    
    func addRemedy (name: String, remedyDescription: String,startDate: Date, interval: Int64) {
        let remedy = initializeContainer(entity: "CDRemedy")
        remedy?.setValue(name, forKeyPath: "name")
        remedy?.setValue(remedyDescription, forKey: "remedyDescription")
        remedy?.setValue(startDate, forKey: "startDate")
        remedy?.setValue(interval, forKey: "interval")
        remedy?.setValue(false, forKey: "taken")
        do {
            try remedy?.managedObjectContext?.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
}
