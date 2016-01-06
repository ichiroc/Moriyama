//
//  DayViewController.swift
//  Moriyama
//
//  Created by Ichiro on 2016/01/02.
//  Copyright © 2016年 Ichiro. All rights reserved.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        formatter.dateStyle = .ShortStyle
        formatter.dateFormat = "M/d(E)"
        
        self.view.backgroundColor = UIColor.lightGrayColor()
        timelineScrollView = UIScrollView()
        timelineScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let timelineWidth = self.view.frame.width - 32.0 - timelineSidebarWidth
        let timelineHeight = CGFloat(24 * hourlyHeight)
        timeline = UIView(frame: CGRectMake(timelineSidebarWidth,0,timelineWidth,timelineHeight))
       
        timelineSideBar = UIView(frame: CGRectMake(0,0,25,timelineHeight))
        timelineSideBar.backgroundColor = UIColor.whiteColor()
        
        layoutTimeline()
        
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
    }
    
    func layoutTimeline(){
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
