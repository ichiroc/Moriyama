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

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    lazy var backButton = MRYKeyboardButton(title: NSLocalizedString("Back", comment: ""), text: nil, backgroundColor: nil, titleColor: UIColor.blueColor(), action: nil, round: 0)

    lazy var openEventButton :MRYKeyboardButton = { [unowned self]  in
        let b = MRYKeyboardButton(title: NSLocalizedString("Create an event", comment: ""),round: 0)
        let appIcon = UIImage.init(named: "AppImageSmall.png")
        b.setImage(appIcon, forState: .Normal)
        b.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        if self.event.eventIdentifier != ""{
            b.setTitle("Edit this event", forState: .Normal)
        }
        return b
    }()
    
    private let event: MRYEvent
    var buttons : [MRYKeyboardButton] = []

    init(event :MRYEvent, viewController: UIViewController){
        self.event = event
        super.init(frame: CGRectZero)
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

        let h = NSLayoutConstraint.constraintsWithVisualFormat(vvfl,
                                                       options: [.AlignAllTop,.AlignAllBottom],
                                                       metrics: METRICS,
                                                       views: views)
        let v = NSLayoutConstraint.constraintsWithVisualFormat("V:|[back]|",
                                                              options: [],
                                                              metrics: METRICS,
                                                              views: views)
        constraints.appendContentsOf(h)
        constraints.appendContentsOf(v)
        self.addConstraints(constraints)
    }
    
}
