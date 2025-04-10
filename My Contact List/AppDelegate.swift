//
//  AppDelegate.swift
//  My Contact List
//
//  Created by user272075 on 3/30/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let settings = UserDefaults.standard
        
        if( settings.string(forKey: "sortField")) == nil {
            settings.set("City", forKey: "sortField")
        }
        if settings.string(forKey: "sortDirectionAscending") == nil {
            settings.set(true, forKey: "sortDirectionAscending")
        }
        settings.synchronize()
        print("Sort field: \(settings.string(forKey: "sortField")!)")
        print("Sort direction: \(settings.bool(forKey: "sortDirectionAscending"))")
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


}

