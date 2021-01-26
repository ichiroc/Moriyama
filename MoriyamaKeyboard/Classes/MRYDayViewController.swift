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

    let currentDate: Date
    
    fileprivate var newEventView : MRYEventView?
    fileprivate var allDayEventView : UIView!
    fileprivate var managedSubViews : [String: UIView] = [:]
    fileprivate var accessoryKeyView : UIView!
    fileprivate var timelineContainerView : MRYTimelineContainerView!
    
    fileprivate lazy var events : [MRYEvent] = { [unowned self] in
        MRYEventDataStore.sharedStore.eventsOnDate(self.currentDate)
        }()
    
    fileprivate lazy var allDayEvents: [MRYEvent] = { [unowned self ] in
        MRYEventDataStore.sharedStore.allDayEvents(self.currentDate)
        }()
    
    
    fileprivate override init(fromViewController: MRYAbstractMainViewController?) {
        currentDate = Util.removeHms(Date())
        let _events = MRYEventDataStore.sharedStore.eventsOnDate(currentDate)
        super.init(fromViewController: fromViewController)
        timelineContainerView = MRYTimelineContainerView(events: _events, viewController: self)
    }
    
    init(date: Date, fromViewController: MRYAbstractMainViewController?) {
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
        
        self.view.backgroundColor = UIColor.lightGray
        
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
  
    fileprivate func constraintsSubviews() -> [NSLayoutConstraint]{
        var constraints : [NSLayoutConstraint] = []
        
        self.view.addSubview(accessoryKeyView)
        self.view.addSubview(timelineContainerView)
        
        constraints.append(
            contentsOf: NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[accessory(36)]-1-[allDayEvent(40)]-1-[timelineScroll]|",
                options: [.alignAllLeading, .alignAllTrailing],
                metrics: METRICS,
                views: managedSubViews)
        )
        
        constraints.append(
            contentsOf: NSLayoutConstraint.constraints(
                withVisualFormat: "H:|[timelineScroll]|",
                options: [.alignAllCenterX ] ,
                metrics: METRICS,
                views: managedSubViews)
        )
        
        return constraints
    }
    
    func tappedEventView( _ event: MRYEvent){
        let detailViewController = MRYEventDetailViewController(event: event, fromViewController: self)
        self.pushViewController(detailViewController)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func longPressTimelineContainerView( _ recognizer: UILongPressGestureRecognizer){

        let point = recognizer.location(in: timelineContainerView)
        let oddHour = point.y.truncatingRemainder(dividingBy: (timelineContainerView.hourlyHeight / 2 ))
        let posY = point.y - oddHour
        switch recognizer.state{
        case .began:
            if timelineContainerView.isLocationInEventView(recognizer) {
                return
            }
            newEventView = eventViewWith(pointY: posY)
            timelineContainerView.timelineView.addSubview(newEventView!)
        case .changed:
            if let nEV = newEventView {
                nEV.frame.origin = CGPoint(x: 0, y: posY)
            }
        case .ended:
            if let nEV = newEventView{
                showEventView(nEV, pointY: posY)
            }
        default:
            break
        }
    }
    
    fileprivate func eventViewWith( pointY : CGFloat) -> MRYEventView{
        let rawEvent = EKEvent(eventStore: MRYEventDataStore.sharedStore.rawStore)
        rawEvent.calendar = MRYEventDataStore.sharedStore.defaultCalendar
        rawEvent.startDate = timelineContainerView.dateByPointY(pointY)
        rawEvent.endDate = rawEvent.startDate.addingTimeInterval(60 * 60 )
        let event = MRYEvent(event: rawEvent)
        let frame = CGRect(x: 0, y: pointY , width: timelineContainerView.timelineView.frame.width,
                               height: timelineContainerView.heightByEventDuration(event.duration))
        let newEventView = MRYEventView(frame: frame,
                                    event: event,
                                    viewController: self)
        newEventView.backgroundColor = UIColor(cgColor: MRYEventDataStore.sharedStore.defaultCalendar.cgColor).withAlphaComponent(0.5)
        return newEventView
    }
    
    fileprivate func showEventView(_ eventView: MRYEventView, pointY: CGFloat){
        // event.updateDataSource()
        eventView.sourceEvent.startDate = timelineContainerView.dateByPointY(pointY)
        eventView.sourceEvent.endDate = eventView.sourceEvent.startDate.addingTimeInterval(60 * 60)
        let contentFactory = MRYEventContentFactory(event: eventView.sourceEvent)
        let sourceEvent = eventView.sourceEvent
        sourceEvent.datasource = contentFactory.eventContentDatasource([
            MRYEventContentFactory.ContentType.startDate ,
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
