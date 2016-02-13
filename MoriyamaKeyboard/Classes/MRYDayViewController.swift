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
    private var accessoryKeyView : UIView!
    private var timelineContainerView : MRYTimelineContainerView!
    
    private override init(fromViewController: MRYAbstractMainViewController?) {
        currentDate = NSDate()
        let _events = MRYEventDataStore.instance.eventsWithDate(currentDate)
        super.init(fromViewController: fromViewController)
        timelineContainerView = MRYTimelineContainerView(events: _events, viewController: self)
    }
    
    init(date: NSDate, fromViewController: MRYAbstractMainViewController?) {
        currentDate = date
        super.init(fromViewController: fromViewController)
        timelineContainerView = MRYTimelineContainerView(events: events, viewController: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        currentDate = NSDate()
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
