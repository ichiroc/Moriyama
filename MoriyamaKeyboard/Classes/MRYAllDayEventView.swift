//
//  MRYAllDayEventView.swift
//  Moriyama
//
//  Created by Ichiro on 2016/02/09.
//  Copyright © 2016年 Ichiro. All rights reserved.
//

import UIKit

class MRYAllDayEventView: UIView {

    fileprivate let sidebarWidth : CGFloat = 45.0
    fileprivate var allDayEventViews : [String: MRYEventView] = [:]
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    // TODO: Refactoring
    init(allDayEvents:[MRYEvent], viewController: MRYDayViewController){
        super.init(frame: CGRect.zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        let sidebarView = UIView()
        sidebarView.translatesAutoresizingMaskIntoConstraints = false
        sidebarView.backgroundColor = UIColor.white
        let allDayEventContainerView = UIView()
        allDayEventContainerView.translatesAutoresizingMaskIntoConstraints = false
        allDayEventContainerView.backgroundColor = UIColor.white
        self.addSubview(allDayEventContainerView)
        
        let allDayLabel = UILabel()
        allDayLabel.text = NSLocalizedString("All Day", comment: "All day")
        allDayLabel.textAlignment = .center
        allDayLabel.textColor = UIColor.gray
        sidebarView.addSubview(allDayLabel)
        allDayLabel.sizeToFit()
        allDayLabel.font = allDayLabel.font.withSize(11)
        self.addSubview(sidebarView)
        
        let allDayViews = ["sidebar" : sidebarView,
        "allDayEventContainer": allDayEventContainerView]
        
        var vfl = "|"
        var i = 0
        allDayEvents.filter({ $0.allDay }).forEach({
            let eventView = MRYEventView(frame: CGRect.zero, event: $0, viewController: viewController)
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
                NSLayoutConstraint.constraints(
                    withVisualFormat: "V:|[e0]|",
                    options: NSLayoutFormatOptions(rawValue: 0),
                    metrics: nil,
                    views: allDayEventViews)
            )
            allDayEventContainerView.addConstraints(
                NSLayoutConstraint.constraints(
                    withVisualFormat: vfl,
                    options: [.alignAllBottom, .alignAllTop],
                    metrics: nil,
                    views: allDayEventViews)
            )
        }
        let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[sidebar(\(sidebarWidth))][allDayEventContainer]|", options: [.alignAllTop, .alignAllBottom], metrics: nil, views: allDayViews)
        let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[sidebar]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: allDayViews)
        self.addConstraints(hConstraints)
        self.addConstraints(vConstraints)
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }
}
