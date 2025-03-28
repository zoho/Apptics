//
//  AppDelegate.swift
//  AppticsDemo
//
//  Created by Saravanan S on 10/11/21.
//

import UIKit
import CoreData
import Apptics
import MetricKit
import AppticsFeedbackKit
import Apptics_Swift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let email = "apple@stackoverflow.com"
        let logger = Logger()
        logger.log("\(email, privacy: .auto)")
        logger.log("\(email, privacy: .auto(mask: .hash))")
        logger.log("\(email, privacy: .private)")
        logger.log("\(email, privacy: .private(mask: .hash))")
        logger.log("\(email, privacy: .sensitive)")
        logger.log("\(email, privacy: .sensitive(mask: .hash))")
//        AppticsExtensionManager.trackEvent(groupname: "", eventName: "", property: [:])
        let metricManager = MXMetricManager.shared
        metricManager.add(self)

        AppticsConfig.default.sendDataOnMobileNetworkByDefault=true // 🤖​ Set true to send data on mobile network.
        AppticsConfig.default.trackOnByDefault=true // 🤖​ Set true to track on by default before user consent.
        AppticsConfig.default.anonymousType = .pseudoAnonymous // 🤖​ Choose type of tracking you prefer, we support sudo-anonymous and non-anonymous.

        AppticsConfig.default.enableCrossPromotionAppsList = true // To enable Cross Promotion
        AppticsConfig.default.enableRateUs = true // To enable Rate us

        Apptics.initialize(withVerbose: true) // 🤖​ To initialise Apptics framework with or without verbose.
//        Apptics.setCompleteOff(false)
        Apptics.enableReviewAndSendCrashReport(true) // 🤖​ To show review prompt before sending the crash report.
//        Apptics.setDefaultLanguage("ar")
        Apptics.setTheme(AppTheme())

        FeedbackKit.startMonitoring(withShake: true, maxToleranceLimit: 3)
                FeedbackKit.setMaskTextByDefault(true)

                FeedbackKit.showInfoBeforeSendingFeedback(toUser: false)
                let dignoInfo = [[["key": "", "value": "ZUID - 869382"], ["key": "Conversation View", "value": "All Folders"], ["key": "Conversation Action", "value": "Folders based"], ["key": "Mark entire conversation as read", "value": "off"], ["key": "Notification status", "value": "on"], ["key": "User timezone", "value": "Asia/Calcutta"], ["key": "Sender based notification", "value": "off"], ["key": "Folder based notification", "value": "off"], ["key": "Badge Notification", "value": "Inbox"], ["key": "Streams enabled", "value": "on"], ["key": "Streams notification enabled", "value": "on"]], [["key": "", "value": "DEVICE DETAILS"], ["key": "Device cache count", "value": "231 200 325"], ["key": "Device timezone", "value": "Asia/Kolkata"], ["key": "Device Notification status", "value": "Authorized"]]]
                FeedbackKit.setDiagnosticInfo(dignoInfo)

        APLog.getInstance().shouldLog=true
        APLog.setLogLevel(APLogLevel.all)
        APLog.setMaximumNumberOfLogFiles(2)
        APLog.clearConsoleLogs()
        Test().log()
        
//        APLogVerbose("Verbose \(("someones@email.com" as NSString).ap_privacy(.sensitiveMask))")
//        
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

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "AppticsDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

extension AppDelegate: MXMetricManagerSubscriber {
  func didReceive(_ payloads: [MXMetricPayload]) {
    guard let firstPayload = payloads.first else { return }
    print(firstPayload.dictionaryRepresentation())
    print("----------------------------------")
  }

  func didReceive(_ payloads: [MXDiagnosticPayload]) {
    guard let firstPayload = payloads.first else { return }
    print(firstPayload.dictionaryRepresentation())
    print("----------------------------------")
  }
}
