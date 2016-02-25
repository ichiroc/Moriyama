//
//  MRYTimelineView.swift
//  Moriyama
//
//  Created by Ichiro on 2016/02/09.
//  Copyright © 2016年 Ichiro. All rights reserved.
//

import UIKit

class MRYTimelineContainerView : UIScrollView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    var contentView : UIView {
        get{
            return timelineView
        }
    }
    
    let timelineView : UIView = UIView()
   
    var layouted : Bool = false
    private let hourlyHeight : CGFloat = 40.0
    private let sidebarWidth : CGFloat = 45.0
    
    var events: [MRYEvent] = []
    var eventViews: [MRYEventView] = []
    let dayViewController: MRYDayViewController
  
    var currentDate : NSDate {
        get{
            return dayViewController.currentDate
        }
    }
    init( events _events : [MRYEvent], viewController: MRYDayViewController){
        dayViewController = viewController
        super.init(frame: CGRectZero)
        events = _events
        self.addSubview(timelineView)
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder aDecoder: NSCoder) {
        dayViewController = MRYDayViewController(coder: aDecoder)!
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        if !layouted {
            let timelineHeight = CGFloat(24) * hourlyHeight
            let timelineWidth = self.frame.width - sidebarWidth
            timelineView.frame = CGRectMake(sidebarWidth ,0,timelineWidth,timelineHeight)
            timelineView.backgroundColor = UIColor.whiteColor()
            self.contentSize = CGSizeMake(timelineView.frame.width, timelineView.frame.height)
            
            let tlSideBar = UIView(frame: CGRectMake(0,0,sidebarWidth,timelineHeight))
            tlSideBar.backgroundColor = UIColor.whiteColor()
            for (var i = 1 ; i < 24 ; i++) { // 0時の描画はしない
                let hourLine = UIView(frame: CGRectMake(0, CGFloat(i) * hourlyHeight , timelineView.frame.width, 1 ))
                hourLine.backgroundColor = UIColor.lightGrayColor()
                timelineView.addSubview(hourLine)
                
                let timeLabel = UILabel(frame: CGRectMake(0, CGFloat(i) * hourlyHeight - (hourlyHeight / CGFloat(2) ), sidebarWidth, hourlyHeight))
                timeLabel.text = "\(Int(i))"
                timeLabel.font.fontWithSize(11.0)
                timeLabel.adjustsFontSizeToFitWidth = true
                timeLabel.textColor = UIColor.grayColor()
                timeLabel.textAlignment = .Center
                tlSideBar.addSubview(timeLabel)
            }
            self.addSubview(tlSideBar)
            
            self.layoutEventViews()
            layouted = true
        }
        super.layoutSubviews()
    }

    private func layoutEventViews(){
        // set default frame
        events.filter({ return !$0.allDay }).forEach({
            var duration = $0.duration
            let dateComp = $0.componentsOnStartDate([.Hour, .Minute])
            if $0.startDate.compare(currentDate) == .OrderedAscending {
                let interval = $0.startDate.timeIntervalSinceDate(currentDate)
                let debug = $0.startDate.dateByAddingTimeInterval(interval)
                duration += interval
                dateComp.hour = 0
                dateComp.minute = 0
            }
            let top = ((CGFloat(dateComp.hour) * hourlyHeight) + (CGFloat(dateComp.minute) / 60 ) * hourlyHeight)
            var height = (CGFloat(duration) / 60 / 60 ) * hourlyHeight
            if height < (hourlyHeight / 2){
                height = hourlyHeight / 2
            }
            let timelineWidth = self.frame.width
            let eventView = MRYEventView(frame: CGRectMake(0, top, timelineWidth, height), event: $0, hourlyHeight: hourlyHeight, viewController: dayViewController)
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
                eventView.frame = CGRectMake(xpos, frame.origin.y , width , frame.size.height )
                xpos += width
                doneLayout.append(eventView.eventIdentifier)
            }
            conflictedViews.forEach({ conflictedView in
                if !doneLayout.contains(conflictedView.eventIdentifier){
                    let frame = conflictedView.frame
                    let width = timelineWidth / CGFloat( conflictedViews.count + 1  )
                    conflictedView.frame = CGRectMake(xpos, frame.origin.y , width , frame.size.height )
                    xpos += width
                    doneLayout.append(conflictedView.eventIdentifier)
                }
            })
        })
    }
   
    
    func moveToInitialPointOnTimeline(){
        var date = NSDate()
        if let firstEvent =  events.filter({ return !$0.allDay }).first{
            date = firstEvent.startDate
        }
        var hour = NSCalendar.currentCalendar().component(.Hour, fromDate: date )
        if date.compare(currentDate) == .OrderedAscending {
            hour = 0
        }
        let initialPoint = CGPointMake(0.0, CGFloat(hour) * hourlyHeight )
        self.setContentOffset(initialPoint, animated: false)
    }
    
}
