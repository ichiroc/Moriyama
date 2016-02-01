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
    var currentDate: NSDate?
    private var _events : [MRYEvent]?
    private var events : [MRYEvent] {
        get {
            if _events != nil {
                return _events!
            }
            if let date = currentDate{
                _events = MRYEventDataStore.instance.eventWithDate(date)
                return _events!
            }
            return []
        }
    }
    private var views : [String: UIView]!
    private var backButton : UIButton!
    private var insertButton : UIButton!
    private var accessoryKeyView : UIView!
    private var accessoryKeyViews : [String:UIView] = [:]
    private var timelineScrollView : UIScrollView!
    private let hourlyHeight : CGFloat = 40.0
    private var timeline : UIView!
    private var eventViews : [UIView] = []
    private var timelineWidth : CGFloat!
    private var cal  = NSCalendar.currentCalendar()
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.backgroundColor = UIColor.lightGrayColor()
        timelineScrollView = timelineView()
        
        accessoryKeyView = accessoryView()
        views = [
            "accessory" : accessoryKeyView,
            "timelineScroll": timelineScrollView]
        
        let constraints = self.constraintsSubviews()
        self.view.addConstraints(constraints)
        
        layoutEventViews()
        
        moveToInitialPointOnTimeline()
    }


    private func moveToInitialPointOnTimeline(){
        var date = NSDate()
        if let firstEvent =  _events?.first{
            date = firstEvent.startDate
        }
        let hour = cal.component(.Hour, fromDate: date )
        let initialPoint = CGPointMake(0.0, CGFloat(hour) * hourlyHeight )
        timelineScrollView.setContentOffset(initialPoint, animated: false)
    }


    private func timelineView() -> UIScrollView {
        let sidebarWidth : CGFloat = 25.0
        let timelineHeight = CGFloat(24) * hourlyHeight
        timelineWidth = self.view.frame.width - MARGIN_LEFT - MARGIN_RIGHT - sidebarWidth
        timelineScrollView = UIScrollView()
        timelineScrollView.translatesAutoresizingMaskIntoConstraints = false
        timeline = UIView(frame: CGRectMake(sidebarWidth,0,timelineWidth,timelineHeight))
        timeline.backgroundColor = UIColor.whiteColor()
        timelineScrollView.addSubview(timeline)
        timelineScrollView.contentSize = CGSizeMake(timeline.frame.width, timeline.frame.height)
        
        let tlSideBar = UIView(frame: CGRectMake(0,0,25,timelineHeight))
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
        var doneLayout : [MRYEvent] = []
        events.forEach({
            let conflicts = MRYEventDataStore.instance.conflictedEventsWith($0)
            if conflicts.count == 0 {
                if !doneLayout.contains($0) {
                    doneLayout.append($0)
                    let view = MRYEventView(frame: CGRectZero, event: $0 , hourlyHeight: hourlyHeight, viewController: self)
                    view.recalculateSizeAndPosition(timelineWidth)
                    eventViews.append(view)
                }
            }else{
                for( var i = 0; i < conflicts.count; i++){
                    let conflictedEvent = conflicts[i]
                    if !doneLayout.contains(conflictedEvent) {
                        doneLayout.append(conflictedEvent)
                        let view = MRYEventView(frame: CGRectZero, event: conflictedEvent, hourlyHeight: hourlyHeight, viewController: self)
                        view.recalculateSizeAndPosition(timelineWidth)
                        view.frame.origin = CGPointMake(CGFloat(i) * view.frame.width, view.frame.origin.y)
                        eventViews.append(view)
                    }
                }
            }
        })
        eventViews.forEach({ view in
            timeline.addSubview(view)
            view.subviews.forEach{
                $0.sizeToFit()
            }
        })
    }
    
    private func accessoryView() -> UIView{
        accessoryKeyView = UIView()
        accessoryKeyView.translatesAutoresizingMaskIntoConstraints = false
        
        let dateFormats = ["MMMdE", "MMM","d","EEEE", "YYYYMMdd"]
        if let date = currentDate{
            dateFormats.forEach({
                let text = Util.string(date, format: $0 )
                let button = MRYKeyboardButton(title: text)
                accessoryKeyViews[$0] = button
                accessoryKeyView.addSubview(button)
            })
        }
        
        
        backButton = MRYKeyboardButton(title: "Back",
            backgroundColor: UIColor.whiteColor(),
            titleColor: UIColor.blueColor(),
            action: {self.popViewController()},
            round: 0)
        accessoryKeyView.addSubview(backButton)
        accessoryKeyViews["back"] = backButton
        
        var vfl = "|[back(45)]"
        dateFormats.forEach({
            vfl += "-1-[\($0)]"
        })
        vfl += "-1-|"
        
        accessoryKeyView.addSubview(timelineScrollView)
        let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            vfl,
            options: [ .AlignAllTop, .AlignAllBottom ] ,
            metrics: METRICS,
            views: accessoryKeyViews)
        accessoryKeyView.addConstraints(hConstraints)
        
        let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[back]|",
            options: NSLayoutFormatOptions(rawValue: 0) ,
            metrics: METRICS,
            views: accessoryKeyViews)
        accessoryKeyView.addConstraints(vConstraints)
        return accessoryKeyView
    }
  
    private func constraintsSubviews() -> [NSLayoutConstraint]{
        var constraints : [NSLayoutConstraint] = []
        
        self.view.addSubview(accessoryKeyView)
        self.view.addSubview(timelineScrollView)
        
        let vertical = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[accessory(40)]-1-[timelineScroll]|",
            options: [.AlignAllLeading, .AlignAllTrailing],
            metrics: METRICS,
            views: views)
        constraints.appendContentsOf(vertical)
        
        let horizonalTimelineBase =  NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|[timelineScroll]|",
            options: [.AlignAllCenterX ] ,
            metrics: METRICS,
            views: views)
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
