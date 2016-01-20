//
//  DayViewController.swift
//  Moriyama
//
//  Created by Ichiro on 2016/01/02.
//  Copyright © 2016年 Ichiro. All rights reserved.
//

import UIKit
import EventKit

class MRYDayViewController: UIViewController {
//    var monthlyView : MRYMonthCalendarCollectionView?
    var currentDate: NSDate?
    private var _events : [MRYEvent]?
    private var events : [MRYEvent] {
        get {
            if _events != nil {
                return _events!
            }
            if let date = currentDate{
                return MRYEventDataStore.instance.eventWithDate(date)
            }
            return []
        }
    }
    private var views : [String: UIView]!
    private var doneButton : UIButton!
    private var insertButton : UIButton!
    private var timelineScrollView : UIScrollView!
    private var formatter  = NSDateFormatter()
    private let hourlyHeight : CGFloat = 40.0
    private var timeline : UIView!
    private var eventViews : [UIView] = []
    private var timelineWidth : CGFloat!
    private var cal  = NSCalendar.currentCalendar()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.translatesAutoresizingMaskIntoConstraints = false
//        formatter.dateStyle = .ShortStyle
        formatter.dateFormat = "M/d(E)"
        
        self.view.backgroundColor = UIColor.lightGrayColor()
        timelineScrollView = timelineView()
        
        var titleText = "Insert"
        if let date = currentDate{
            //titleText = formatter.stringFromDate(date)
            titleText = Util.string(date, format: "MMMddE", locale: NSLocale.currentLocale())
        }
        insertButton = MRYKeyboardButton(
            title: titleText,
            backgroundColor: UIColor.blueColor(),
            titleColor: UIColor.whiteColor())
        doneButton = MRYKeyboardButton(title: "DONE", text: nil, action: { self.dismissSelf()})
        
        views = [
            "cancel": doneButton,
            "insert" : insertButton,
            "timelineScroll": timelineScrollView]
        
        let constraints = self.constraintsSubviews()
        self.view.addConstraints(constraints)
     
        
        moveToInitialPointOnTimeline()
        layoutEventViews()
    }


    private func moveToInitialPointOnTimeline(){
        let hour = cal.component(.Hour, fromDate: NSDate() )
        let initialPoint = CGPointMake(0.0, CGFloat(hour) * hourlyHeight )
        timelineScrollView.setContentOffset(initialPoint, animated: false)
    }


    private func timelineView() -> UIScrollView {
        let sidebarWidth : CGFloat = 25.0
        let timelineHeight = CGFloat(24) * hourlyHeight
        timelineWidth = self.view.frame.width - 32.0 - sidebarWidth
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

    private func constraintsSubviews() -> [NSLayoutConstraint]{
        var constraints : [NSLayoutConstraint] = []
        
        self.view.addSubview(doneButton)
        self.view.addSubview(timelineScrollView)
        
        let vertical = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-[timelineScroll]-3-[cancel]-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: views)
        constraints.appendContentsOf(vertical)
        
        let horizonalTimelineBase =  NSLayoutConstraint.constraintsWithVisualFormat(
            "|-[timelineScroll]-|",
            options: [.AlignAllCenterX ] ,
            metrics: nil,
            views: views)
        constraints.appendContentsOf(horizonalTimelineBase)
        
        self.view.addSubview(insertButton)
        let horizonalButtons = NSLayoutConstraint.constraintsWithVisualFormat("|-[cancel]-[insert(==cancel)]-|", options: [.AlignAllCenterY ] , metrics: nil, views: views)
        constraints.appendContentsOf(horizonalButtons)
        return constraints
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func dismissSelf(){
        if let keyboardVC = self.parentViewController as? KeyboardViewController {
            keyboardVC.transientToViewController(keyboardVC.prevViewController!)
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
