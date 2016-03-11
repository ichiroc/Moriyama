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
        let factory = MRYEventContentFactory(event: self)
        datasource = factory.eventContentDatasource([.General,.StartDate, .EndDate])
    }
    
}
