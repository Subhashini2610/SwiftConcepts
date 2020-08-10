//
//  Device+CoreDataProperties.swift
//  CoreDataTutorial
//
//  Created by Narayanaswamy, Subhashini (623) on 10/08/20.
//  Copyright © 2020 Narayanaswamy, Subhashini (623). All rights reserved.
//
//

import Foundation
import CoreData


extension Device {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Device> {
        return NSFetchRequest<Device>(entityName: "Device")
    }

    @NSManaged public var deviceType: String
    @NSManaged public var name: String
    @NSManaged public var deviceID: String?
    @NSManaged public var purchaseDate: Date?
    @NSManaged public var owner: Person?

}
