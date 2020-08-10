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
    
    @IBOutlet weak var imageView: UIImageView!
    private let datePicker = UIDatePicker()
    private var selectedDate: Date?
    private lazy var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.timeStyle = .none
        df.dateStyle = .medium
        return df
    }()
    private var deviceTypes = [DeviceType]()
    private let deviceTypePicker = UIPickerView()
    private var selectedDeviceType: DeviceType?

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(datePicker:)), for: .valueChanged)
        datePicker.datePickerMode = .date
        txtFieldPurchaseDate.inputView = datePicker
        
        loadDeviceTypes()
        deviceTypePicker.delegate = self
        deviceTypePicker.dataSource = self
        txtFieldDeviceType.inputView = deviceTypePicker
        if let device = device {
            
            txtFieldDeviceName.text = device.name
            txtFieldDeviceType.text = device.deviceType?.name
            txtFieldDeviceID.text = device.deviceID
            imageView.image = device.image
            
            if let deviceType = device.deviceType {
              selectedDeviceType = deviceType

              for index in 0...deviceTypes.count - 1 {
                  let oneDeviceType = deviceTypes[index]
                if deviceType == oneDeviceType {
                  deviceTypePicker.selectRow(index, inComponent: 0, animated: false)
                  break
                }
              }
            }

            if let owner = device.owner {
                lblDeviceOwner.text = "Device owner: \(owner.name!)"
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
                    print("Birthday buddy - \(birthdayBuddy.name!)")
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if let device = device, let name = txtFieldDeviceName.text {
            device.name = name
            device.deviceType = selectedDeviceType
            device.deviceID = txtFieldDeviceID.text
            device.purchaseDate = selectedDate
            device.image = imageView.image
        } else if device == nil {
            if let name = txtFieldDeviceName.text, let deviceType = txtFieldDeviceType.text, let deviceID = txtFieldDeviceID.text, let entity = NSEntityDescription.entity(forEntityName: "Device", in: coreDataStack.managedObjectContext), !name.isEmpty && !deviceType.isEmpty {
                device = Device(entity: entity, insertInto: coreDataStack.managedObjectContext)
                device?.deviceType = DeviceType(entity: NSEntityDescription.entity(forEntityName: "DeviceType", in: coreDataStack.managedObjectContext)!, insertInto: coreDataStack.managedObjectContext)
                device?.deviceType?.name = deviceType
                device?.name = name
                device?.deviceID = deviceID
                device?.purchaseDate = selectedDate
                device?.image = imageView.image
            }
        }
        
        do {
            try coreDataStack.saveMainContext()
        } catch  {
            print("Error saving managed object context")
        }
        
    }
    
    func loadDeviceTypes() {
      let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DeviceType")
      fetchRequest.sortDescriptors = [
        NSSortDescriptor(key: "name", ascending: true)
      ]

      do {
          if let results = try coreDataStack.managedObjectContext.fetch(fetchRequest) as? [DeviceType] {
          deviceTypes = results
        }
      } catch {
        fatalError("There was an error fetching the list of device types!")
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
        } else if indexPath.row == 5 {
            let sheet = UIAlertController(title: "Device Image", message: nil, preferredStyle: .actionSheet)

              sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            }))

            if imageView.image != nil {
              sheet.addAction(UIAlertAction(title: "Remove current image", style: .destructive, handler: { (action) -> Void in
                  DispatchQueue.main.async {
                      self.imageView.image = nil
                  }
                
              }))
            }

              sheet.addAction(UIAlertAction(title: "Select image from library", style: .default, handler: { (action) -> Void in
              let picker = UIImagePickerController()
                  picker.sourceType = .photoLibrary
              picker.delegate = self

                  self.present(picker, animated: true, completion: nil)
            }))

              present(sheet, animated: true, completion: nil)

        }
    }
}

extension DeviceDetailTableViewController: PersonPickerDelegate {
  func didSelectPerson(person: Person) {
    device?.owner = person

    try? coreDataStack.saveMainContext()
    
  }
}

extension DeviceDetailTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        DispatchQueue.main.async {
                self.imageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
}

extension DeviceDetailTableViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return deviceTypes[row].name
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedDeviceType = deviceTypes[row]
        txtFieldDeviceType.text = selectedDeviceType?.name
    }
}

extension DeviceDetailTableViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return deviceTypes.count
    }

}
