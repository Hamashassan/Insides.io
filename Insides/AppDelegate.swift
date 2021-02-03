//
//  AppDelegate.swift
//  Insides
//
//  Created by Hamas Hassan on 1/18/21.
//  Copyright © 2021 Hamas Hassan. All rights reserved.
//
import GoogleSignIn
import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,GIDSignInDelegate {
    
    var window: UIWindow?
    let drinkActivityName = "com.insides.io.counter"
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        print("Launching Fresh")
        
        //        let activityDic = launchOptions![UIApplication.LaunchOptionsKey.userActivityDictionary] as? [AnyHashable : Any]
        //
        
        //        if activityDic != nil {
        //
        //            print("Hello")
        ////            if window!.rootViewController != nil {
        ////                let userActivity = activityDic["UIApplicationLaunchOptionsUserActivityKey"] as? NSUserActivity
        ////                if let userActivity = userActivity {
        ////                    window?.rootViewController?.restoreUserActivityState(userActivity)
        ////                }
        ////            }
        //        }
        
        
        
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance()?.clientID = "1092795728888-7vgmep898ed1u106i68lei3vg7ru2b1f.apps.googleusercontent.com"
        GIDSignIn.sharedInstance()?.delegate = self
        
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()

        
        // Override point for customization after application launch.
        
 
            let userActivityDictionary = (launchOptions?[UIApplication.LaunchOptionsKey.userActivityDictionary] as? [UIApplication.LaunchOptionsKey: Any])
        
        print("userActivityDictionary \(userActivityDictionary as Any)")
        
        let alert = UIAlertController(title: "App Del", message: "Hello", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: {action in
            print("cancel")
        }))
        
        window?.rootViewController?.present(alert, animated: true, completion: nil)
        
        
        let viewController = window?.rootViewController as? HomeViewController
        
        viewController?.incrementCounter(id: "")
        
        print("App launched")
        return true
    }
    
    //      func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
    //
    //            print("OPEN FROM SIRI")
    //
    //        return true
    //    }
    
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
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//        print("user email \(user.profile.email ?? "No email")")
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }
    
    //    private func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
    //
    //
    //        print("APPP DELLLEGAATEE")
    //
    //        switch userActivity.activityType {
    //        case drinkActivityName:
    //            // You can define your action due to application logic
    //            guard let viewController = window?.rootViewController as? HomeViewController else {
    //                return false
    //            }
    //
    //            // Check for drinkType which we passed while donating userActivity
    //            let counter_id = (userActivity.userInfo?["id"] as? String)!
    //
    //            print("app delegate \(counter_id)")
    //
    //
    //            // Pass argument to viewController for increment counter
    //            viewController.incrementCounter(id: counter_id)
    //
    //            return true
    //
    //        default:
    //            return false
    //        }
    //    }
    //
    
    //    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool;){
    //    print("fuuck")
    //    }
    
    private func application(application: UIApplication,
                             continueUserActivity userActivity: NSUserActivity,
                             restorationHandler: (([AnyObject]?) -> Void))
        -> Bool {
            
            let userInfo = userActivity.userInfo! as NSDictionary
            print("Received a payload via handoff: \(userInfo)")
            return true
    }
    
    
    
}
