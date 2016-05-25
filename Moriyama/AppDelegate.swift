//
//  AppDelegate.swift
//  Moriyama
//
//  Created by Ichiro on 2015/12/25.
//  Copyright © 2015年 Ichiro. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    let eventStore = EKEventStore()
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        // make url query dictionary
        var query : [String:String] = [:]
        url.query?.componentsSeparatedByString("&").forEach{
            let items = $0.componentsSeparatedByString("=")
            if let key = items.first, let val = items.last{
                query[key] = val
            }
        }
        
        // extract event id and open event.
        if let eventId = query["eventId"]{
            let eventVC = MRYEventEditViewController()
            eventVC.eventStore = eventStore
            eventVC.editViewDelegate = eventVC
            if let event = eventStore.eventWithIdentifier(eventId){
                eventVC.event = event
            }else{
                eventVC.event = EKEvent(eventStore: eventStore)
            }
            self.window?.rootViewController!.presentViewController(eventVC, animated: true, completion: nil)
        }
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

