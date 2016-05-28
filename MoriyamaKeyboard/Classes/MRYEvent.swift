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
    
    var _datasource : [MRYEventContentGroup]?
    var datasource : [MRYEventContentGroup] {
        get {
            if _datasource == nil{
                _datasource = defaultDataSource()
            }
            return _datasource!
        }
        set{
            _datasource = newValue
        }
    }
    
    
    func componentsOnEndDate( unitFlags: NSCalendarUnit = [.Year, .Month, .Day, .Weekday , .Hour, .Minute, .Second]) -> NSDateComponents{
        return cal.components(unitFlags, fromDate: endDate )
    }
    
    func componentsOnStartDate( unitFlags: NSCalendarUnit = [.Year, .Month, .Day, .Weekday , .Hour, .Minute, .Second]) -> NSDateComponents{
        return cal.components(unitFlags, fromDate: startDate )
    }
    
    
    init( event: EKEvent){
        _event = event
        super.init()
    }
    
    func defaultDataSource() -> [MRYEventContentGroup]{
        datasource = []
        let factory = MRYEventContentFactory(event: self)
        return factory.eventContentDatasource([.General,.StartDate, .EndDate])
    }
    
    func endDateGroupWithMinutesInterval( minutes : Int ) -> MRYEventContentGroup{
        let contentFactory = MRYEventContentFactory(event: self)
        var endDateGroup = MRYEventContentGroup(description:
            NSLocalizedString("End date" , comment:"") + "( \(minutes) " +
                NSLocalizedString("minutes", comment: "") + " )", eventContents: [])
        let endDate = self.startDate.dateByAddingTimeInterval(Double(60 * minutes ))
        endDateGroup.eventContents = contentFactory.eventContentsAtDateTime(endDate)
        let startAndEnd = "\(Util.string(self.startDate, format: "HH:mm")) - \(Util.string(endDate, format: "HH:mm"))"
        let title = NSLocalizedString("Create with this time", comment: "")
        let description = NSLocalizedString("Create a event with this time in ApptBoard app. You can back to current app manually.", comment: "")
        var createContent = MRYEventContent(description: description , content: "📝 \(title) (\(startAndEnd))" )
        
        createContent.openEvent = { ( vc: UIViewController) -> Void in
            contentFactory.openEvent(vc,startDate: self.startDate, endDate: endDate)
        }
        endDateGroup.eventContents.append(createContent)
        return endDateGroup
    }
}
