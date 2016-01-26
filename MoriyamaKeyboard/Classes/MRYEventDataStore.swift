//
//  MRYEventDataStore.swift
//  Moriyama
//
//  Created by Ichiro on 2016/01/07.
//  Copyright © 2016年 Ichiro. All rights reserved.
//

import UIKit
import EventKit

class MRYEventDataStore {
    let store = EKEventStore()
    static let this = MRYEventDataStore()
    private init(){
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
    class var instance : MRYEventDataStore{
        get{ return this }
    }

    func conflictedEventsWith( event: MRYEvent) -> [MRYEvent]{
        let startDate = event.startDate.dateByAddingTimeInterval(1)
        let endDate = event.endDate.dateByAddingTimeInterval(-1)
        let predicate = store.predicateForEventsWithStartDate(startDate, endDate:endDate, calendars: nil)
        return store.eventsMatchingPredicate(predicate).map{ MRYEvent( event: $0) }
    }

    func eventWithDate(date: NSDate) -> [MRYEvent]{
        let startDate = date
        let endDate = startDate.dateByAddingTimeInterval(86400) // 当日
        let predicate = store.predicateForEventsWithStartDate(startDate, endDate: endDate, calendars: nil)
        let events = store.eventsMatchingPredicate(predicate)
        let _events = events.map{ MRYEvent( event: $0) }
        return _events.sort({ x , y in
            return x.startDate.compare(y.startDate) == NSComparisonResult.OrderedAscending
        })
    }


}
