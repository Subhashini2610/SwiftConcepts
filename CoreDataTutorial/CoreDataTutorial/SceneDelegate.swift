//
//  SceneDelegate.swift
//  CoreDataTutorial
//
//  Created by Narayanaswamy, Subhashini (623) on 09/08/20.
//  Copyright © 2020 Narayanaswamy, Subhashini (623). All rights reserved.
//

import UIKit
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Device")
        do {
            if let results = try appDelegate.coreDataStack.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject] {
                if results.count == 0 {
                    addTestData()
                }
                for result in results {
                    if let deviceType = result.value(forKey: "deviceType") as? String, let name = result.value(forKey: "name") as? String {
                        print("Got \(deviceType) named \(name)")
                    }
                }
            }
        } catch  {
            print("There was a fetch error")
        }
        
        if let tab = window?.rootViewController as? UITabBarController {
            for child in tab.viewControllers ?? [] {
                if let child = child as? UINavigationController, let top = child.topViewController {
                    if let top = top as? DevicesTableViewController {
                        top.setCoreDataStack(stack: appDelegate.coreDataStack)
                    } else if let top = top as? PeopleTableViewController {
                        top.setCoreDataStack(stack: appDelegate.coreDataStack)
                    } else if let top = top as? DebugViewController {
                        top.setCoreDataStack(stack: appDelegate.coreDataStack)
                    }
                }
            }
        }
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        try? (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.saveMainContext()
    }
    
    func addTestData() {
        let context = appDelegate.coreDataStack.managedObjectContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Device", in: context), let personEntity = NSEntityDescription.entity(forEntityName: "Person", in: context) else {
            fatalError("Could not find entity description")
        }
        
        for i in 1...10 {
            let device = Device(entity: entity, insertInto: appDelegate.coreDataStack.managedObjectContext)
            device.name = "Some device #\(i)"
            device.deviceType = i % 3 == 0 ? "Watch" : "iPhone"
        }
        
        let bob = Person(entity: personEntity, insertInto: context)
        bob.name = "Bob"
        
        let jane = Person(entity: personEntity, insertInto: context)
        jane.name = "Jane"
        
        try? appDelegate.coreDataStack.saveMainContext()
    }

}

