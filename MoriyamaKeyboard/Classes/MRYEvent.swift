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
    struct TextData {
        var title : String
        var data: [SubText]
    }
    struct SubText {
        var title: String
        var text : String
    }
    var datasource : [TextData] = []
//    var datasource : [TextInfo] = []
    
    
    func componentsOnEndDate( unitFlags: NSCalendarUnit = [.Year, .Month, .Day, .Weekday , .Hour, .Minute, .Second]) -> NSDateComponents{
        return cal.components(unitFlags, fromDate: endDate )
    }
    
    func componentsOnStartDate( unitFlags: NSCalendarUnit = [.Year, .Month, .Day, .Weekday , .Hour, .Minute, .Second]) -> NSDateComponents{
        return cal.components(unitFlags, fromDate: startDate )
    }
    
    
    init( event: EKEvent){
        _event = event
        super.init()
       
        var basicData = TextData(title: "Basic", data: [])
        basicData.data.append(SubText( title: "Title", text: _event.title))
        if let location = _event.location{
            if location != ""{
                basicData.data.append(SubText( title: "Location", text: location))
            }
        }
        if let notes = _event.notes {
            basicData.data.append(SubText( title: "Notes", text: notes))
        }
        if let url = _event.URL{
            basicData.data.append(SubText( title: "URL", text: url.absoluteString))
        }
        
        var startData = TextData(title: "Start date", data: [])
        
        startData.data.append(SubText(title: "", text: Util.string(_event.startDate, format: "MMMdEHHmm")))
        startData.data.append(SubText(title: "", text: Util.string(_event.startDate, format: "HHmm")))
        startData.data.append(SubText(title: "Minutes", text: Util.string(_event.startDate, format: "m")))
        startData.data.append(SubText(title: "Hours", text: Util.string(_event.startDate, format: "H")))
        startData.data.append(SubText(title: "Day", text: Util.string(_event.startDate, format: "d")))
        startData.data.append(SubText(title: "Month", text: Util.string(_event.startDate, format: "M")))
        startData.data.append(SubText(title: "Year", text: Util.string(_event.startDate, format: "Y")))
        
        var endData = TextData(title: "End date", data: [])
        endData.data.append(SubText(title: "", text: Util.string(self._event.endDate, format: "MMMdEHHmm")))
        endData.data.append(SubText(title: "", text: Util.string(_event.endDate, format: "HHmm")))
        endData.data.append(SubText(title: "Minutes", text: Util.string(_event.endDate, format: "m")))
        endData.data.append(SubText(title: "Hours", text: Util.string(_event.endDate, format: "H")))
        endData.data.append(SubText(title: "Day", text: Util.string(_event.endDate, format: "d")))
        endData.data.append(SubText(title: "Month", text: Util.string(_event.endDate, format: "M")))
        endData.data.append(SubText(title: "Year", text: Util.string(_event.endDate, format: "Y")))
        
        datasource.append(basicData)
        datasource.append(startData)
        datasource.append(endData)
    }
    
    func conflicts( other: MRYEvent ) -> Bool{
       return !(self.endDate.compare(other.startDate) != NSComparisonResult.OrderedDescending ||
        self.startDate.compare(other.endDate)  != NSComparisonResult.OrderedAscending )
    }
}
