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
    var location : String?{
        get { return _event.location }
    }
    var notes: String?{
        get {return _event.notes }
    }
    var URL :NSURL?{
        get {return _event.URL}
    }
    var allDay: Bool{
        get { return _event.allDay }
    }
//    struct MRYEventContentGroup {
//        var title : String
//        var data: [MRYEventContent]
//    }
//    struct MRYEventContent {
//        var description: String
//        var text : String
//    }
    var datasource : [MRYEventContentGroup] = []
    
    
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
        var generalData = MRYEventContentGroup(description: NSLocalizedString("General", comment : "General informations of event."), eventContents: [])
        generalData.eventContents.append(MRYEventContent( description: NSLocalizedString("Title",comment: "Event title"), Content: _event.title))
        if let location = _event.location{
            if location != ""{
                generalData.eventContents.append(MRYEventContent( description: NSLocalizedString("Location",comment:"Location of event occured."), Content: location))
            }
        }
        if let notes = _event.notes {
            generalData.eventContents.append(MRYEventContent( description: NSLocalizedString("Notes", comment : "Event notes"), Content: notes))
        }
        if let url = _event.URL{
            generalData.eventContents.append(MRYEventContent( description: NSLocalizedString("URL", comment: "URL"), Content: url.absoluteString))
        }
        
        // Start date
        var startData = MRYEventContentGroup(description: NSLocalizedString( "Start date", comment: "Start date of event."), eventContents: [])
        startData.eventContents = subTextsWithDate(_event.startDate)
        var endData = MRYEventContentGroup(description:  NSLocalizedString("End date",comment: "End date of event."), eventContents: [])
        endData.eventContents = subTextsWithDate(_event.endDate)
        
        datasource.append(generalData)
        datasource.append(startData)
        datasource.append(endData)
        
    }
    
    private func subTextsWithDate(date: NSDate) -> [MRYEventContent]{
        var subTexts : [MRYEventContent] = []
        subTexts.append(MRYEventContent(description: NSLocalizedString("Date time" , comment: ""), Content: Util.string(date, format: "MMMdEHHmm")))
        subTexts.append(MRYEventContent(description: NSLocalizedString("Date time", comment: ""), Content: Util.string(date, format: "MMMdEhm")))
        subTexts.append(MRYEventContent(description: NSLocalizedString("Date time",comment: ""), Content: Util.string(date, format: "MMMd")))
        subTexts.append(MRYEventContent(description: NSLocalizedString("Day of week (short)", comment: ""), Content: "(\(Util.string(date, format: "E")))"))
        subTexts.append(MRYEventContent(description: NSLocalizedString("Day of week (long)", comment: ""), Content: Util.string(date, format: "EEEE")))
        if self.allDay{
            subTexts.append(MRYEventContent(description: "", Content: NSLocalizedString("all day", comment: "")))
        }
        subTexts.append(MRYEventContent(description: NSLocalizedString("Time", comment: ""), Content: Util.string(date, format: "HHmm")))
        subTexts.append(MRYEventContent(description: NSLocalizedString("Hours(12H)", comment: ""), Content: Util.string(date, format: "h")))
        subTexts.append(MRYEventContent(description: NSLocalizedString("Hours(24H)", comment: ""), Content: Util.string(date, format: "H")))
        subTexts.append(MRYEventContent(description: NSLocalizedString("Minutes", comment: ""), Content: Util.string(date, format: "m")))
        subTexts.append(MRYEventContent(description: NSLocalizedString("Month", comment: ""), Content: Util.string(date, format: "M")))
        subTexts.append(MRYEventContent(description: NSLocalizedString("Day", comment: ""), Content: Util.string(date, format: "d")))
        subTexts.append(MRYEventContent(description: NSLocalizedString("Year", comment: ""), Content: Util.string(date, format: "Y")))
        return subTexts
    }
    
    func conflicts( other: MRYEvent ) -> Bool{
       return !(self.endDate.compare(other.startDate) != NSComparisonResult.OrderedDescending ||
        self.startDate.compare(other.endDate)  != NSComparisonResult.OrderedAscending )
    }
}
