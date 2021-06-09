//
//  AppDelegate.swift
//  QatarCalendarHouse
//
//  Created by Amr Salman on 2/7/20.
//  Copyright © 2020 Infovass. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import UserNotifications
import StorageManager
import OneSignal
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes
#if DEBUG
import Gedatsu
#endif

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coordinator: ApplicationCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupUIApearance()
        initualizeNontification(with: launchOptions)
        loadFirstScreen()
        configurations()
        
        return true
    }
        
    func applicationWillTerminate(_ application: UIApplication) {

    }
}

//MARK: - Helpers
extension AppDelegate: OSSubscriptionObserver {
        
    fileprivate func setupUIApearance() {
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18),
            NSAttributedString.Key.foregroundColor: R.color.white() ?? .white
        ]
        UINavigationBar.appearance().barTintColor = R.color.primary()
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance(whenContainedInInstancesOf: [UIDocumentBrowserViewController.self]).tintColor = nil
        UIView.appearance().semanticContentAttribute = .forceLeftToRight
    }
    
    fileprivate func initualizeNontification(with launchOptions: [UIApplication.LaunchOptionsKey : Any]?) {
                
        let onesignalInitSettings: [String : Any] = [kOSSettingsKeyAutoPrompt: false, kOSSettingsKeyInFocusDisplayOption: OSNotificationDisplayType.notification.rawValue]
        
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "3e79232f-1c90-47b3-a43a-7c5a26254131",
                                        handleNotificationAction: nil,
                                        settings: onesignalInitSettings)
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
        
        OneSignal.add(self as OSSubscriptionObserver)
    }
    
    func onOSSubscriptionChanged(_ stateChanges: OSSubscriptionStateChanges!) {
       if !stateChanges.from.subscribed && stateChanges.to.subscribed {
          print("Subscribed for OneSignal push notifications!")
          // get player ID
          stateChanges.to.userId
       }
       print("SubscriptionStateChange: \n\(stateChanges)")
    }

    fileprivate func configurations() {
        let MEMORY_CAPACITY = 4 * 1024 * 1024
        let DISK_CAPACITY =  20 * 1024 * 1024

        let cache = URLCache(memoryCapacity: MEMORY_CAPACITY, diskCapacity: DISK_CAPACITY, diskPath: nil)
        URLCache.shared = cache
        
        IQKeyboardManager.shared.enable = true
        
        UNUserNotificationCenter.current().delegate = self
        
        MSAppCenter.start("c3ce67ac-89fe-4e1e-9db7-61cfe7f14a77", withServices:[
          MSAnalytics.self,
          MSCrashes.self
        ])
        
        #if DEBUG
        Gedatsu.open()
        #endif
    }
    
    fileprivate func loadFirstScreen() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        if #available(iOS 13.0, *) {
            let appearance = UserDefaults.standard.appearance
            if appearance == "dark" {
                window.overrideUserInterfaceStyle = .dark
            } else if appearance == "light" {
                window.overrideUserInterfaceStyle = .light
            }
        }
        self.window = window
        coordinator = ApplicationCoordinator(window: window)
        coordinator?.start()
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        completionHandler(.alert)
    }
}
