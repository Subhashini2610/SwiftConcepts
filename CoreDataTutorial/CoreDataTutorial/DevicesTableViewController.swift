//
//  DevicesTableViewController.swift
//  CoreDataTutorial
//
//  Created by Narayanaswamy, Subhashini (623) on 09/08/20.
//  Copyright © 2020 Narayanaswamy, Subhashini (623). All rights reserved.
//

import UIKit
import CoreData

public class DevicesTableViewController: UITableViewController {
    
    var managedObjectContext: NSManagedObjectContext!
    var devices = [NSManagedObject]()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Devices"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDevice))
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadData()
        tableView.reloadData()
        
    }
    
    func reloadData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Device")
        
        do {
            if let results = try managedObjectContext.fetch(fetchRequest) as? [NSManagedObject] {
                devices = results
            }
        } catch  {
            fatalError("There was an error fetching list of devices")
        }
        
    }
    
    @objc func addDevice() {
        performSegue(withIdentifier: "deviceDetail", sender: self)
    }
    
    @objc func setManagedObjectContext(context: NSManagedObjectContext) {
        managedObjectContext = context
    }
    
}

extension DevicesTableViewController {
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell", for: indexPath)
        
        let device = devices[indexPath.row]
        if let deviceName = device.value(forKey: "name") as? String, let deviceType = device.value(forKey: "deviceType") as? String {
            cell.textLabel?.text = deviceName
            cell.detailTextLabel?.text = deviceType
        }
        
        return cell
    }
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? DeviceDetailTableViewController {
            dest.managedObjectContext = managedObjectContext
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                let device = devices[selectedIndexPath.row]
                dest.deviceName = device.value(forKey: "name") as! String
                dest.deviceType = device.value(forKey: "deviceType") as! String

            }
            
        }
    }
}
