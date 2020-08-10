//
//  CoreDataStack.swift
//  CoreDataTutorial
//
//  Created by Narayanaswamy, Subhashini (623) on 10/08/20.
//  Copyright © 2020 Narayanaswamy, Subhashini (623). All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack: NSObject {
    static let moduleName = "CoreDataTutorial"
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: CoreDataStack.moduleName, withExtension: "momd")
        return NSManagedObjectModel(contentsOf: modelURL!)!
    }()
    
    lazy var applicationDocumentsDirectory: URL = {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    }()
    
    private lazy var saveManagedObjectContext: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        moc.persistentStoreCoordinator = self.persistentStoreCoordinator
        return moc
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        let persistantStoreURL = self.applicationDocumentsDirectory.appendingPathComponent("\(CoreDataStack.moduleName).sqlite")
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: persistantStoreURL, options: [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: false])//false as we have our own mapping model.
        }catch {
            print("Persistent store error \(error)")
        }
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.parent = self.saveManagedObjectContext
        return managedObjectContext
    }()
    
    func saveMainContext () throws {
        
        guard managedObjectContext.hasChanges || saveManagedObjectContext.hasChanges else {
            return
        }
        //to ensure it runs on main queue
        managedObjectContext.performAndWait {
            do {
                try self.managedObjectContext.save()
            } catch {
                print("Error saving main managed object context \(error)")
            }
        }
        
        //can be run async; so only perform
        saveManagedObjectContext.perform {
            do {
                try self.saveManagedObjectContext.save()
            } catch {
                print("Error saving private managed object context \(error)")
            }
        }
    }
}
