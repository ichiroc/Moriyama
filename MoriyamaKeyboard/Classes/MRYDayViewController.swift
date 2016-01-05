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
    var cancelButton : UIButton!
    var insertButton : UIButton!
    var monthlyView : MRYMonthlyCalendarCollectionView?
    var timelineScrollView : UIScrollView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.lightGrayColor()
        timelineScrollView = UIScrollView()
        timelineScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let width = self.view.frame.width - 32
        let hourlyHeight = 40.0
        let height = CGFloat(24 * hourlyHeight)
        let timeline = UIView(frame: CGRectMake(0,0,width,height))
        timeline.backgroundColor = UIColor.whiteColor()
        timelineScrollView.addSubview(timeline)
        timelineScrollView.contentSize = CGSizeMake(width,height)
        
        for (var i = 0.0 ; i < 24 ; i++) {
            let hour = UIView(frame: CGRectMake(0, CGFloat(i * hourlyHeight), width, 1 ))
            hour.backgroundColor = UIColor.lightGrayColor()
            timeline.addSubview(hour)
        }
        
        cancelButton = MRYKeyboardButton(title: "Cancel", text: nil, backgroundColor: UIColor.whiteColor(), titleColor: UIColor.blueColor(), action: self.dismissSelf)
        
        insertButton = MRYKeyboardButton(title: "Insert", text: nil, backgroundColor: UIColor.blueColor(), titleColor: UIColor.whiteColor(), action: nil)
        
        views = ["timeline": timeline,
            "cancel": cancelButton,
            "insert" : insertButton,
            "timelineScroll": timelineScrollView]
        
        let constraints = self.constraintsSubviews()
        self.view.addConstraints(constraints)
    }

    func constraintsSubviews() -> [NSLayoutConstraint]{
        var constraints : [NSLayoutConstraint] = []
        
        self.view.addSubview(cancelButton)
        self.view.addSubview(timelineScrollView)
        
        let vertical = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[timelineScroll]-3-[cancel]-|", options: NSLayoutFormatOptions(rawValue: 0) , metrics: nil, views: views)
        constraints.appendContentsOf(vertical)
        
        let horizonalTimelineBase =  NSLayoutConstraint.constraintsWithVisualFormat("|-[timelineScroll]-|", options: [.AlignAllCenterX ] , metrics: nil, views: views)
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
