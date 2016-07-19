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

    private lazy var events : [MRYEvent] = { [unowned self] in
            MRYEventDataStore.sharedStore.eventsOnDate(self.currentDate)
    }()
    
    private lazy var allDayEvents: [MRYEvent] = { [unowned self ] in
        MRYEventDataStore.sharedStore.allDayEvents(self.currentDate)
    }()

    private var allDayEventView : UIView!
    private var managedSubViews : [String: UIView] = [:]
    private var accessoryKeyView : UIView!
    private var timelineContainerView : MRYTimelineContainerView!
    
    private override init(fromViewController: MRYAbstractMainViewController?) {
        currentDate = Util.removeHms(NSDate())
        let _events = MRYEventDataStore.sharedStore.eventsOnDate(currentDate)
        super.init(fromViewController: fromViewController)
        timelineContainerView = MRYTimelineContainerView(events: _events, viewController: self)
    }
    
    init(date: NSDate, fromViewController: MRYAbstractMainViewController?) {
        self.currentDate = Util.removeHms(date)
        super.init(fromViewController: fromViewController)
        self.timelineContainerView = MRYTimelineContainerView(events: events, viewController: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not implemented")
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
        let detailViewController = MRYEventDetailViewController(event: event, fromViewController: self)
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
            if let nEV = newEventView{
                showEventView(nEV, pointY: posY)
            }
        default:
            break
        }
    }
    
    private func showEventView(eventView: MRYEventView, pointY: CGFloat){
        // event.updateDataSource()
        eventView.sourceEvent.startDate = timelineContainerView.dateByPointY(pointY)
        eventView.sourceEvent.endDate = eventView.sourceEvent.startDate.dateByAddingTimeInterval(60 * 60)
        let contentFactory = MRYEventContentFactory(event: eventView.sourceEvent)
        let sourceEvent = eventView.sourceEvent
        sourceEvent.datasource = contentFactory.eventContentDatasource([
            MRYEventContentFactory.ContentType.StartDate ,
            ])
        sourceEvent.datasource.append(sourceEvent.endDateGroupWithMinutesInterval(30))
        sourceEvent.datasource.append(sourceEvent.endDateGroupWithMinutesInterval(60))
        sourceEvent.datasource.append(sourceEvent.endDateGroupWithMinutesInterval(90))
        sourceEvent.datasource.append(sourceEvent.endDateGroupWithMinutesInterval(120))
        sourceEvent.datasource.append(sourceEvent.endDateGroupWithMinutesInterval(150))
        sourceEvent.datasource.append(sourceEvent.endDateGroupWithMinutesInterval(180))
        self.tappedEventView(sourceEvent)
        eventView.removeFromSuperview()
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
