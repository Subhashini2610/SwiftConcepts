//
//  PeopleTableViewController.swift
//  CoreDataTutorial
//
//  Created by Narayanaswamy, Subhashini (623) on 09/08/20.
//  Copyright © 2020 Narayanaswamy, Subhashini (623). All rights reserved.
//

import UIKit
import CoreData

protocol PersonPickerDelegate: class {
    func didSelectPerson(person: Person)
}

public class PeopleTableViewController: UITableViewController {
    
    var managedObjectContext: NSManagedObjectContext!
    var people = [Person]()
    
    weak var pickerDelegate: PersonPickerDelegate?
    var selectedPerson: Person?

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "People"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPerson))
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadData()
        tableView.reloadData()
        
    }
    
    func reloadData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
//        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
//        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            if let results = try managedObjectContext.fetch(fetchRequest) as? [Person] {
                people = results
            }
        } catch  {
            fatalError("There was an error fetching list of devices")
        }
        
    }
    
    @objc func addPerson() {
        let alert = UIAlertController(title: "Add a Person", message: "Name?", preferredStyle: .alert)
        alert.addTextField { (textField) in
            
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            if let name = alert.textFields?.first?.text {
                self.addNewPerson(name: name)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func addNewPerson(name: String) {
        if let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedObjectContext) {
            let newPerson = Person(entity: entity, insertInto: managedObjectContext)
            newPerson.name = name
            
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.saveContext()
                self.reloadData()
                tableView.reloadData()
            }
        }
    }
    
    @objc func setManagedObjectContext(context: NSManagedObjectContext) {
        managedObjectContext = context
    }
}

extension PeopleTableViewController {
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleCell", for: indexPath)
        
        let person = people[indexPath.row]
        if let name = person.value(forKey: "name") as? String {
            cell.textLabel?.text = name
        }
        if let selectedPerson = selectedPerson, selectedPerson == person {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let pickerDelegate = pickerDelegate {
            let person = people[indexPath.row]
            selectedPerson = person
            pickerDelegate.didSelectPerson(person: selectedPerson!)
            tableView.reloadData()
        } else {
            if let devicesTableViewController = storyboard?.instantiateViewController(identifier: "Devices") as? DevicesTableViewController {
                let person = people[indexPath.row]
                devicesTableViewController.managedObjectContext = managedObjectContext
                devicesTableViewController.selectedPerson = person
                navigationController?.pushViewController(devicesTableViewController, animated: true)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
