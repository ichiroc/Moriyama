//
//  MRYEventContentsAccessoryView.swift
//  Moriyama
//
//  Created by Ichiro on 2016/05/28.
//  Copyright © 2016年 Ichiro. All rights reserved.
//

import UIKit
import EventKit

class MRYEventContentsAccessoryView: UIView {

    lazy var backButton = MRYKeyboardButton(title: NSLocalizedString("Back", comment: ""),
                                            imageFileName: nil,
                                            text: nil,
                                            backgroundColor: nil,
                                            titleColor: UIColor.blue,
                                            highlightedColor: nil,
                                            action: nil,
                                            round: 0)
    
    
    lazy var openEventButton :MRYKeyboardButton = { [unowned self]  in
        let b = MRYKeyboardButton(title: NSLocalizedString("Create an event", comment: ""),round: 0)
        let appIcon = UIImage.init(named: "AppImageSmall.png")
        b.setImage(appIcon, for: UIControlState())
        b.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        if self.event.eventIdentifier != ""{
            b.setTitle(NSLocalizedString("Edit this event", comment: ""), for: UIControlState())
        }
        return b
    }()
    
    fileprivate let event: MRYEvent
    fileprivate var buttons : [MRYKeyboardButton] = []

    
    init(event :MRYEvent, viewController: UIViewController){
        self.event = event
        super.init(frame: CGRect.zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(backButton)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }
    
    override func layoutSubviews() {
        var constraints : [NSLayoutConstraint] = []
        var views : [String:UIView] = ["back":backButton]
        var vvfl = "H:|"
        if self.event.calendar.allowsContentModifications{
            self.addSubview(self.openEventButton)
            views["openEvent"] = self.openEventButton
            vvfl += "[back(45)]-1-[openEvent]|"
        }else{
            vvfl += "[back]|"
        }

        let h = NSLayoutConstraint.constraints(withVisualFormat: vvfl,
                                                       options: [.alignAllTop,.alignAllBottom],
                                                       metrics: METRICS,
                                                       views: views)
        let v = NSLayoutConstraint.constraints(withVisualFormat: "V:|[back]|",
                                                              options: [],
                                                              metrics: METRICS,
                                                              views: views)
        constraints.append(contentsOf: h)
        constraints.append(contentsOf: v)
        self.addConstraints(constraints)
    }
    
}
