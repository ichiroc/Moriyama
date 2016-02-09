//
//  MRYDayViewAccessoryView.swift
//  Moriyama
//
//  Created by Ichiro on 2016/02/10.
//  Copyright © 2016年 Ichiro. All rights reserved.
//

import UIKit

class MRYDayViewAccessoryView: UIView {
    
    var subViews : [String: UIView] = [:]
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(date: NSDate, viewController: MRYAbstractMainViewController){
        super.init(frame: CGRectZero)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let dateFormats = ["MMMdE", "MMM","d","EEEE", "YYYYMMdd"]
        dateFormats.forEach({
            let text = Util.string(date, format: $0 )
            let button = MRYKeyboardButton(title: text, round: 0)
            subViews[$0] = button
            self.addSubview(button)
        })
        
        
        let backButton = MRYKeyboardButton(title: "Back",
            backgroundColor: UIColor.whiteColor(),
            titleColor: UIColor.blueColor(),
            action: {viewController.popViewController()},
            round: 0)
        self.addSubview(backButton)
        subViews["back"] = backButton
        
        var vfl = "|[back(45)]"
        dateFormats.forEach({
            vfl += "-1-[\($0)(>=40)]"
        })
        vfl += "-1-|"
        
        let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            vfl,
            options: [ .AlignAllTop, .AlignAllBottom ] ,
            metrics: METRICS,
            views: subViews)
        self.addConstraints(hConstraints)
        
        let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[back]|",
            options: NSLayoutFormatOptions(rawValue: 0) ,
            metrics: METRICS,
            views: subViews)
        self.addConstraints(vConstraints)
    }
}
