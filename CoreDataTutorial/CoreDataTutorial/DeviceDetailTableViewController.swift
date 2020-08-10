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
    var coreDataStack: CoreDataStack!

    var device: Device?
    var deviceType = ""
    
    @IBOutlet weak var lblDeviceOwner: UILabel!
    @IBOutlet weak var txtFieldDeviceName: UITextField!
    
    @IBOutlet weak var txtFieldDeviceType: UITextField!
    @IBOutlet weak var txtFieldDeviceID: UITextField!
    
    @IBOutlet weak var txtFieldPurchaseDate: UITextField!
    
    private let datePicker = UIDatePicker()
    private var selectedDate: Date?
    private lazy var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.timeStyle = .none
        df.dateStyle = .medium
        return df
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(datePicker:)), for: .valueChanged)
        datePicker.datePickerMode = .date
        txtFieldPurchaseDate.inputView = datePicker
        
        
        if let device = device {
            
            txtFieldDeviceName.text = device.name
            txtFieldDeviceType.text = device.deviceType
            txtFieldDeviceID.text = device.deviceID
            
            if let owner = device.owner {
                lblDeviceOwner.text = "Device owner: \(owner.name)"
            } else {
                lblDeviceOwner.text = "Set device owner"
            }
            
            if let purchaseDate = device.purchaseDate {
                selectedDate = purchaseDate
                datePicker.date = purchaseDate
                txtFieldPurchaseDate.text = dateFormatter.string(from: purchaseDate)
            }
            
            coreDataStack.managedObjectContext.refresh(device, mergeChanges: true)
            if let birthdayBuddies = device.value(forKey: "purchasedOnSameDate") as? [Device] {
                for birthdayBuddy in birthdayBuddies {
                    print("Birthday buddy - \(birthdayBuddy.name)")
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if let device = device, let name = txtFieldDeviceName.text, let deviceType = device.deviceType {
            device.name = name
            device.deviceType = deviceType
            device.deviceID = txtFieldDeviceID.text
            device.purchaseDate = selectedDate
        } else if device == nil {
            if let name = txtFieldDeviceName.text, let deviceType = txtFieldDeviceType.text, let deviceID = txtFieldDeviceID.text, let entity = NSEntityDescription.entity(forEntityName: "Device", in: coreDataStack.managedObjectContext), !name.isEmpty && !deviceType.isEmpty {
                device = Device(entity: entity, insertInto: coreDataStack.managedObjectContext)
                device?.deviceType = deviceType
                device?.name = name
                device?.deviceID = deviceID
                device?.purchaseDate = selectedDate
            }
        }
        
        do {
            try coreDataStack.saveMainContext()
        } catch  {
            print("Error saving managed object context")
        }
        
    }
    @objc func datePickerValueChanged(datePicker: UIDatePicker) {
      txtFieldPurchaseDate.text = dateFormatter.string(from: datePicker.date)
      selectedDate = dateFormatter.date(from: txtFieldPurchaseDate.text!)
    }
    
}

extension DeviceDetailTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            if let personPicker = storyboard?.instantiateViewController(withIdentifier: "People") as? PeopleTableViewController {

              // more personPicker setup code here
                personPicker.coreDataStack = coreDataStack
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

    try? coreDataStack.saveMainContext()
    
  }
}
