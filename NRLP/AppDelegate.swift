//
//  AppDelegate.swift
//  1Link-NRLP
//
//  Created by ajmal on 06/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Firebase
import FirebaseCore
import netfox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let session: SessionContract = SessionManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        if AppConstants.isDev {
            NFX.sharedInstance().start()
        }
        
        Thread.sleep(forTimeInterval: 1.5)
        
        //Launch Controller
        window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = AppRouter().getTopViewController()
        self.window?.rootViewController = viewController
        self.window?.makeKeyAndVisible()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        session.resigningActiveSatate(Date())
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        session.resumingActiveState(Date())
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        session.terminatingApplication()
    }
}
