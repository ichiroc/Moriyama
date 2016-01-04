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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.lightGrayColor()
        let dayScrollView = UIScrollView()
        dayScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let timeLine = UIView(frame: CGRectMake(0,0,self.view.frame.width,240))
        timeLine.backgroundColor = UIColor.whiteColor()
        dayScrollView.addSubview(timeLine)
        dayScrollView.contentSize = CGSizeMake(self.view.frame.width,240)
        
        cancelButton = MRYKeyboardButton(title: "Cancel", text: nil, backgroundColor: UIColor.whiteColor(), titleColor: UIColor.blueColor(), action: self.closeDayViewController)
        self.view.addSubview(cancelButton)
        
        insertButton = MRYKeyboardButton(title: "Insert", text: nil, backgroundColor: UIColor.blueColor(), titleColor: UIColor.whiteColor(), action: nil)
        self.view.addSubview(insertButton)
        
        views = ["canvas": timeLine,
            "cancel": cancelButton,
            "insert" : insertButton,
            "dayView": dayScrollView]
        
        let constraints = makeConstraints()
//        scrollView.addConstraints(constraints)
        
        self.view.addSubview(dayScrollView)
        self.view.addConstraints( NSLayoutConstraint.constraintsWithVisualFormat("V:|-[dayView]-3-[cancel]-|", options: NSLayoutFormatOptions(rawValue: 0) , metrics: nil, views: views))
        self.view.addConstraints( NSLayoutConstraint.constraintsWithVisualFormat("|-[dayView]-|", options: [.AlignAllCenterX ] , metrics: nil, views: views))
        self.view.addConstraints( NSLayoutConstraint.constraintsWithVisualFormat("|-[cancel]-[insert(==cancel)]-|", options: [.AlignAllCenterY ] , metrics: nil, views: views))
    }

    func makeConstraints() -> [NSLayoutConstraint]{
        var constraints : [NSLayoutConstraint] = []
        let c1 = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-[canvas]-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: views)
        constraints.appendContentsOf(c1)
        let c2 = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-[canvas]-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: views)
        constraints.appendContentsOf(c2)
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
