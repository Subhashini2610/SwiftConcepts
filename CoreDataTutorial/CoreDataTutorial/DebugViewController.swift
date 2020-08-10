//
//  DebugViewController.swift
//  CoreDataTutorial
//
//  Created by Narayanaswamy, Subhashini (623) on 10/08/20.
//  Copyright © 2020 Narayanaswamy, Subhashini (623). All rights reserved.
//

import UIKit
import CoreData

class DebugViewController: UIViewController {

    var managedObjectContext: NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @objc func setManagedObjectContext(context: NSManagedObjectContext) {
        managedObjectContext = context
    }
    
    @IBAction func deleteAllDataTapped(_ sender: Any) {
        
        let deviceFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Device")
        let deviceDeleteRequest = NSBatchDeleteRequest(fetchRequest: deviceFetchRequest)
        deviceDeleteRequest.resultType = .resultTypeCount

        let personFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        let personDeleteRequest = NSBatchDeleteRequest(fetchRequest: personFetchRequest)
        personDeleteRequest.resultType = .resultTypeCount

        do {
            let personResult = try managedObjectContext.execute(personDeleteRequest) as! NSBatchDeleteResult
            let deviceResult = try managedObjectContext.execute(deviceDeleteRequest) as! NSBatchDeleteResult

            let alert = UIAlertController(title: "Batch Delete Succeeded", message: "\(deviceResult.result!) device records and \(personResult.result!) person records deleted.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        } catch {
            let alert = UIAlertController(title: "Batch Delete Failed", message: "There was an error with the batch delete. \(error)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        
    }
    @IBAction func unassignAllDevicesTapped(_ sender: Any) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Device")
        fetchRequest.predicate = NSPredicate(format: "owner != nil")

        do {
          if let results = try managedObjectContext.fetch(fetchRequest) as? [Device] {
            for device in results {
              device.owner = nil
            }

            do {
                try managedObjectContext.save()
            } catch  {
                print("Error saving context")
            }

            let alert = UIAlertController(title: "Batch Update Succeeded", message: "\(results.count) devices unassigned.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
          }
        } catch {
          let alert = UIAlertController(title: "Batch Update Failed", message: "There was an error unassigning the devices.", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
          present(alert, animated: true, completion: nil)
        }
        
    }
    
}
