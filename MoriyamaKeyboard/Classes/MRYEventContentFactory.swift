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
        case general
        case startDate
        case endDate
    }
    
    fileprivate let event : MRYEvent
    
    init(event e: MRYEvent){
        event = e
    }
    
    func eventContentsAtDateTime(_ date: Date) -> [MRYEventContent]{
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
   
    func eventContentDatasource( _ types : [ContentType]) -> [MRYEventContentGroup]{
        var datasource : [MRYEventContentGroup] = []
        types.forEach{
            switch $0{
            case .general:
                datasource.append(generalContentGroup())
            case .startDate:
                datasource.append(startDateContentGroup())
            case .endDate:
                datasource.append(endDateContentGroup())
            }
        }
        return datasource
    }
    
    fileprivate func generalContentGroup() -> MRYEventContentGroup{
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

        return generalGroup
    }

    fileprivate func startDateContentGroup() -> MRYEventContentGroup{
        var startDateGroup = MRYEventContentGroup(description: NSLocalizedString( "Start date", comment: "Start date of event."), eventContents: [])
        startDateGroup.eventContents = eventContentsAtDateTime(event.startDate as Date)
        return startDateGroup
    }
    
    fileprivate func endDateContentGroup() -> MRYEventContentGroup{
        var endDateGroup = MRYEventContentGroup(description:  NSLocalizedString("End date",comment: "End date of event."), eventContents: [])
        endDateGroup.eventContents = eventContentsAtDateTime(event.endDate as Date)
        return endDateGroup
    }
}
