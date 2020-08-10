//
//  DeviceTypeMigrationV1ToV2.swift
//  CoreDataTutorial
//
//  Created by Narayanaswamy, Subhashini (623) on 10/08/20.
//  Copyright © 2020 Narayanaswamy, Subhashini (623). All rights reserved.
//

import CoreData

class DeviceTypeMigrationV1ToV2: NSEntityMigrationPolicy {
    override func createDestinationInstances(forSource sInstance: NSManagedObject, in mapping: NSEntityMapping, manager: NSMigrationManager) throws {
        try super.createDestinationInstances(forSource: sInstance, in: mapping, manager: manager)
        
        //create or lookup the device type
        
        var deviceTypeInstance: NSManagedObject!
        let deviceTypeName = sInstance.value(forKey: "deviceType") as! String
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DeviceType")
        
        fetchRequest.predicate = NSPredicate(format: "name == %@", deviceTypeName)
        
        let results = try manager.destinationContext.fetch(fetchRequest)
        
        if let resultInstance = results.last as? NSManagedObject {
            deviceTypeInstance = resultInstance
        } else {
            let entity = NSEntityDescription.entity(forEntityName: "DeviceType", in: manager.destinationContext)!
            deviceTypeInstance = NSManagedObject(entity: entity, insertInto: manager.destinationContext)
            deviceTypeInstance.setValue(deviceTypeName, forKey: "name")
        }
        
        //get the destination device
        let destResults = manager.destinationInstances(forEntityMappingName: mapping.name, sourceInstances: [sInstance])
        if let destinationDevice = destResults.last {
            destinationDevice.setValue(deviceTypeInstance, forKey: "deviceType")
        }
        
    }
}
