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
    
    var coreDataStack: CoreDataStack!
    var fetchedresultsController: NSFetchedResultsController<NSFetchRequestResult>!
    var selectedPerson: Person?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        if let selectedPerson = selectedPerson {
            title = "\(selectedPerson.name!)'s Devices"
        } else {
          title = "Devices"
            navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDevice)), UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector((selectFilter)))]

        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Device")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "deviceType.name", ascending: true), NSSortDescriptor(key: "name", ascending: true)]
        
        fetchedresultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadData()
        tableView.reloadData()
        
    }
    
    func reloadData(predicate: NSPredicate? = nil) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Device")
        if let selectedPerson = selectedPerson {
            fetchedresultsController.fetchRequest.predicate = NSPredicate(format: "owner == %@", selectedPerson)
        } else {
            fetchedresultsController.fetchRequest.predicate = predicate
        }
        do {
            try fetchedresultsController.performFetch()
        } catch  {
            fatalError("There was an error fetching list of devices")
        }
        tableView.reloadData()
    }
    
    @objc func addDevice() {
        performSegue(withIdentifier: "deviceDetail", sender: self)
    }
    
    @objc func selectFilter() {
        let sheet = UIAlertController(title: "Filter Options", message: nil, preferredStyle: .actionSheet)
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            
        }))
        sheet.addAction(UIAlertAction(title: "Show All", style: .default, handler: { (action) in
            self.reloadData()
        }))
        
        sheet.addAction(UIAlertAction(title: "Only Owned Devices", style: .default, handler: { (action) -> Void in
            self.reloadData(predicate: NSPredicate(format: "owner != nil"))
        }))
        sheet.addAction(UIAlertAction(title: "Only phones", style: .default, handler: { (action) in
            self.reloadData(predicate: NSPredicate(format: "deviceType.name == %@", "iPhone"))
        }))
        sheet.addAction(UIAlertAction(title: "Only watches", style: .default, handler: { (action) in
            self.reloadData(predicate: NSPredicate(format: "deviceType.name == %@", "Watch"))
        }))
        
        present(sheet, animated: true, completion: nil)
    }
    
    @objc func setCoreDataStack(stack: CoreDataStack) {
        coreDataStack = stack
    }
    
}

extension DevicesTableViewController {
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedresultsController.sections?[section].numberOfObjects ?? 0
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell", for: indexPath)
        
        let device = fetchedresultsController.object(at: indexPath) as! Device
        cell.textLabel?.text = device.name
        cell.detailTextLabel?.text = device.deviceType?.name
        
        return cell
    }
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? DeviceDetailTableViewController {
            dest.coreDataStack = coreDataStack
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                let device = fetchedresultsController.object(at: selectedIndexPath) as! Device
                dest.device = device

            }
            
        }
    }
}
