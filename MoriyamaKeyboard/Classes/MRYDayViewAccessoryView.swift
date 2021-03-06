//
//  MRYDayViewAccessoryView.swift
//  Moriyama
//
//  Created by Ichiro on 2016/02/10.
//  Copyright © 2016年 Ichiro. All rights reserved.
//

import UIKit

class MRYDayViewAccessoryView: UIView {
    
    fileprivate var subViews : [String: UIView] = [:]
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }
    
    // TODO: Refactoring
    init(date: Date, viewController: MRYAbstractMainViewController){
        super.init(frame: CGRect.zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let dateFormats = ["MMMdE", "MMM","d","EEEE", "Md"]
        dateFormats.forEach({
            let text = Util.string(date, format: $0 )
            let button = MRYKeyboardButton(title: text, round: 0)
            subViews[$0] = button
            self.addSubview(button)
        })
        
        
        let backButton = MRYKeyboardButton(title: NSLocalizedString("Back",comment: "Back"),
            backgroundColor: UIColor.white,
            titleColor: UIColor.blue,
            action: {viewController.popViewController()},
            round: 0)
        self.addSubview(backButton)
        subViews["back"] = backButton
        var vfl = "|[back(45)]"
        dateFormats.forEach({
            vfl += "-1-[\($0)(>=40)]"
        })
        vfl += "-1-|"
        
        let hConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: vfl,
            options: [ .alignAllTop, .alignAllBottom ] ,
            metrics: METRICS,
            views: subViews)
        self.addConstraints(hConstraints)
        
        let vConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[back]|",
            options: NSLayoutConstraint.FormatOptions(rawValue: 0) ,
            metrics: METRICS,
            views: subViews)
        self.addConstraints(vConstraints)
    }
}
