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
        set{ _event.startDate = newValue }
    }
    var endDate : NSDate  {
        get{ return _event.endDate }
        set{ _event.endDate = newValue }
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
        updateDataSource()
    }
    
    func updateDataSource(){
        datasource = []
        var generalData = TextData(title: NSLocalizedString("General", comment : "General informations of event."), data: [])
        generalData.data.append(SubText( title: NSLocalizedString("Title",comment: "Event title"), text: _event.title))
        if let location = _event.location{
            if location != ""{
                generalData.data.append(SubText( title: NSLocalizedString("Location",comment:"Location of event occured."), text: location))
            }
        }
        if let notes = _event.notes {
            generalData.data.append(SubText( title: NSLocalizedString("Notes", comment : "Event notes"), text: notes))
        }
        if let url = _event.URL{
            generalData.data.append(SubText( title: NSLocalizedString("URL", comment: "URL"), text: url.absoluteString))
        }
        
        // Start date
        var startData = TextData(title: NSLocalizedString( "Start date", comment: "Start date of event."), data: [])
        startData.data = subTextsWithDate(_event.startDate)
        var endData = TextData(title:  NSLocalizedString("End date",comment: "End date of event."), data: [])
        endData.data = subTextsWithDate(_event.endDate)
        
        datasource.append(generalData)
        datasource.append(startData)
        datasource.append(endData)
        
    }
    
    private func subTextsWithDate(date: NSDate) -> [SubText]{
        var subTexts : [SubText] = []
        subTexts.append(SubText(title: NSLocalizedString("Date time" , comment: ""), text: Util.string(date, format: "MMMdEHHmm")))
        subTexts.append(SubText(title: NSLocalizedString("Date time", comment: ""), text: Util.string(date, format: "MMMdEhm")))
        subTexts.append(SubText(title: NSLocalizedString("Date time",comment: ""), text: Util.string(date, format: "MMMd")))
        subTexts.append(SubText(title: NSLocalizedString("Day of week (short)", comment: ""), text: "(\(Util.string(date, format: "E")))"))
        subTexts.append(SubText(title: NSLocalizedString("Day of week (long)", comment: ""), text: Util.string(date, format: "EEEE")))
        if self.allDay{
            subTexts.append(SubText(title: "", text: NSLocalizedString("all day", comment: "")))
        }
        subTexts.append(SubText(title: NSLocalizedString("Time", comment: ""), text: Util.string(date, format: "HHmm")))
        subTexts.append(SubText(title: NSLocalizedString("Hours(12H)", comment: ""), text: Util.string(date, format: "h")))
        subTexts.append(SubText(title: NSLocalizedString("Hours(24H)", comment: ""), text: Util.string(date, format: "H")))
        subTexts.append(SubText(title: NSLocalizedString("Minutes", comment: ""), text: Util.string(date, format: "m")))
        subTexts.append(SubText(title: NSLocalizedString("Month", comment: ""), text: Util.string(date, format: "M")))
        subTexts.append(SubText(title: NSLocalizedString("Day", comment: ""), text: Util.string(date, format: "d")))
        subTexts.append(SubText(title: NSLocalizedString("Year", comment: ""), text: Util.string(date, format: "Y")))
        return subTexts
    }
    
    func conflicts( other: MRYEvent ) -> Bool{
       return !(self.endDate.compare(other.startDate) != NSComparisonResult.OrderedDescending ||
        self.startDate.compare(other.endDate)  != NSComparisonResult.OrderedAscending )
    }
}
