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
    var timelineScrollView : UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.lightGrayColor()
        timelineScrollView = UIScrollView()
        timelineScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let timeLine = UIView(frame: CGRectMake(0,0,self.view.frame.width,240))
        timeLine.backgroundColor = UIColor.whiteColor()
        timelineScrollView.addSubview(timeLine)
        timelineScrollView.contentSize = CGSizeMake(self.view.frame.width,240)
        
        cancelButton = MRYKeyboardButton(title: "Cancel", text: nil, backgroundColor: UIColor.whiteColor(), titleColor: UIColor.blueColor(), action: self.closeDayViewController)
        
        insertButton = MRYKeyboardButton(title: "Insert", text: nil, backgroundColor: UIColor.blueColor(), titleColor: UIColor.whiteColor(), action: nil)
        
        views = ["timeline": timeLine,
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
    

    func closeDayViewController(){
        self.dismissViewControllerAnimated(true, completion: nil)
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
