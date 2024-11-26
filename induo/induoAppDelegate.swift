//
//  induoAppDelegate.swift
//  induo
//
//  Created by Breea Toomey on 11/19/24.
//

import Foundation
import SwiftUI
import UIKit
import Firebase
import FirebaseCore
import FirebaseAuthUI
import GoogleSignIn

class induoAppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                         didFinishLaunchingWithOptions launchOptions:
                         [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            FirebaseApp.configure()
            
            return true
        }
        
        func application(_ app: UIApplication, open url: URL,
                         options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
            let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
          if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
          }
          // other URL handling goes here.
          return false
        }
        
        func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
          print("\(#function)")
          Auth.auth().setAPNSToken(deviceToken, type: .sandbox)
        }
        
        func application(_ application: UIApplication, didReceiveRemoteNotification notification: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
          print("\(#function)")
          if Auth.auth().canHandleNotification(notification) {
            completionHandler(.noData)
            return
          }
        }
}
