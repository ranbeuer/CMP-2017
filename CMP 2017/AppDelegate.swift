//
//  AppDelegate.swift
//  CMP 2017
//
//  Created by Rodolfo Casanova on 6/23/18.
//  Copyright © 2018 Rodolfo Casanova. All rights reserved.
//

import UIKit
import AERecord
import Fabric
import Crashlytics
import GoogleMaps
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let image = UIImage(named: "list_black") //Leo Cid remove 1 to enable side menu
        
//        Fabric.with([Crashlytics.self])
        
        SideMenuController.preferences.drawing.menuButtonImage = image
        SideMenuController.preferences.drawing.sidePanelPosition = .overCenterPanelLeft
        SideMenuController.preferences.drawing.sidePanelWidth = UIScreen.main.bounds.size.width
        SideMenuController.preferences.drawing.centerPanelShadow = true
        SideMenuController.preferences.animating.statusBarBehaviour = .horizontalPan
        SideMenuController.preferences.interaction.swipingEnabled = false //remove to enable swiping on side menu
        do {
            try AERecord.loadCoreDataStack(options:[NSInferMappingModelAutomaticallyOption : true,
                                                    NSMigratePersistentStoresAutomaticallyOption : true])
        } catch {
            print(error)
        }
        GMSServices.provideAPIKey("AIzaSyBfsuDfpgIgEW2NdjiHqsvtlDabDwrz5cM")
        return true
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

