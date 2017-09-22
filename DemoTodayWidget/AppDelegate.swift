//
//  AppDelegate.swift
//  DemoTodayWidget
//
//  Created by mehulmac on 18/09/17.
//  Copyright © 2017 mehulmac. All rights reserved.
//

import UIKit
import SwiftyJSON

let sharedNotificationKey = "group.Sooryen.DemoTodayWidget.notificationKey"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    //Do not use space oy any other special character in URL scheme, otherwise you will waste too much time for solving error. ;-)
    let widgetURLScheme = "MyWidget://"
    var jsonSharedData = JSON()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    //Extension get method, if someone shared anything...
    func application(_ application: UIApplication, open url: URL,
                     sourceApplication: String?, annotation: Any) -> Bool {
        
        if url.absoluteString.contains(widgetURLScheme) {
            return true
        }
        
        return false
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if url.absoluteString.contains(widgetURLScheme) {
            if let defaults = UserDefaults(suiteName: "group.Sooryen.DemoTodayWidget") {
                if let strSharedData_From_Widget : String = defaults.object(forKey: "extensionSharedDataString") as? String {
                    jsonSharedData = JSON(strSharedData_From_Widget)
                    
                    //Fired notifications
                    NotificationCenter.default.post(name: Notification.Name(rawValue: sharedNotificationKey), object: jsonSharedData)
                }
            }

            return true
        }
        return false
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

