//
//  MRYContentData.swift
//  Moriyama
//
//  Created by Ichiro on 2016/03/07.
//  Copyright © 2016年 Ichiro. All rights reserved.
//

import UIKit

class MRYEventContentFactory {
    enum ContentType{
        case General
        case StartDate
        case EndDate
    }
    
    let event : MRYEvent
    init(event e: MRYEvent){
        event = e
    }
   
    func eventContentDatasource( types : [ContentType]) -> [MRYEventContentGroup]{
        var datasource : [MRYEventContentGroup] = []
        types.forEach{
            switch $0{
            case .General:
                datasource.append(generalContentGroup())
            case .StartDate:
                datasource.append(startDateContentGroup())
            case .EndDate:
                datasource.append(endDateContentGroup())
            }
        }
        return datasource
    }
    
    private func generalContentGroup() -> MRYEventContentGroup{
        var generalGroup = MRYEventContentGroup(description: NSLocalizedString("General", comment : "General informations of event."), eventContents: [])
        generalGroup.eventContents.append(MRYEventContent( description: NSLocalizedString("Title",comment: "Event title"), content: event.title))
        if let location = event.location{
            if location != ""{
                generalGroup.eventContents.append(MRYEventContent( description: NSLocalizedString("Location",comment:"Location of event occured."), content: location))
            }
        }
        if let notes = event.notes {
            generalGroup.eventContents.append(MRYEventContent( description: NSLocalizedString("Notes", comment : "Event notes"), content: notes))
        }
        if let url = event.URL{
            if url.description != ""{
                generalGroup.eventContents.append(MRYEventContent( description: NSLocalizedString("URL", comment: "URL"), content: url.absoluteString))
            }
        }

        if event.calendar.allowsContentModifications {
            var openEventRow = MRYEventContent(description: "Edit this event in ApptBoard app. You can back manually.", content: "[Edit]")
            let url = NSURL(string: "moriyama-board://?eventId=\(self.event.eventIdentifier)")
            openEventRow.openEvent = { (vc :UIViewController) -> Void in
                var responder: UIResponder = vc
                while responder.nextResponder() != nil {
                    responder = responder.nextResponder()!
                    if responder.respondsToSelector("openURL:") == true {
                        responder.performSelector("openURL:", withObject: url!)
                    }
                }
            }
            generalGroup.eventContents.append(openEventRow)
        }
        return generalGroup
    }
    private func startDateContentGroup() -> MRYEventContentGroup{
        var startDateGroup = MRYEventContentGroup(description: NSLocalizedString( "Start date", comment: "Start date of event."), eventContents: [])
        startDateGroup.eventContents = eventContentsAtDateTime(event.startDate)
        return startDateGroup
    }
    
    private func endDateContentGroup() -> MRYEventContentGroup{
        var endDateGroup = MRYEventContentGroup(description:  NSLocalizedString("End date",comment: "End date of event."), eventContents: [])
        endDateGroup.eventContents = eventContentsAtDateTime(event.endDate)
        return endDateGroup
    }
    
    
    func eventContentsAtDateTime(date: NSDate) -> [MRYEventContent]{
        var eventContents : [MRYEventContent] = []
        eventContents.append(MRYEventContent(description: NSLocalizedString("Date time" , comment: ""), content: Util.string(date, format: "MMMdEHHmm")))
        eventContents.append(MRYEventContent(description: NSLocalizedString("Date time",comment: ""), content: Util.string(date, format: "MMMd")))
        eventContents.append(MRYEventContent(description: NSLocalizedString("Day of week (long)", comment: ""), content: Util.string(date, format: "EEEE")))
        if event.allDay{
            eventContents.append(MRYEventContent(description: "", content: NSLocalizedString("all day", comment: "")))
        }
        eventContents.append(MRYEventContent(description: NSLocalizedString("Time", comment: ""), content: Util.string(date, format: "HHmm")))
        return eventContents
    }
}
