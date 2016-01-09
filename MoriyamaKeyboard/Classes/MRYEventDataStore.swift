//
//  MRYEventDataStore.swift
//  Moriyama
//
//  Created by Ichiro on 2016/01/07.
//  Copyright © 2016年 Ichiro. All rights reserved.
//

import UIKit
import EventKit

class MRYEventDataStore: NSObject {
    let store = EKEventStore()
    static let this = MRYEventDataStore()
    override init(){
        if EKEventStore.authorizationStatusForEntityType(.Event) != EKAuthorizationStatus.Authorized {
            // 許可されてないので許可を要求
            store.requestAccessToEntityType(.Event,
                completion: {(granted: Bool, error: NSError?) -> Void in
                    if granted{
                        print("granted!")
                    }else{
                        print("rejectd!")
                    }
            })
        }
    }
    class func singleton() -> MRYEventDataStore{
        return this
    }
    
    func eventWithDate(date: NSDate) -> [EKEvent]{
        let startDate = date
        let endDate = startDate.dateByAddingTimeInterval(86400) // 当日
        let predicate = store.predicateForEventsWithStartDate(startDate, endDate: endDate, calendars: nil)
        let events = store.eventsMatchingPredicate(predicate)
        return events
    }
    
//    func eventWithDate(date: NSDate) -> [MRYEvent]{
//        let startDate = date
//        let endDate = startDate.dateByAddingTimeInterval(86400) // 当日
//        let predicate = store.predicateForEventsWithStartDate(startDate, endDate: endDate, calendars: nil)
//        let events = store.eventsMatchingPredicate(predicate)
//        let _events = events.map{ MRYEvent( event: $0) }
//        return _events
//    }


}
