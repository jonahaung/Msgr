//
//  AppDelegateAdaptor.swift
//  Myanmar Song Book
//
//  Created by Aung Ko Min on 9/5/22.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseMessaging

class AppDelegateAdaptor: NSObject, UIApplicationDelegate {

    let pushNotificationManager = PushNotificationManager.shared
    let authenticator = Authenticator.shared
   

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication .LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        pushNotificationManager.registerForPushNotifications()
        authenticator.observe()
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Auth.auth().setAPNSToken(deviceToken, type: .sandbox)
        Messaging.messaging().apnsToken = deviceToken
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
        if Auth.auth().canHandleNotification(userInfo) {
            return .noData
        } else {
            Messaging.messaging().appDidReceiveMessage(userInfo)
            return .newData
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataStack.shared.save()
    }

    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        if Auth.auth().canHandle(url) {
            return true
        }
        return true
    }
}
