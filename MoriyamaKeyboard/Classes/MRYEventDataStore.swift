//
//  MRYEventDataStore.swift
//  Moriyama
//
//  Created by Ichiro on 2016/01/07.
//  Copyright © 2016年 Ichiro. All rights reserved.
//

import UIKit
import EventKit

class MRYEventDataStore : NSObject{
    let store = EKEventStore()
    static var this = MRYEventDataStore()
    var granted = false
    var events : [MRYEvent] = []
    override private init(){
        super.init()
        if EKEventStore.authorizationStatusForEntityType(.Event) != EKAuthorizationStatus.Authorized {
            // 許可されてないので許可を要求
            store.requestAccessToEntityType(.Event,
                completion: {(granted: Bool, error: NSError?) -> Void in
                    if granted{
                        self.granted = true
                        self.loadAllEvents()
                    }
            })
        }else{
            granted = true
            self.loadAllEvents()
        }
    }
    class var instance : MRYEventDataStore{
        get{ return this }
    }
    
    func loadAllEvents() {
        if granted {
            let startDate = NSDate().dateByAddingTimeInterval(-86400 * 30)
            let endDate = startDate.dateByAddingTimeInterval(86400 * 90)
            let predicate = store.predicateForEventsWithStartDate(startDate, endDate: endDate, calendars: nil)
            let events = store.eventsMatchingPredicate(predicate)
            let _events = events.map{ MRYEvent( event: $0) }
            self.events = _events.sort({ x , y in
                return x.startDate.compare(y.startDate) == NSComparisonResult.OrderedAscending
            })
        }
    }
    
    /**
     Return conflicted events exclude all day events.
     */
    func conflictedEventsWith( event: MRYEvent) -> [MRYEvent]{
        if granted {
            let startDate = event.startDate.dateByAddingTimeInterval(1)
            let endDate = event.endDate.dateByAddingTimeInterval(-1)
            let predicate = store.predicateForEventsWithStartDate(startDate, endDate:endDate, calendars: nil)
            let events = store.eventsMatchingPredicate(predicate).map{ MRYEvent( event: $0) }
            return events.filter{ return !$0.allDay }
        }
        return []
    }
    
    func bunchOfConflictedEventsWith(event: MRYEvent) -> [MRYEvent] {
        var allEvents = self.conflictedEventsWith(event)
        allEvents.forEach({
            let _events = self.conflictedEventsWith($0)
            let _eventsNotContained = _events.filter({ e in
                !allEvents.map{ $0.eventIdentifier }.contains( e.eventIdentifier )
            })
            allEvents.appendContentsOf(_eventsNotContained)
        })
        return allEvents
    }
    
    func eventsWithDate(date: NSDate) -> [MRYEvent]{
        let startDate = date.dateByAddingTimeInterval(-1)
        let endDate = startDate.dateByAddingTimeInterval(86401)
        return events.filter({
            return (startDate.compare($0.startDate) == .OrderedAscending && endDate.compare($0.startDate) == .OrderedDescending) ||
            (startDate.compare($0.endDate) == .OrderedAscending && endDate.compare($0.endDate) == .OrderedDescending)
        })
    }

//    func eventWithDate(date: NSDate) -> [MRYEvent]{
//        let startDate = date
//        let endDate = startDate.dateByAddingTimeInterval(86400) // 当日
//        let predicate = store.predicateForEventsWithStartDate(startDate, endDate: endDate, calendars: nil)
//        let events = store.eventsMatchingPredicate(predicate)
//        let _events = events.map{ MRYEvent( event: $0) }
//        return _events.sort({ x , y in
//            return x.startDate.compare(y.startDate) == NSComparisonResult.OrderedAscending
//        })
//    }
    
    func events(date :NSDate, includeAllDay : Bool) -> [MRYEvent]{
        let events = self.eventsWithDate(date)
        if( !includeAllDay ){
            return events.filter({ return !$0.allDay })
        }
        return events
    }
    
    func notAllDayEvents(date : NSDate) -> [MRYEvent]{
        return self.eventsWithDate(date).filter({ return !$0.allDay })
    }

    func allDayEvents(date: NSDate) -> [MRYEvent]{
        let events = self.eventsWithDate(date)
        return events.filter{ return $0.allDay }
    }

}
