//
//  MRYEvent.swift
//  Moriyama
//
//  Created by Ichiro on 2016/01/10.
//  Copyright © 2016年 Ichiro. All rights reserved.
//

import UIKit
import EventKit

class MRYEvent: NSObject {
    private let _event : EKEvent
    private let cal = NSCalendar.currentCalendar()
    var calendar : EKCalendar  {
        get{ return _event.calendar }
    }
    var startDate : NSDate  {
        get{ return _event.startDate }
    }
    var endDate : NSDate  {
        get{ return _event.endDate }
    }
    var title : String  {
        get{ return _event.title }
    }
    var duration : NSTimeInterval {
        get {
            return endDate.timeIntervalSinceDate(startDate)
        }
    }
    var data: [String] = []
    
    func componentsOnEndDate( unitFlags: NSCalendarUnit = [.Year, .Month, .Day, .Weekday , .Hour, .Minute, .Second]) -> NSDateComponents{
        return cal.components(unitFlags, fromDate: endDate )
    }
    
    func componentsOnStartDate( unitFlags: NSCalendarUnit = [.Year, .Month, .Day, .Weekday , .Hour, .Minute, .Second]) -> NSDateComponents{
        return cal.components(unitFlags, fromDate: startDate )
    }
    
    
    init( event: EKEvent){
        _event = event
        data.append(_event.title)
        data.append(_event.startDate.description)
        data.append(_event.endDate.description)
    }
    
    func conflicts( other: MRYEvent ) -> Bool{
       return !(self.endDate.compare(other.startDate) != NSComparisonResult.OrderedDescending ||
        self.startDate.compare(other.endDate)  != NSComparisonResult.OrderedAscending )
    }
}
