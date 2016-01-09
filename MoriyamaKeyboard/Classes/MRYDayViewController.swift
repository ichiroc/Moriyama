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
    var views : [String: UIView]!
    var doneButton : UIButton!
    var insertButton : UIButton!
    var monthlyView : MRYMonthlyCalendarCollectionView?
    var timelineScrollView : UIScrollView!
    var currentDate: NSDate?
    var formatter  = NSDateFormatter()
    let hourlyHeight = 40.0
    var timeline : UIView!
    var timelineSideBar : UIView!
    let timelineSidebarWidth : CGFloat = 25.0
    var events : [EKEvent] = []
    var eventViews : [UIView] = []
    var timelineWidth : CGFloat!
    private var cal  = NSCalendar.currentCalendar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        formatter.dateStyle = .ShortStyle
        formatter.dateFormat = "M/d(E)"
        
        self.view.backgroundColor = UIColor.lightGrayColor()
        timelineScrollView = UIScrollView()
        timelineScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        timelineWidth = self.view.frame.width - 32.0 - timelineSidebarWidth
        let timelineHeight = CGFloat(24 * hourlyHeight)
        timeline = UIView(frame: CGRectMake(timelineSidebarWidth,0,timelineWidth,timelineHeight))
       
        timelineSideBar = UIView(frame: CGRectMake(0,0,25,timelineHeight))
        timelineSideBar.backgroundColor = UIColor.whiteColor()
        
        makeTimelineView()
        
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
        
        views = ["timeline": timeline,
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
    
    func makeTimelineView(){
        timeline.backgroundColor = UIColor.whiteColor()
        timelineScrollView.addSubview(timeline)
        timelineScrollView.addSubview(timelineSideBar)
        timelineScrollView.contentSize = CGSizeMake(timeline.frame.width, timeline.frame.height)
        
        for (var i = 1.0 ; i < 24 ; i++) { // 0時の描画はしない
            let hour = UIView(frame: CGRectMake(0, CGFloat(i * hourlyHeight), timeline.frame.width, 1 ))
            hour.backgroundColor = UIColor.lightGrayColor()
            timeline.addSubview(hour)
            
            let timeLabel = UILabel(frame: CGRectMake(0, CGFloat(i * hourlyHeight - (hourlyHeight / 2) ), timelineSidebarWidth, CGFloat(hourlyHeight)))
            timeLabel.text = "\(Int(i))"
            timeLabel.font.fontWithSize(11.0)
            timeLabel.adjustsFontSizeToFitWidth = true
            timeLabel.textColor = UIColor.grayColor()
            timeLabel.textAlignment = .Center
            timelineSideBar.addSubview(timeLabel)
        }
        
    }
    
    func loadEventViews(){
        eventViews = []
        events.forEach{
            let startDate = $0.startDate
            let dateComp = cal.components( [.Hour, .Minute] , fromDate: startDate)
            let top = (Double(dateComp.hour) * hourlyHeight) + ((Double(dateComp.minute) / 60 ) * hourlyHeight)
            let interval  = $0.endDate.timeIntervalSinceDate(startDate)
            let height = (interval / 60 / 60) * hourlyHeight

            let eventView = UIView(frame: CGRectMake(0, CGFloat(top), timelineWidth,CGFloat(height) ))
            eventView.backgroundColor = UIColor(CGColor: $0.calendar.CGColor )
            
            // make color
            let color = UIColor(CGColor: $0.calendar.CGColor)
            var red, green, blue, alpha :CGFloat
            green = 0
            red = 0
            blue = 0
            alpha = 0
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
        layoutEventView()
    }
    
    func layoutEventView(){
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
