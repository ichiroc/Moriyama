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
    var allDay: Bool{
        get { return _event.allDay }
    }
    struct TextInfo {
        var title : String
        var data: [String]
    }
    var datasource : [TextInfo] = []
    
    
    func componentsOnEndDate( unitFlags: NSCalendarUnit = [.Year, .Month, .Day, .Weekday , .Hour, .Minute, .Second]) -> NSDateComponents{
        return cal.components(unitFlags, fromDate: endDate )
    }
    
    func componentsOnStartDate( unitFlags: NSCalendarUnit = [.Year, .Month, .Day, .Weekday , .Hour, .Minute, .Second]) -> NSDateComponents{
        return cal.components(unitFlags, fromDate: startDate )
    }
    
    
    init( event: EKEvent){
        _event = event
        super.init()
       
        var basicInfo = TextInfo(title: "Basic", data: [])
        basicInfo.data.append(_event.title)
        if let location = _event.location{
            if location != ""{
                basicInfo.data.append(location)
            }
        }
        if let notes = _event.notes {
            basicInfo.data.append(notes)
        }
        if let url = _event.URL{
            basicInfo.data.append(url.absoluteString)
        }
        
        var startDateInfo = TextInfo(title: "Start date", data: [])
        startDateInfo.data.append(Util.string(_event.startDate, format: "MMMdEHHmm"))
        startDateInfo.data.append(Util.string(_event.startDate, format: "HHmm"))
        startDateInfo.data.append(Util.string(_event.startDate, format: "m"))
        startDateInfo.data.append(Util.string(_event.startDate, format: "H"))
        startDateInfo.data.append(Util.string(_event.startDate, format: "d"))
        startDateInfo.data.append(Util.string(_event.startDate, format: "M"))
        startDateInfo.data.append(Util.string(_event.startDate, format: "Y"))
        
        var endDateInfo = TextInfo(title: "End date", data: [])
        endDateInfo.data.append(Util.string(_event.endDate, format: "MMMdEHHmm"))
        endDateInfo.data.append(Util.string(_event.endDate, format: "HHmm"))
        endDateInfo.data.append(Util.string(_event.endDate, format: "m"))
        endDateInfo.data.append(Util.string(_event.endDate, format: "H"))
        endDateInfo.data.append(Util.string(_event.endDate, format: "d"))
        endDateInfo.data.append(Util.string(_event.endDate, format: "M"))
        endDateInfo.data.append(Util.string(_event.endDate, format: "Y"))
        
        datasource.append(basicInfo)
        datasource.append(startDateInfo)
        datasource.append(endDateInfo)
        
    }
    
    func conflicts( other: MRYEvent ) -> Bool{
       return !(self.endDate.compare(other.startDate) != NSComparisonResult.OrderedDescending ||
        self.startDate.compare(other.endDate)  != NSComparisonResult.OrderedAscending )
    }
}
