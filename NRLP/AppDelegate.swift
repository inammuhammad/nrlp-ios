//
//  AppDelegate.swift
//  1Link-NRLP
//
//  Created by ajmal on 06/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import netfox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var privacyProtectionWindow: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        if AppConstants.isDev {
            NFX.sharedInstance().start()
        }

        window = UIWindow(frame: UIScreen.main.bounds)
        Thread.sleep(forTimeInterval: 1.5)
        
        //Launch Controller
        let viewController = AppRouter().getTopViewController()
        self.window?.rootViewController = viewController
        self.window?.makeKeyAndVisible()
        
        if UIDevice.current.isJailBroken {
            let dialogMessage = UIAlertController(title: "Warning", message: "Your device is Jail Broken.", preferredStyle: .alert)
            viewController.present(dialogMessage, animated: true, completion: nil)
            return true
        }
        
        return true
    }
    
    // Inactive State
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        hidePrivacyProtectionWindow()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        showPrivacyProtectionWindow()
    }
    
    // Background State
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        hidePrivacyProtectionWindow()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        showPrivacyProtectionWindow()
    }
    
    //Show BlockVC Methods
    
    private func showPrivacyProtectionWindow() {
        privacyProtectionWindow = UIWindow(frame: UIScreen.main.bounds)
        privacyProtectionWindow?.rootViewController = BlockViewController()
        privacyProtectionWindow?.windowLevel = .alert + 1
        privacyProtectionWindow?.makeKeyAndVisible()
    }
    
    private func hidePrivacyProtectionWindow() {
        privacyProtectionWindow?.isHidden = true
        privacyProtectionWindow = nil
    }
    
}
