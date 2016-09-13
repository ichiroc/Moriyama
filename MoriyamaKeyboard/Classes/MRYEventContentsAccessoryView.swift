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
        let views : [String:UIView] = ["back":backButton]
        let vvfl = "H:|[back]|"

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
