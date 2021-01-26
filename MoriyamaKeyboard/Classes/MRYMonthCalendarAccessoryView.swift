//
//  MRYMonthCalendarAccessoryView.swift
//  Moriyama
//
//  Created by Ichiro on 2016/02/09.
//  Copyright © 2016年 Ichiro. All rights reserved.
//

import UIKit

class MRYMonthCalendarAccessoryView : UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    fileprivate var subViews : [String : UIView] = [:]
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }
    
    init(){
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.lightGray
        self.layoutMargins = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        self.translatesAutoresizingMaskIntoConstraints = false
        for i in 0  ..< 10 {
            let button = MRYKeyboardButton(title: "\(i)", round: 0)
            self.addSubview(button)
            subViews["b\(i)"] = button
        }
        
        let colonButton = MRYKeyboardButton(title: ":", round: 0)
        self.addSubview(colonButton)
        subViews["colon"] = colonButton
        
        let slashButton = MRYKeyboardButton(title: "/", round: 0)
        self.addSubview(slashButton)
        subViews["slash"] = slashButton
        
        self.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-1-[b0]-1-|",
                                options: NSLayoutConstraint.FormatOptions(rawValue: 0),
            metrics: nil,
            views: subViews ))
        self.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "|[b1(==b0)]-1-[b2(==b0)]-1-[b3(==b0)]-1-[b4(==b0)]-1-[b5(==b0)]-1-[b6(==b0)]-1-[b7(==b0)]-1-[b8(==b0)]-1-[b9(==b0)]-1-[b0]-1-[colon(==b0)]-1-[slash(==b0)]|",
                                options: [ NSLayoutConstraint.FormatOptions.alignAllCenterY, .alignAllTop, .alignAllBottom],
            metrics: nil,
            views: subViews ))
    }
    
}
