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
    let currentDate: NSDate
    private var _events : [MRYEvent]?
    private var events : [MRYEvent] {
        get {
            if _events != nil {
                return _events!
            }
            _events = MRYEventDataStore.sharedStore.eventsWithDate(currentDate)
            return _events!
        }
    }
    private var _allDayEvents : [MRYEvent]?
    private var allDayEvents: [MRYEvent] {
        get {
            if _allDayEvents != nil {
                return _allDayEvents!
            }
            _allDayEvents = MRYEventDataStore.sharedStore.allDayEvents(currentDate)
            return _allDayEvents!
        }
    }
    private var allDayEventView : UIView!
    private var managedSubViews : [String: UIView] = [:]
    private var accessoryKeyView : UIView!
    private var timelineContainerView : MRYTimelineContainerView!
    
    private override init(fromViewController: MRYAbstractMainViewController?) {
        currentDate = Util.removeHms(NSDate())
        let _events = MRYEventDataStore.sharedStore.eventsWithDate(currentDate)
        super.init(fromViewController: fromViewController)
        timelineContainerView = MRYTimelineContainerView(events: _events, viewController: self)
    }
    
    init(date: NSDate, fromViewController: MRYAbstractMainViewController?) {
        currentDate = Util.removeHms(date)
        super.init(fromViewController: fromViewController)
        timelineContainerView = MRYTimelineContainerView(events: events, viewController: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        currentDate = Util.removeHms(NSDate())
        timelineContainerView = MRYTimelineContainerView(coder: aDecoder)!
        super.init(coder: aDecoder)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.backgroundColor = UIColor.lightGrayColor()
        
        allDayEventView = MRYAllDayEventView(allDayEvents: events, viewController: self)
        accessoryKeyView = MRYDayViewAccessoryView(date: currentDate, viewController: self)
        self.view.addSubview(allDayEventView)
        managedSubViews = [
            "accessory" : accessoryKeyView,
            "timelineScroll": timelineContainerView,
            "allDayEvent": allDayEventView]
        
        let constraints = self.constraintsSubviews()
        self.view.addConstraints(constraints)
    }

    override func viewDidLayoutSubviews() {
        timelineContainerView.moveToInitialPointOnTimeline()
    }
  
    private func constraintsSubviews() -> [NSLayoutConstraint]{
        var constraints : [NSLayoutConstraint] = []
        
        self.view.addSubview(accessoryKeyView)
        self.view.addSubview(timelineContainerView)
        
        let vertical = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[accessory(36)]-1-[allDayEvent(40)]-1-[timelineScroll]|",
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
        let detailViewController = MRYEventContentsTableViewController(event: event, fromViewController: self)
        self.pushViewController(detailViewController)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var newEventView : MRYEventView?
    func longPressTimelineContainerView( recognizer: UILongPressGestureRecognizer){

        let point = recognizer.locationInView(timelineContainerView)
        let oddsTime = point.y % (timelineContainerView.hourlyHeight / 2 )
        let posY = point.y - oddsTime

        let rawEvent = EKEvent(eventStore: MRYEventDataStore.sharedStore.rawStore)
        rawEvent.calendar = MRYEventDataStore.sharedStore.defaultCalendar
        switch recognizer.state{
        case .Began:
            if timelineContainerView.isLocationInEventView(recognizer) {
                return
            }
            rawEvent.startDate = timelineContainerView.dateByPointY(posY)
            rawEvent.endDate = rawEvent.startDate.dateByAddingTimeInterval(60 * 60 )
            let event = MRYEvent(event: rawEvent)
            let frame = CGRectMake(0, posY , timelineContainerView.timelineView.frame.width, timelineContainerView.heightByEventDuration(event.duration))
            newEventView = MRYEventView(frame: frame, event: event, viewController: self)
            newEventView?.backgroundColor = UIColor(CGColor: MRYEventDataStore.sharedStore.defaultCalendar.CGColor).colorWithAlphaComponent(0.5)
            timelineContainerView.timelineView.addSubview(newEventView!)
        case .Changed:
            if let nev = newEventView {
                nev.frame.origin = CGPointMake(0, posY)
            }
        case .Ended:
            if let nev = newEventView{
                let startDate = timelineContainerView.dateByPointY(posY)
                let event = nev.sourceEvent
                event.startDate = startDate
                event.endDate = startDate.dateByAddingTimeInterval(60 * 60)
                // event.updateDataSource()
                let contentFactory = MRYEventContentFactory(event: event)
                event.datasource = contentFactory.eventContentDatasource([
                    MRYEventContentFactory.ContentType.StartDate ,
                    ])
                event.datasource.append(event.endDateGroupWithMinutesInterval(30))
                event.datasource.append(event.endDateGroupWithMinutesInterval(60))
                event.datasource.append(event.endDateGroupWithMinutesInterval(90))
                event.datasource.append(event.endDateGroupWithMinutesInterval(120))
                event.datasource.append(event.endDateGroupWithMinutesInterval(150))
                event.datasource.append(event.endDateGroupWithMinutesInterval(180))
                self.tappedEventView(newEventView!.sourceEvent)
                nev.removeFromSuperview()
            }
        default:
            break
        }
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
