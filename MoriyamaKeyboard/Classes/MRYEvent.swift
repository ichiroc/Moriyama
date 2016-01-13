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
    var data: [(String,String)] = []
    
    func componentsOnEndDate( unitFlags: NSCalendarUnit = [.Year, .Month, .Day, .Weekday , .Hour, .Minute, .Second]) -> NSDateComponents{
        return cal.components(unitFlags, fromDate: endDate )
    }
    
    func componentsOnStartDate( unitFlags: NSCalendarUnit = [.Year, .Month, .Day, .Weekday , .Hour, .Minute, .Second]) -> NSDateComponents{
        return cal.components(unitFlags, fromDate: startDate )
    }
    
    
    init( event: EKEvent){
        _event = event
        super.init()
        data.append((_event.title,"タイトル"))
        if let location = _event.location{
            if location != ""{
                data.append((location,"場所"))
            }
        }
        if let notes = _event.notes {
            data.append((notes,"メモ"))
        }
        if let url = _event.URL{
            data.append((url.absoluteString,"URL"))
        }
        data.append((Util.string(_event.startDate, format: "MMMdEHHmm"),"開始"))
        data.append((Util.string(_event.endDate, format: "MMMdEHHmm"),"終了"))
        data.append((Util.string(_event.startDate, format: "HHmm"),"開始"))
        data.append((Util.string(_event.endDate, format: "HHmm"),"終了"))
        data.append((Util.string(_event.startDate, format: "dHHmm"),"開始"))
        data.append((Util.string(_event.endDate, format: "dHHmm"),"終了"))
        data.append((Util.string(_event.startDate, format: "d"),"開始"))
        data.append((Util.string(_event.endDate, format: "d"),"終了"))
        data.append((Util.string(_event.startDate, format: "MMM"),"開始"))
        data.append((Util.string(_event.endDate, format: "MMM"),"終了"))
        data.append((Util.string(_event.startDate, format: "YYYY"),"開始"))
        data.append((Util.string(_event.endDate, format: "YYYY"),"終了"))
    }
    
    func conflicts( other: MRYEvent ) -> Bool{
       return !(self.endDate.compare(other.startDate) != NSComparisonResult.OrderedDescending ||
        self.startDate.compare(other.endDate)  != NSComparisonResult.OrderedAscending )
    }
}
