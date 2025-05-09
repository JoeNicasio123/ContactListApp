//
//  AppDelegate.swift
//  My Contact List
//
//  Created by user272075 on 3/30/25.
//

import UIKit
import CoreData
import CoreMotion

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    lazy var motionManager = CMMotionManager()



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let settings = UserDefaults.standard
        
        if( settings.string(forKey: Constants.kSortField)) == nil {
            settings.set("city", forKey: Constants.kSortField)
        }
        if settings.string(forKey: Constants.kSortDirectionAscending) == nil {
            settings.set(true, forKey: Constants.kSortDirectionAscending)
        }
        settings.synchronize()
        print("Sort field: \(settings.string(forKey: Constants.kSortField)!)")
        print("Sort direction: \(settings.bool(forKey: Constants.kSortDirectionAscending))")
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
    lazy var persistentContainer: NSPersistentContainer = {
           
           let container = NSPersistentContainer(name: "MyContactListModel")
           container.loadPersistentStores(completionHandler: { (storeDescription, error) in
               if let error = error as NSError? {
                  
                   fatalError("Unresolved error \(error), \(error.userInfo)")
               }
           })
           return container
       }()
       
       
       func saveContext () {
           let context = persistentContainer.viewContext
           if context.hasChanges {
               do {
                   try context.save()
               } catch {
                  
                   let nserror = error as NSError
                   fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
               }
           }
       }
}

