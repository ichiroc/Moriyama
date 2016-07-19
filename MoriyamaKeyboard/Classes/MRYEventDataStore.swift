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
    let rawStore = EKEventStore()
    static var this = MRYEventDataStore()
    private var accessGranted = false
    var defaultCalendar : EKCalendar {
        get{
            return rawStore.defaultCalendarForNewEvents
        }
    }
    var events : [MRYEvent] = []
    override private init(){
        super.init()
        if EKEventStore.authorizationStatusForEntityType(.Event) != EKAuthorizationStatus.Authorized {
            // Not authorized. So request the permition.
            rawStore.requestAccessToEntityType(.Event,
                completion: {(granted: Bool, error: NSError?) -> Void in
                    if granted{
                        self.accessGranted = true
                        self.loadAllEvents()
                    }
            })
        }else{
            accessGranted = true
            self.loadAllEvents()
        }
    }
    class var sharedStore : MRYEventDataStore{
        get{ return this }
    }
    
    func loadAllEvents() {
        if accessGranted {
            // 本日の曜日により最大3週間前のデータが必要になる
            let startDate = NSDate().dateByAddingTimeInterval(-86400 * 21)
            let endDate = startDate.dateByAddingTimeInterval(86400 * 140)
            let predicate = rawStore.predicateForEventsWithStartDate(startDate, endDate: endDate, calendars: nil)
            let events = rawStore.eventsMatchingPredicate(predicate)
            let _events = events.map{ MRYEvent( event: $0) }
            self.events = _events.sort({ x , y in
                return x.startDate.compare(y.startDate) == NSComparisonResult.OrderedAscending
            })
        }
    }
    
    
    func eventsOnDate(date: NSDate) -> [MRYEvent]{
        let startDate = date.dateByAddingTimeInterval(-1)
        let endDate = startDate.dateByAddingTimeInterval(86401)
        
        return events.filter({
            return (startDate.compare($0.startDate) == .OrderedAscending && endDate.compare($0.startDate) == .OrderedDescending) ||
            (startDate.compare($0.endDate) == .OrderedAscending && endDate.compare($0.endDate) == .OrderedDescending) ||
            ($0.startDate.compare(startDate) == .OrderedAscending && $0.endDate.compare(endDate) == .OrderedDescending)
        })
    }

    
    func events(date :NSDate, includeAllDay : Bool) -> [MRYEvent]{
        let events = self.eventsOnDate(date)
        if( !includeAllDay ){
            return events.filter({ return !$0.allDay })
        }
        return events
    }
    
    func notAllDayEvents(date : NSDate) -> [MRYEvent]{
        return self.eventsOnDate(date).filter({ return !$0.allDay })
    }

    func allDayEvents(date: NSDate) -> [MRYEvent]{
        let events = self.eventsOnDate(date)
        return events.filter{ return $0.allDay }
    }

}
