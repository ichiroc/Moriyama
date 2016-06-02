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
    let event : MRYEvent
    let backButton = MRYKeyboardButton(title: NSLocalizedString("Back", comment: ""), text: nil, backgroundColor: nil, titleColor: UIColor.blueColor(), action: nil, round: 0)

//    var buttons : [MRYKeyboardButton] = []
    var buttons : [UIButton] = []
    let viewController: UIViewController
    init(event :MRYEvent, viewController: UIViewController){
        self.event = event
        self.viewController = viewController
        super.init(frame: CGRectZero)
        self.addSubview(backButton)
        self.translatesAutoresizingMaskIntoConstraints = false
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not implemented")
        self.event = MRYEvent(event: EKEvent())
        self.viewController = UIViewController()
        super.init(frame: CGRectZero)
    }
    
    override func layoutSubviews() {
        var constraints : [NSLayoutConstraint] = []
        var views : [String:UIView] = ["back":backButton]
        var vvfl = "H:|"
        if buttons.count == 0 {
            vvfl += "[back]"
        }else{
            vvfl += "[back(45)]"
        }

        var i = 0
        buttons.forEach({
            self.addSubview($0)
            views["b\(i)"] = $0
            vvfl += "-1-[b\(i)\( i != 0 ? "(==b0)" : "" )]"
            i += 1
        })
        vvfl+="|"
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
