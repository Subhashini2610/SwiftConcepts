//
//  DeviceType+CoreDataProperties.swift
//  CoreDataTutorial
//
//  Created by Narayanaswamy, Subhashini (623) on 10/08/20.
//  Copyright © 2020 Narayanaswamy, Subhashini (623). All rights reserved.
//
//

import Foundation
import CoreData


extension DeviceType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DeviceType> {
        return NSFetchRequest<DeviceType>(entityName: "DeviceType")
    }

    @NSManaged public var name: String?
    @NSManaged public var devices: NSSet?

}

// MARK: Generated accessors for devices
extension DeviceType {

    @objc(addDevicesObject:)
    @NSManaged public func addToDevices(_ value: Device)

    @objc(removeDevicesObject:)
    @NSManaged public func removeFromDevices(_ value: Device)

    @objc(addDevices:)
    @NSManaged public func addToDevices(_ values: NSSet)

    @objc(removeDevices:)
    @NSManaged public func removeFromDevices(_ values: NSSet)

}
