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
            lblDeviceOwner.text = "Device owner: \(owner.name)"
        } else {
            lblDeviceOwner.text = "Set device owner"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if let device = device, let name = txtFieldDeviceName.text, let type = txtFieldDeviceType.text {
            device.name = name
            device.deviceType = type
        } else if device == nil {
            if let name = txtFieldDeviceName.text, let deviceType = txtFieldDeviceType.text, let entity = NSEntityDescription.entity(forEntityName: "Device", in: managedObjectContext), !name.isEmpty && !deviceType.isEmpty {
                device = Device(entity: entity, insertInto: managedObjectContext)
                device?.deviceType = deviceType
                device?.name = name
            }
        }
        
        do {
            try managedObjectContext.save()
        } catch  {
            print("Error saving managed object context")
        }
        
    }
    
}

extension DeviceDetailTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            if let personPicker = storyboard?.instantiateViewController(withIdentifier: "People") as? PeopleTableViewController {

              // more personPicker setup code here
                personPicker.managedObjectContext = managedObjectContext
              personPicker.pickerDelegate = self
              personPicker.selectedPerson = device?.owner

              navigationController?.pushViewController(personPicker, animated: true)
            }
        }
    }
}

extension DeviceDetailTableViewController: PersonPickerDelegate {
  func didSelectPerson(person: Person) {
    device?.owner = person

    do {
        try managedObjectContext.save()
    } catch  {
        print("Error saving managedObjectContext")
    }
  }
}
