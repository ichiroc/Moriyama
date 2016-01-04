//
//  DayViewController.swift
//  Moriyama
//
//  Created by Ichiro on 2016/01/02.
//  Copyright © 2016年 Ichiro. All rights reserved.
//

import UIKit

class MRYDayViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let container = UIScrollView()
        
        let vw = UIView()
        vw.backgroundColor = UIColor.blueColor()
        container.addSubview(vw)
        let c1 = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-[vw]-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: ["vw":vw])
        let c2 = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-[vw]-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: ["vw":vw])
        container.addConstraints(c1)
        container.addConstraints(c2)
        
        self.view.addSubview(container)
        let views = ["container": container]
        self.view.addConstraints( NSLayoutConstraint.constraintsWithVisualFormat("V:|-[container]-|", options: [.AlignAllCenterX ] , metrics: nil, views: views))
        self.view.addConstraints( NSLayoutConstraint.constraintsWithVisualFormat("|-[container]-|", options: [.AlignAllCenterX ] , metrics: nil, views: views))
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
