//
//  MRYAllDayEventView.swift
//  Moriyama
//
//  Created by Ichiro on 2016/02/09.
//  Copyright © 2016年 Ichiro. All rights reserved.
//

import UIKit

class MRYAllDayEventView: UIView {

    private let sidebarWidth : CGFloat = 45.0
    var allDayEventViews : [String: MRYEventView] = [:]
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    init(allDayEvents:[MRYEvent], viewController: MRYDayViewController){
        super.init(frame: CGRectZero)
        self.translatesAutoresizingMaskIntoConstraints = false
        let sidebarView = UIView()
        sidebarView.translatesAutoresizingMaskIntoConstraints = false
        sidebarView.backgroundColor = UIColor.whiteColor()
        let allDayEventContainerView = UIView()
        allDayEventContainerView.translatesAutoresizingMaskIntoConstraints = false
        allDayEventContainerView.backgroundColor = UIColor.whiteColor()
        self.addSubview(allDayEventContainerView)
        
        let allDayLabel = UILabel()
        allDayLabel.text = NSLocalizedString("All Day", comment: "All day")
        allDayLabel.textAlignment = .Center
        allDayLabel.textColor = UIColor.grayColor()
        sidebarView.addSubview(allDayLabel)
        allDayLabel.sizeToFit()
        allDayLabel.font = allDayLabel.font.fontWithSize(11)
        self.addSubview(sidebarView)
        
        let allDayViews = ["sidebar" : sidebarView,
        "allDayEventContainer": allDayEventContainerView]
        
        var vfl = "|"
        var i = 0
        allDayEvents.filter({ $0.allDay }).forEach({
            let eventView = MRYEventView(frame: CGRectZero, event: $0, viewController: viewController)
            eventView.translatesAutoresizingMaskIntoConstraints = false
            allDayEventContainerView.addSubview(eventView)
            allDayEventViews["e\(i)"] = eventView
            if(i == 0 ){
                vfl += "[e\(i)]"
            }else{
                vfl += "[e\(i)(==e0)]"
            }
            i += 1
        })
        vfl += "|"
       
        if(allDayEventViews.count > 0){
            allDayEventContainerView.addConstraints(
                NSLayoutConstraint.constraintsWithVisualFormat(
                    "V:|[e0]|",
                    options: NSLayoutFormatOptions(rawValue: 0),
                    metrics: nil,
                    views: allDayEventViews)
            )
            allDayEventContainerView.addConstraints(
                NSLayoutConstraint.constraintsWithVisualFormat(
                    vfl,
                    options: [.AlignAllBottom, .AlignAllTop],
                    metrics: nil,
                    views: allDayEventViews)
            )
        }
        let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[sidebar(\(sidebarWidth))][allDayEventContainer]|", options: [.AlignAllTop, .AlignAllBottom], metrics: nil, views: allDayViews)
        let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[sidebar]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: allDayViews)
        self.addConstraints(hConstraints)
        self.addConstraints(vConstraints)
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }
}
