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
class AppDelegate: UIResponder, UIApplicationDelegate, EKEventEditViewDelegate {
    
    var window: UIWindow?
    let eventStore = EKEventStore()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        // make url query dictionary
        var query : [String:String] = [:]
        url.query?.components(separatedBy: "&").forEach{
            let items = $0.components(separatedBy: "=")
            if let key = items.first, let val = items.last{
                query[key] = val.removingPercentEncoding!
            }
        }
        
        let eventEditVC = MRYEventEditViewController()
        eventEditVC.eventStore = eventStore
        eventEditVC.editViewDelegate = self

        if let startDateString = query["startDate"], let endDateString = query["endDate"] {
            let startDate = Util.sharedFormatter().date(from: startDateString)
            let endDate = Util.sharedFormatter().date(from: endDateString)
            if let eventId = query["eventId"] {
                let predicate = eventStore.predicateForEvents(withStart: startDate!, end: endDate!, calendars: nil )
                let events = eventStore.events(matching: predicate)
                eventEditVC.event = events.filter({ $0.eventIdentifier == eventId }).first
            }else{
                eventEditVC.event = EKEvent(eventStore: eventStore)
                eventEditVC.event!.startDate = startDate!
                eventEditVC.event!.endDate = endDate!
            }

        }
        
        self.window?.rootViewController!.present(eventEditVC, animated: true, completion: nil)

        return true
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        self.window?.rootViewController?.dismiss(animated: false, completion: nil)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true, completion: nil)
        let alert = UIAlertController(title: "ApptBoard", message: NSLocalizedString("You can go back to original App manually.", comment: "") , preferredStyle: .alert)
        let action = UIAlertAction(title: "OK",
                                   style: .default,
                                   handler: { [unowned alert] (action: UIAlertAction) in
            alert.dismiss(animated: true, completion: nil)
            })
        alert.addAction(action)
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }

}

