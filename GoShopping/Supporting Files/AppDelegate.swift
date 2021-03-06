//
//  AppDelegate.swift
//  GoShopping
//
//  Created by Nguyen Lam on 12/15/18.
//  Copyright © 2018 Nguyen Lam. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var firstLoad: Bool?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true // this will store database locally and auto-sync when have network
        
        loadUserDefault()
        Auth.auth().addStateDidChangeListener { [unowned self](auth, user) in
            if user != nil {
                if UserDefaults.standard.object(forKey: kCURRENCY) != nil {
                    self.gotoMainView()
                }
            }
        }
        
        return true
    }
    
    func loadUserDefault() {
        
        firstLoad = UserDefaults.standard.bool(forKey: kFIRSTRUN)
        
        if firstLoad! == false {
            UserDefaults.standard.set(true, forKey: kFIRSTRUN)
            UserDefaults.standard.set("USD", forKey: kCURRENCY)
        }
        
    }

    func gotoMainView() {
        let mainVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainView") as! UITabBarController
        mainVC.selectedIndex = 0
        //self.present(mainVC, animated: true)
        self.window?.rootViewController?.present(mainVC, animated: true, completion: nil)
        
//        self.window = UIWindow(frame: UIScreen.main.bounds)
//        self.window?.rootViewController = mainVC
//        self.window?.makeKeyAndVisible()
        
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

