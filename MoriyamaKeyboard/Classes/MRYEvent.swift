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
    var eventIdentifier : String{
        get {return _event.eventIdentifier }
    }
    var calendar : EKCalendar  {
        get{ return _event.calendar }
    }
    var startDate : Date  {
        get{ return _event.startDate }
        set{ _event.startDate = newValue }
    }
    var endDate : Date  {
        get{ return _event.endDate }
        set{ _event.endDate = newValue }
    }
    var title : String  {
        get{ return _event.title }
    }
    var duration : TimeInterval {
        get {
            return endDate.timeIntervalSince(startDate)
        }
    }
    var location : String?{
        get { return _event.location }
    }
    var notes: String?{
        get {return _event.notes }
    }
    var URL :Foundation.URL?{
        get {return _event.url}
    }
    var allDay: Bool{
        get { return _event.isAllDay }
    }
    
    lazy var datasource : [MRYEventContentGroup] =  { [unowned self] in
        self.defaultDataSource()
    }()
    
    fileprivate let _event : EKEvent
    fileprivate let cal = Calendar.current
    
    
    func componentsOnEndDate( _ unitFlags: NSCalendar.Unit = [.year, .month, .day, .weekday , .hour, .minute, .second]) -> DateComponents{
        return (cal as NSCalendar).components(unitFlags, from: endDate )
    }
    
    func componentsOnStartDate( _ unitFlags: NSCalendar.Unit = [.year, .month, .day, .weekday , .hour, .minute, .second]) -> DateComponents{
        return (cal as NSCalendar).components(unitFlags, from: startDate )
    }
    
    
    init( event: EKEvent){
        _event = event
        super.init()
    }
    
    func endDateGroupWithMinutesInterval( _ minutes : Int ) -> MRYEventContentGroup{
        let contentFactory = MRYEventContentFactory(event: self)
        var endDateGroup = MRYEventContentGroup(description:
            NSLocalizedString("End date" , comment:"") + "( \(minutes) " +
                NSLocalizedString("minutes", comment: "") + " )", eventContents: [])
        let endDate = self.startDate.addingTimeInterval(Double(60 * minutes ))
        endDateGroup.eventContents = contentFactory.eventContentsAtDateTime(endDate)

        return endDateGroup
    }
    
    fileprivate func defaultDataSource() -> [MRYEventContentGroup]{
        self.datasource = [] // refresh
        let factory = MRYEventContentFactory(event: self)
        return factory.eventContentDatasource([.general,.startDate, .endDate])
    }
}
