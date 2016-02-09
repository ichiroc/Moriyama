//
//  DayViewController.swift
//  Moriyama
//
//  Created by Ichiro on 2016/01/02.
//  Copyright © 2016年 Ichiro. All rights reserved.
//

import UIKit
import EventKit

class MRYDayViewController: MRYAbstractMainViewController {
//    var monthlyView : MRYMonthCalendarCollectionView?
    let currentDate: NSDate
    private var _events : [MRYEvent]?
    private var events : [MRYEvent] {
        get {
            if _events != nil {
                return _events!
            }
            _events = MRYEventDataStore.instance.eventsWithDate(currentDate)
            return _events!
        }
    }
    private var _allDayEvents : [MRYEvent]?
    private var allDayEvents: [MRYEvent] {
        get {
            if _allDayEvents != nil {
                return _allDayEvents!
            }
            _allDayEvents = MRYEventDataStore.instance.allDayEvents(currentDate)
            return _allDayEvents!
        }
    }
    private var allDayEventView : UIView!
    private var managedSubViews : [String: UIView] = [:]
    private var allDayViews : [String: UIView] = [:]
    private var allDayEventViews : [String: UIView] = [:]
//    private var backButton : UIButton!
//    private var insertButton : UIButton!
    private var accessoryKeyView : UIView!
//    private var accessoryKeyViews : [String:UIView] = [:]
    private var timelineScrollView : UIScrollView!
    private let hourlyHeight : CGFloat = 40.0
    private var timeline : UIView!
    private var eventViews : [MRYEventView] = []
    private var timelineWidth : CGFloat!
    private let timelineSidebarWidth : CGFloat = 45.0
    private var cal  = NSCalendar.currentCalendar()
    
    override init(fromViewController: MRYAbstractMainViewController?) {
        currentDate = NSDate()
        super.init(fromViewController: fromViewController)
    }
    
    init(date: NSDate, fromViewController: MRYAbstractMainViewController?) {
        currentDate = date
        super.init(fromViewController: fromViewController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        currentDate = NSDate()
        super.init(coder: aDecoder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.backgroundColor = UIColor.lightGrayColor()
        timelineScrollView = timelineView()
        
        allDayEventView = MRYAllDayEventView(allDayEvents: events, hourlyHeight: hourlyHeight, timelineSidebarWidth: timelineSidebarWidth, viewController: self)
        accessoryKeyView = MRYDayViewAccessoryView(date: currentDate, viewController: self)
        self.view.addSubview(allDayEventView)
        managedSubViews = [
            "accessory" : accessoryKeyView,
            "timelineScroll": timelineScrollView,
            "allDayEvent": allDayEventView]
        
        let constraints = self.constraintsSubviews()
        self.view.addConstraints(constraints)
        
        layoutEventViews()
        
        moveToInitialPointOnTimeline()
    }


    private func moveToInitialPointOnTimeline(){
        var date = NSDate()
        if let firstEvent =  events.filter({ return !$0.allDay }).first{
            date = firstEvent.startDate
        }
        let hour = cal.component(.Hour, fromDate: date )
        let initialPoint = CGPointMake(0.0, CGFloat(hour) * hourlyHeight )
        timelineScrollView.setContentOffset(initialPoint, animated: false)
    }


    private func timelineView() -> UIScrollView {
        let sidebarWidth : CGFloat = timelineSidebarWidth
        let timelineHeight = CGFloat(24) * hourlyHeight
        timelineWidth = self.view.frame.width - MARGIN_LEFT - MARGIN_RIGHT - sidebarWidth
        let timelineScrollView = UIScrollView()
        timelineScrollView.translatesAutoresizingMaskIntoConstraints = false
        timeline = UIView(frame: CGRectMake(sidebarWidth,0,timelineWidth,timelineHeight))
        timeline.backgroundColor = UIColor.whiteColor()
        timelineScrollView.addSubview(timeline)
        timelineScrollView.contentSize = CGSizeMake(timeline.frame.width, timeline.frame.height)
        
        let tlSideBar = UIView(frame: CGRectMake(0,0,timelineSidebarWidth,timelineHeight))
        tlSideBar.backgroundColor = UIColor.whiteColor()
        for (var i = 1 ; i < 24 ; i++) { // 0時の描画はしない
            let hourLine = UIView(frame: CGRectMake(0, CGFloat(i) * hourlyHeight , timeline.frame.width, 1 ))
            hourLine.backgroundColor = UIColor.lightGrayColor()
            timeline.addSubview(hourLine)
            
            let timeLabel = UILabel(frame: CGRectMake(0, CGFloat(i) * hourlyHeight - (hourlyHeight / CGFloat(2) ), sidebarWidth, hourlyHeight))
            timeLabel.text = "\(Int(i))"
            timeLabel.font.fontWithSize(11.0)
            timeLabel.adjustsFontSizeToFitWidth = true
            timeLabel.textColor = UIColor.grayColor()
            timeLabel.textAlignment = .Center
            tlSideBar.addSubview(timeLabel)
        }
        timelineScrollView.addSubview(tlSideBar)
        return timelineScrollView
        
    }

    private func layoutEventViews(){
        // set default frame
        events.filter({ return !$0.allDay }).forEach({
            let dateComp = $0.componentsOnStartDate([.Hour, .Minute])
            let top = ((CGFloat(dateComp.hour) * hourlyHeight) + (CGFloat(dateComp.minute) / 60 ) * hourlyHeight)
            var height = (CGFloat($0.duration) / 60 / 60 ) * hourlyHeight
            if height < (hourlyHeight / 2){
                height = hourlyHeight / 2
            }
            let eventView = MRYEventView(frame: CGRectMake(0, top, timelineWidth, height), event: $0, hourlyHeight: hourlyHeight, viewController: self)
            eventViews.append(eventView)
            
        })
        eventViews.forEach({ view in
            timeline.addSubview(view)
        })
        
        // update frame size in according with conflicted events.
        var doneLayout: [String] = []
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
    
  
    private func constraintsSubviews() -> [NSLayoutConstraint]{
        var constraints : [NSLayoutConstraint] = []
        
        self.view.addSubview(accessoryKeyView)
        self.view.addSubview(timelineScrollView)
        
        let vertical = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[accessory(40)]-1-[allDayEvent(40)]-1-[timelineScroll]|",
            options: [.AlignAllLeading, .AlignAllTrailing],
            metrics: METRICS,
            views: managedSubViews)
        constraints.appendContentsOf(vertical)
        
        let horizonalTimelineBase =  NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|[timelineScroll]|",
            options: [.AlignAllCenterX ] ,
            metrics: METRICS,
            views: managedSubViews)
        constraints.appendContentsOf(horizonalTimelineBase)
        
        return constraints
    }
    
    func tappedEventView( event: MRYEvent){
        let detailViewController = MRYTimeDetailTableViewController(event: event, fromViewController: self)
        self.pushViewController(detailViewController)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
