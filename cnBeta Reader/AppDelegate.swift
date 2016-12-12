//
//  AppDelegate.swift
//  cnBeta Reader
//
//  Created by Juncheng Han on 12/10/16.
//  Copyright © 2016 JasonH. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var coreDataStack = CoreDataStack()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let layout = UICollectionViewFlowLayout()
        let homeController = HomeController(collectionViewLayout: layout)
        homeController.managedContext = coreDataStack.context
        
        window?.rootViewController = UINavigationController(rootViewController: homeController)
        
        UINavigationBar.appearance().isHidden = true
        UINavigationBar.appearance().barTintColor = UIColor.rgb(red: 230, green: 32, blue: 32, alpha: 1.0)
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        let statusBarBackgroudView = UIView()
        statusBarBackgroudView.backgroundColor = UIColor.rgb(red: 194, green: 31, blue: 31, alpha: 1.0)
        window?.addSubview(statusBarBackgroudView)
        window?.addConstraintsWithFormat("H:|[v0]|", views: statusBarBackgroudView)
        window?.addConstraintsWithFormat("V:|[v0(20)]", views: statusBarBackgroudView)
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
        coreDataStack.saveContext()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
        coreDataStack.saveContext()
    }


}

