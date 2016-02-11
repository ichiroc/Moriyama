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
    var eventIdentifier : String{
        get {return _event.eventIdentifier }
    }
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
        
        // Start date
        var startData = TextData(title: "Start date", data: [])
        startData.data = subTextsWithDate(_event.startDate)
        var endData = TextData(title: "End date", data: [])
        endData.data = subTextsWithDate(_event.endDate)
        
        datasource.append(basicData)
        datasource.append(startData)
        datasource.append(endData)
    }
    
    private func subTextsWithDate(date: NSDate) -> [SubText]{
        var subTexts : [SubText] = []
        subTexts.append(SubText(title: "Start date time", text: Util.string(date, format: "MMMdEHHmm")))
        subTexts.append(SubText(title: "Start date time", text: Util.string(date, format: "MMMdEhm")))
        subTexts.append(SubText(title: "", text: Util.string(date, format: "MMMd")))
        subTexts.append(SubText(title: "Day of week (short)", text: "(\(Util.string(date, format: "E")))"))
        subTexts.append(SubText(title: "Day of week (long)", text: Util.string(date, format: "EEEE")))
        if self.allDay{
            subTexts.append(SubText(title: "", text: "all day"))
        }
        subTexts.append(SubText(title: "Time", text: Util.string(date, format: "HHmm")))
        subTexts.append(SubText(title: "Hours(12H)", text: Util.string(date, format: "h")))
        subTexts.append(SubText(title: "Hours(24H)", text: Util.string(date, format: "H")))
        subTexts.append(SubText(title: "Minutes", text: Util.string(date, format: "m")))
        subTexts.append(SubText(title: "Month", text: Util.string(date, format: "M")))
        subTexts.append(SubText(title: "Day", text: Util.string(date, format: "d")))
        subTexts.append(SubText(title: "Year", text: Util.string(date, format: "Y")))
        return subTexts
    }
    
    func conflicts( other: MRYEvent ) -> Bool{
       return !(self.endDate.compare(other.startDate) != NSComparisonResult.OrderedDescending ||
        self.startDate.compare(other.endDate)  != NSComparisonResult.OrderedAscending )
    }
}
