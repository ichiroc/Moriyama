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
    var monthlyView : MRYMonthlyCalendarCollectionView?
    var currentDate: NSDate?
    private var events : [MRYEvent] {
        get {
            if let date = currentDate{
                return MRYEventDataStore.singleton().eventWithDate(date)
            }
            return []
        }
    }
    private var views : [String: UIView]!
    private var doneButton : UIButton!
    private var insertButton : UIButton!
    private var timelineScrollView : UIScrollView!
    private var formatter  = NSDateFormatter()
    private let hourlyHeight = 40.0
    private var timeline : UIView!
    private var eventViews : [UIView] = []
    private var timelineWidth : CGFloat!
    private var cal  = NSCalendar.currentCalendar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        formatter.dateStyle = .ShortStyle
        formatter.dateFormat = "M/d(E)"
        
        self.view.backgroundColor = UIColor.lightGrayColor()
        timelineScrollView = timelineView()
        
        doneButton = MRYKeyboardButton(title: "Done",
            text: nil,
            backgroundColor: UIColor.whiteColor(),
            titleColor: UIColor.blueColor(),
            action: self.dismissSelf)
        
        var titleText = "Insert"
        if let date = currentDate{
            titleText = formatter.stringFromDate(date)
        }
        insertButton = MRYKeyboardButton(
            title: titleText,
            text: nil,
            backgroundColor: UIColor.blueColor(),
            titleColor: UIColor.whiteColor(),
            action: { self.insert()})
        
        views = [
            "cancel": doneButton,
            "insert" : insertButton,
            "timelineScroll": timelineScrollView]
        
        let constraints = self.constraintsSubviews()
        self.view.addConstraints(constraints)
     
        moveToInitialPointOnTimeline()
        loadEventViews()

    }
    
    func moveToInitialPointOnTimeline(){
        let hour = cal.component(.Hour, fromDate: NSDate() )
        let initialPoint = CGPointMake(0.0, CGFloat(hour) * CGFloat(hourlyHeight ))
        timelineScrollView.setContentOffset(initialPoint, animated: false)
    }
    
    func timelineView() -> UIScrollView {
        let sidebarWidth : CGFloat = 25.0
        let timelineHeight = CGFloat(24 * hourlyHeight)
        timelineWidth = self.view.frame.width - 32.0 - sidebarWidth
        timelineScrollView = UIScrollView()
        timelineScrollView.translatesAutoresizingMaskIntoConstraints = false
        timeline = UIView(frame: CGRectMake(sidebarWidth,0,timelineWidth,timelineHeight))
        timeline.backgroundColor = UIColor.whiteColor()
        timelineScrollView.addSubview(timeline)
        timelineScrollView.contentSize = CGSizeMake(timeline.frame.width, timeline.frame.height)
        
        let tlSideBar = UIView(frame: CGRectMake(0,0,25,timelineHeight))
        tlSideBar.backgroundColor = UIColor.whiteColor()
        for (var i = 1.0 ; i < 24 ; i++) { // 0時の描画はしない
            let hourLine = UIView(frame: CGRectMake(0, CGFloat(i * hourlyHeight), timeline.frame.width, 1 ))
            hourLine.backgroundColor = UIColor.lightGrayColor()
            timeline.addSubview(hourLine)
            
            let timeLabel = UILabel(frame: CGRectMake(0, CGFloat(i * hourlyHeight - (hourlyHeight / 2) ), sidebarWidth, CGFloat(hourlyHeight)))
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
    
    
    func loadEventViews(){
        eventViews = []
        events.forEach{
            let startDate = $0.startDate
            let dateComp = cal.components( [.Hour, .Minute] , fromDate: startDate)
            let top = (Double(dateComp.hour) * hourlyHeight) + ((Double(dateComp.minute) / 60 ) * hourlyHeight)
            let height = $0.duration * hourlyHeight

            let eventView = UIView(frame: CGRectMake(0, CGFloat(top), timelineWidth,CGFloat(height) ))
            eventView.backgroundColor = UIColor(CGColor: $0.calendar.CGColor )
            
            // make color
            let color = UIColor(CGColor: $0.calendar.CGColor)
            var red, green, blue, alpha :CGFloat
            green = 0; red = 0; blue = 0; alpha = 0
            color.getRed(&red, green: &green , blue: &blue , alpha: &alpha)
            let bgDelta = ((red * 255 * 299) + (green * 255 *  587) + (blue * 255 * 114)) / 1000
            let titleLabel = UILabel()
            titleLabel.text = $0.title
            titleLabel.font = UIFont.systemFontOfSize(13)
            titleLabel.adjustsFontSizeToFitWidth = true
            titleLabel.numberOfLines = 1
            titleLabel.lineBreakMode = .ByClipping
            titleLabel.minimumScaleFactor = 0.01
            if bgDelta < 125 {
                titleLabel.textColor = UIColor.whiteColor()
            }else{
                titleLabel.textColor = UIColor.blackColor()
            }
            eventView.addSubview(titleLabel)
            eventView.layer.borderColor = UIColor.whiteColor().CGColor
            eventView.layer.borderWidth = 0.5
            eventViews.append(eventView)
        }
        layoutEventViews()
    }
    
    func layoutEventViews(){
        var conflicts: [[UIView]] = []
        var skipViews : [UIView] = []
        for(var i = 0; i < eventViews.count; i++){
            let iEvent = events[i]
            let iEventStart = iEvent.startDate
            let iEventEnd = iEvent.endDate
            var innerConflicts : [UIView] = [eventViews[i]]
            for(var y = i + 1; y < eventViews.count; y++){
                if !skipViews.contains(eventViews[y]){
                    let yEvent = events[y]
                    let yEventStart = yEvent.startDate
                    let yEventEnd = yEvent.endDate
                    
                    if !((iEventEnd.compare(yEventStart) == NSComparisonResult.OrderedSame ||
                        iEventEnd.compare(yEventStart) == NSComparisonResult.OrderedAscending)
                        ||
                        (iEventStart.compare(yEventEnd) == NSComparisonResult.OrderedDescending ||
                            iEventStart.compare(yEventEnd) == NSComparisonResult.OrderedSame))
                    {
                        skipViews.append(eventViews[y])
                        innerConflicts.append(eventViews[y])
                    }
                }
            }
            if innerConflicts.count >= 2 {
                conflicts.append(innerConflicts)
            }
        }
        
        conflicts.forEach({ conflicts0 in
            var leftOrder = 0
            conflicts0.forEach({ view in
                let width = view.frame.width / CGFloat(conflicts0.count)
                view.frame = CGRectMake(
                    CGFloat(leftOrder) * width  ,
                    view.frame.origin.y ,
                    view.frame.width / CGFloat(conflicts0.count),
                    view.frame.height)
                leftOrder++
            })
        })
        eventViews.forEach({ view in
            timeline.addSubview(view)
            view.subviews.forEach{
                $0.sizeToFit()
            }
        })
    }
    
    func constraintsSubviews() -> [NSLayoutConstraint]{
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
    
    func insert(){
        if let date = currentDate {
            MRYTextDocumentProxy.proxy.insertText(formatter.stringFromDate(date))
        }
    }
    
    func dismissSelf(){
        if let monthlyView0 = self.monthlyView {
            monthlyView0.dismissDayViewController()
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
