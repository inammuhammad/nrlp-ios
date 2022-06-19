//
//  AppDelegate.swift
//  1Link-NRLP
//
//  Created by ajmal on 06/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Firebase
import FirebaseCore
import FirebaseMessaging
import netfox
import UserNotifications
import IQKeyboardManagerSwift

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
        registerForPushNotifications()
        registerForRemotePushNotifications(application)
        
        if AppConstants.isDev {
            NFX.sharedInstance().start()
        }
        
        Thread.sleep(forTimeInterval: 1.5)
        
        // Launch Controller
        window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = AppRouter().getTopViewController()
        self.window?.rootViewController = viewController
        self.window?.makeKeyAndVisible()
        
        IQKeyboardManager.shared.enable = true

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
}

// MARK: - Push Notification Config
extension AppDelegate {
    private func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, _ in
                if AppConstants.isDev {
                    print("Notifications Permission Granted: \(granted)")
                }
                
                guard granted else { return }
                self?.getNotificationSettings()
            }
    }
    
    private func getNotificationSettings() {
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

// MARK: - Remote Push Notification Config
extension AppDelegate: MessagingDelegate, UNUserNotificationCenterDelegate {
    private func registerForRemotePushNotifications(_ application: UIApplication) {
        Messaging.messaging().delegate = self
        
        if #available(iOS 10.0, *) {
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
          )
        } else {
          let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
    }
    
    // Messaging
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if AppConstants.isDev {
            print("fcmToken: \(fcmToken ?? "nil")")
        }
    }
}
