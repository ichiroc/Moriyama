//
//  MRYNumberPadView.swift
//  Moriyama
//
//  Created by Ichiro on 2016/02/09.
//  Copyright © 2016年 Ichiro. All rights reserved.
//

import UIKit

class MRYNumberPadView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    var subViews : [String : UIView] = [:]
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    init(){
        super.init(frame: CGRectZero)
        self.backgroundColor = UIColor.lightGrayColor()
        self.layoutMargins = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        self.translatesAutoresizingMaskIntoConstraints = false
        for(var i = 0 ; i < 10; i++){
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
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-1-[b0]-1-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: subViews ))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "|[b1(==b0)]-1-[b2(==b0)]-1-[b3(==b0)]-1-[b4(==b0)]-1-[b5(==b0)]-1-[b6(==b0)]-1-[b7(==b0)]-1-[b8(==b0)]-1-[b9(==b0)]-1-[b0]-1-[colon(==b0)]-1-[slash(==b0)]|",
            options: [ NSLayoutFormatOptions.AlignAllCenterY, .AlignAllTop, .AlignAllBottom],
            metrics: nil,
            views: subViews ))
    }
    
}
