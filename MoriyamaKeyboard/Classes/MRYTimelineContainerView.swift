//
//  MRYTimelineView.swift
//  Moriyama
//
//  Created by Ichiro on 2016/02/09.
//  Copyright © 2016年 Ichiro. All rights reserved.
//

import UIKit
import EventKit
class MRYTimelineContainerView : UIScrollView{
    
    let timelineView : UIView = UIView()
    let hourlyHeight : CGFloat = 40.0
    
    fileprivate var layouted : Bool = false
    fileprivate var events: [MRYEvent] = []
    fileprivate var eventViews: [MRYEventView] = []
    fileprivate unowned let dayViewController: MRYDayViewController
    fileprivate let sidebarWidth : CGFloat = 45.0

    fileprivate var contentView : UIView {
        get{
            return timelineView
        }
    }
    fileprivate var currentDate : Date {
        get{
            return dayViewController.currentDate as Date
        }
    }
    
    init( events _events : [MRYEvent], viewController: MRYDayViewController){
        dayViewController = viewController

        super.init(frame: CGRect.zero)
        self.addGestureRecognizer(UILongPressGestureRecognizer(target: dayViewController, action: #selector(MRYDayViewController.longPressTimelineContainerView(_:))) )
        events = _events
        self.addSubview(timelineView)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /**
     Return true if gestureRecognizer point is in eventViews frame.
     */
    func isLocationInEventView(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        var result = false
        eventViews.forEach({
            let point = gestureRecognizer.location(in: self)
            if $0.frame.contains(point){
                result = true
            }
        })
        return result
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }
    
    override func layoutSubviews() {
        if !layouted {
            let timelineHeight = CGFloat(24) * hourlyHeight
            let timelineWidth = self.frame.width - sidebarWidth
            timelineView.frame = CGRect(x: sidebarWidth ,y: 0,width: timelineWidth,height: timelineHeight)
            timelineView.backgroundColor = UIColor.white
            self.contentSize = CGSize(width: timelineView.frame.width, height: timelineView.frame.height)
            
            let tlSideBar = UIView(frame: CGRect(x: 0,y: 0,width: sidebarWidth,height: timelineHeight))
            tlSideBar.backgroundColor = UIColor.white
            for i in 1  ..< 24 { // 0時の描画はしない
                let hourLine = UIView(frame: CGRect(x: 0, y: CGFloat(i) * hourlyHeight , width: timelineView.frame.width, height: 1 ))
                hourLine.backgroundColor = UIColor.lightGray
                timelineView.addSubview(hourLine)
                
                let timeLabel = UILabel(frame: CGRect(x: 0, y: CGFloat(i) * hourlyHeight - (hourlyHeight / CGFloat(2) ), width: sidebarWidth, height: hourlyHeight))
                timeLabel.text = "\(Int(i))"
                timeLabel.font.withSize(11.0)
                timeLabel.adjustsFontSizeToFitWidth = true
                timeLabel.textColor = UIColor.gray
                timeLabel.textAlignment = .center
                tlSideBar.addSubview(timeLabel)
            }
            self.addSubview(tlSideBar)
            
            self.layoutEventViews()
            layouted = true
        }
        super.layoutSubviews()
    }

    fileprivate func layoutEventViews(){
        // set default frame
        events.filter({ return !$0.allDay }).forEach({
            var duration = $0.duration
            var dateComp = $0.componentsOnStartDate([.hour, .minute])
            if $0.startDate.compare(currentDate) == .orderedAscending {
                let interval = $0.startDate.timeIntervalSince(currentDate)
                duration += interval
                dateComp.hour = 0
                dateComp.minute = 0
            }
            let top = ((CGFloat(dateComp.hour!) * hourlyHeight) + (CGFloat(dateComp.minute!) / 60 ) * hourlyHeight)
            var height = (CGFloat(duration) / 60 / 60 ) * hourlyHeight
            if height < (hourlyHeight / 2){
                height = hourlyHeight / 2
            }
            let timelineWidth = self.frame.width
            let eventView = MRYEventView(frame: CGRect(x: 0, y: top, width: timelineWidth, height: height), event: $0, viewController: dayViewController)
            eventViews.append(eventView)
            
        })
        eventViews.forEach({ view in
            self.timelineView.addSubview(view)
        })
        
        // update frame size in according with conflicted events.
        var doneLayout: [String] = []
        let timelineWidth = self.contentView.frame.width
        eventViews.forEach({ eventView in
            let conflictedViews = eventView.detectConflictedViews(eventViews)
            var xpos : CGFloat = 0
            if !doneLayout.contains(eventView.eventIdentifier){
                let frame = eventView.frame
                let width = timelineWidth / CGFloat( conflictedViews.count + 1  )
                eventView.frame = CGRect(x: xpos, y: frame.origin.y , width: width , height: frame.size.height )
                xpos += width
                doneLayout.append(eventView.eventIdentifier)
            }
            conflictedViews.forEach({ conflictedView in
                if !doneLayout.contains(conflictedView.eventIdentifier){
                    let frame = conflictedView.frame
                    let width = timelineWidth / CGFloat( conflictedViews.count + 1  )
                    conflictedView.frame = CGRect(x: xpos, y: frame.origin.y , width: width , height: frame.size.height )
                    xpos += width
                    doneLayout.append(conflictedView.eventIdentifier)
                }
            })
        })
    }
   
    
    func moveToInitialPointOnTimeline(){
        var firstEventStartDate = Date()
        var hour = 7.5
        if let firstEvent =  events.filter({ return !$0.allDay }).first {
            firstEventStartDate = firstEvent.startDate as Date
            hour = Double((Calendar.current as NSCalendar).component(.hour, from: firstEventStartDate ))
            if firstEventStartDate.compare(currentDate) == .orderedAscending {
                hour = 0
            }
        }
        let initialPoint = CGPoint(x: 0.0, y: CGFloat(hour) * hourlyHeight )
        self.setContentOffset(initialPoint, animated: false)
    }
    
    func heightByEventDuration(_ duration : TimeInterval) -> CGFloat{
        var height = (CGFloat(duration) / 60 / 60 ) * hourlyHeight
        if height < (hourlyHeight / 2){
            height = hourlyHeight / 2
        }
        return height
    }
    
     func dateByPointY(_ Y : CGFloat) -> Date{
        let time = Y / hourlyHeight
        let hour = floor(time)
        let minutes = (time - hour) * 100 * 0.6
        var comp = (Calendar.current as NSCalendar).components([.year, .month, .day], from: currentDate)
        comp.hour = Int(hour)
        comp.minute = Int(minutes)
        return Calendar.current.date(from: comp)!
    }
    
}
