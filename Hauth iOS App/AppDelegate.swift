//
//  AppDelegate.swift
//  Hauth iOS App
//
//  Created by Rizwan Sattar on 11/7/15.
//  Copyright © 2015 Rizwan Sattar. All rights reserved.
//

import UIKit
import Hauth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var server: HauthServer!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        let name = UIDevice.currentDevice().name;
        let appId = NSBundle.mainBundle().bundleIdentifier!;
        self.server = HauthServer(displayName: name, appId: appId)
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        self.server.stopAdvertising()
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        self.server.startAdvertisingWithRequestHandler { (displayName, responseHandler) -> Void in

            let alertController = UIAlertController(title: "Allow Auth?", message: "Allow \"\(displayName)\" access to your login?", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Not Now", style: .Cancel, handler: { action in
                responseHandler(nil, nil)
            }))

            alertController.addAction(UIAlertAction(title: "Allow", style: .Default, handler: { action in
                let tokenData = "THIS IS AN AUTH TOKEN".dataUsingEncoding(NSUTF8StringEncoding)!
                responseHandler(tokenData, nil)
            }))

            self.window?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)

        }
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

