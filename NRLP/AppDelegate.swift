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
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var lastViewController: UIViewController?
    let session: SessionContract = SessionManager()
    
    private lazy var backgroundWindow: UIWindow = {
        let screen = UIScreen.main
        let window = UIWindow(frame: screen.bounds)
        window.screen = screen
        window.rootViewController = BlockViewController()
        window.windowLevel = .alert
        return window
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        if AppConstants.isDev {
            NFX.sharedInstance().start()
        }
        
        Thread.sleep(forTimeInterval: 1.5)
        
        // Launch Controller
        window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = AppRouter().getTopViewController()
        self.window?.rootViewController = viewController
        self.window?.makeKeyAndVisible()
        
        registerForPushNotifications()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        backgroundWindow.isHidden = false
        session.resigningActiveSatate(Date())
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        backgroundWindow.isHidden = true
        session.resumingActiveState(Date())
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        session.terminatingApplication()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        backgroundWindow.isHidden = false
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        backgroundWindow.isHidden = true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Fail to Register: \(error)")
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, _ in
                if AppConstants.isDev {
                    print("Notifications Permission Granted: \(granted)")
                }
                
                guard granted else { return }
                self?.getNotificationSettings()
            }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if AppConstants.isDev {
                print("Notification settings: \(settings)")
                guard settings.authorizationStatus == .authorized else { return }
                
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
}
