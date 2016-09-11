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
    static var this = MRYEventDataStore()
    let rawStore = EKEventStore()
    var defaultCalendar : EKCalendar {
        get{
            return rawStore.defaultCalendarForNewEvents
        }
    }
    
    fileprivate var events : [MRYEvent] = []
    fileprivate var accessGranted = false

    
    override fileprivate init(){
        super.init()
        if EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized {
            // Not authorized. So request the permition.
            rawStore.requestAccess(to: .event,
                completion: {(granted: Bool, error: NSError?) -> Void in
                    if granted{
                        self.accessGranted = true
                        self.loadAllEvents()
                    }
            } as! EKEventStoreRequestAccessCompletionHandler)
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
            let startDate = Date().addingTimeInterval(-86400 * 21)
            let endDate = startDate.addingTimeInterval(86400 * 140)
            let predicate = rawStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
            let events = rawStore.events(matching: predicate)
            let _events = events.map{ MRYEvent( event: $0) }
            self.events = _events.sorted(by: { x , y in
                return x.startDate.compare(y.startDate as Date) == ComparisonResult.orderedAscending
            })
        }
    }
    
    
    func eventsOnDate(_ date: Date) -> [MRYEvent]{
        let startDate = date.addingTimeInterval(-1)
        let endDate = startDate.addingTimeInterval(86401)
        
        return events.filter({
            return (startDate.compare($0.startDate as Date) == .orderedAscending && endDate.compare($0.startDate as Date) == .orderedDescending) ||
            (startDate.compare($0.endDate as Date) == .orderedAscending && endDate.compare($0.endDate as Date) == .orderedDescending) ||
            ($0.startDate.compare(startDate) == .orderedAscending && $0.endDate.compare(endDate) == .orderedDescending)
        })
    }

    
    func events(_ date :Date, includeAllDay : Bool) -> [MRYEvent]{
        let events = self.eventsOnDate(date)
        if( !includeAllDay ){
            return events.filter({ return !$0.allDay })
        }
        return events
    }
    
    func notAllDayEvents(_ date : Date) -> [MRYEvent]{
        return self.eventsOnDate(date).filter({ return !$0.allDay })
    }

    func allDayEvents(_ date: Date) -> [MRYEvent]{
        let events = self.eventsOnDate(date)
        return events.filter{ return $0.allDay }
    }

}
