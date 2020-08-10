//
//  DeviceDetailTableViewController.swift
//  CoreDataTutorial
//
//  Created by Narayanaswamy, Subhashini (623) on 09/08/20.
//  Copyright © 2020 Narayanaswamy, Subhashini (623). All rights reserved.
//

import UIKit
import CoreData

class DeviceDetailTableViewController: UITableViewController {
    var managedObjectContext: NSManagedObjectContext!
    
    var device: Device?
    var deviceType = ""
    
    @IBOutlet weak var lblDeviceOwner: UILabel!
    @IBOutlet weak var txtFieldDeviceName: UITextField!
    
    @IBOutlet weak var txtFieldDeviceType: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        txtFieldDeviceName.text = device?.name
        txtFieldDeviceType.text = device?.deviceType
        
        if let owner = device?.owner {
            lblDeviceOwner.text = "Device owner: \(String(describing: owner.name))"
        } else {
            lblDeviceOwner.text = "Set device owner"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if device == nil {
            if let name = txtFieldDeviceName.text, let deviceType = txtFieldDeviceType.text, let entity = NSEntityDescription.entity(forEntityName: "Device", in: managedObjectContext), !name.isEmpty && !deviceType.isEmpty {
                device = Device(entity: entity, insertInto: managedObjectContext)
                device?.deviceType = deviceType
                device?.name = name
            }
        }
    }
    
}
