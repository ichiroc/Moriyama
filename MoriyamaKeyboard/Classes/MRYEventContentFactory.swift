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
        generalGroup.eventContents.append(MRYEventContent( description: NSLocalizedString("Title",comment: "Event title"), Content: event.title))
        if let location = event.location{
            if location != ""{
                generalGroup.eventContents.append(MRYEventContent( description: NSLocalizedString("Location",comment:"Location of event occured."), Content: location))
            }
        }
        if let notes = event.notes {
            generalGroup.eventContents.append(MRYEventContent( description: NSLocalizedString("Notes", comment : "Event notes"), Content: notes))
        }
        if let url = event.URL{
            if url.description != ""{
                print(url)
                generalGroup.eventContents.append(MRYEventContent( description: NSLocalizedString("URL", comment: "URL"), Content: url.absoluteString))
            }
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
        eventContents.append(MRYEventContent(description: NSLocalizedString("Date time" , comment: ""), Content: Util.string(date, format: "MMMdEHHmm")))
//        eventContents.append(MRYEventContent(description: NSLocalizedString("Date time", comment: ""), Content: Util.string(date, format: "MMMdEhm")))
        eventContents.append(MRYEventContent(description: NSLocalizedString("Date time",comment: ""), Content: Util.string(date, format: "MMMd")))
//        eventContents.append(MRYEventContent(description: NSLocalizedString("Day of week (short)", comment: ""), Content: "(\(Util.string(date, format: "E")))"))
        eventContents.append(MRYEventContent(description: NSLocalizedString("Day of week (long)", comment: ""), Content: Util.string(date, format: "EEEE")))
        if event.allDay{
            eventContents.append(MRYEventContent(description: "", Content: NSLocalizedString("all day", comment: "")))
        }
        eventContents.append(MRYEventContent(description: NSLocalizedString("Time", comment: ""), Content: Util.string(date, format: "HHmm")))
//        eventContents.append(MRYEventContent(description: NSLocalizedString("Hours(12H)", comment: ""), Content: Util.string(date, format: "h")))
//        eventContents.append(MRYEventContent(description: NSLocalizedString("Hours(24H)", comment: ""), Content: Util.string(date, format: "H")))
//        eventContents.append(MRYEventContent(description: NSLocalizedString("Minutes", comment: ""), Content: Util.string(date, format: "m")))
//        eventContents.append(MRYEventContent(description: NSLocalizedString("Month", comment: ""), Content: Util.string(date, format: "M")))
//        eventContents.append(MRYEventContent(description: NSLocalizedString("Day", comment: ""), Content: Util.string(date, format: "d")))
//        eventContents.append(MRYEventContent(description: NSLocalizedString("Year", comment: ""), Content: Util.string(date, format: "Y")))
        return eventContents
    }
}
