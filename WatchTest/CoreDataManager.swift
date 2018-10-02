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
    
    static let sharedManager = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "database")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext() {
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveRemedy (name: String, remedyDescription: String,startDate: Date, interval: Int64) -> CDRemedy?{
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        let entity =  NSEntityDescription.entity(forEntityName: "CDRemedy", in: managedContext)
        let remedy = NSManagedObject(entity: entity!, insertInto: managedContext)
        remedy.setValue(UUID(), forKey: "id")
        remedy.setValue(name, forKeyPath: "name")
        remedy.setValue(remedyDescription, forKey: "remedyDescription")
        remedy.setValue(startDate, forKey: "startDate")
        remedy.setValue(interval, forKey: "interval")
        remedy.setValue(false, forKey: "taken")
        
        do {
            try remedy.managedObjectContext?.save()
            return remedy as? CDRemedy
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    func fetchRemedies () -> [CDRemedy]? {
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        let request = NSFetchRequest<CDRemedy>(entityName: "CDRemedy")
        request.returnsObjectsAsFaults = false
        do {
            let remedies = try managedContext.fetch(request)
            return remedies as! [CDRemedy]
        } catch let error as NSError {
            print ("Could not fetch. \(error), \(error.userInfo)")
        }
        return nil
    }
    
    func deleteRemedy (remedy: CDRemedy) {
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        managedContext.delete(remedy)
        saveContext()
    }
}
