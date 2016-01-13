//
//  MRYEventView.swift
//  Moriyama
//
//  Created by Ichiro on 2016/01/10.
//  Copyright © 2016年 Ichiro. All rights reserved.
//

import UIKit

class MRYEventView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
   
    var _event : MRYEvent?
    private let _dayViewController : MRYDayViewController
    private var hourlyHeight : CGFloat = 40.0
    
    override init(frame: CGRect) {
        _dayViewController = MRYDayViewController()
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        _dayViewController = MRYDayViewController()
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, event: MRYEvent, hourlyHeight height : CGFloat, viewController: MRYDayViewController){
        _event = event
        _dayViewController = viewController
        hourlyHeight = height
        super.init(frame: frame)
        self.backgroundColor = UIColor(CGColor: event.calendar.CGColor )
        
        // make color
        let color = UIColor(CGColor: event.calendar.CGColor)
        var red, green, blue, alpha :CGFloat
        green = 0; red = 0; blue = 0; alpha = 0
        color.getRed(&red, green: &green , blue: &blue , alpha: &alpha)
        let bgDelta = ((red * 255 * 299) + (green * 255 *  587) + (blue * 255 * 114)) / 1000
        let titleLabel = UILabel()
        titleLabel.text = event.title
        titleLabel.font = UIFont.systemFontOfSize(13)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.numberOfLines = 1
        titleLabel.lineBreakMode = .ByClipping
        titleLabel.minimumScaleFactor = 0.01
        if bgDelta < 125 {
            titleLabel.textColor = UIColor.whiteColor()
        }else{
            titleLabel.textColor = UIColor.blackColor()
        }
        
        self.addSubview(titleLabel)
        self.layer.borderColor = UIColor.whiteColor().CGColor
        self.layer.borderWidth = 0.5
        
        let gesture = UITapGestureRecognizer(target: self, action: "tapped:")
        self.addGestureRecognizer(gesture)
    }

    func tapped(sender: UITapGestureRecognizer){
        let viewController = MRYTimeDetailViewController(event: _event!)
        _dayViewController.presentViewController(viewController, animated: true, completion: nil)
    }

    func recalculateSizeAndPosition(containerWidth: CGFloat){
        if let event = _event{
            let dateComp = event.componentsOnStartDate([.Hour, .Minute])
            let top = ((CGFloat(dateComp.hour) * hourlyHeight) + (CGFloat(dateComp.minute) / 60 ) * hourlyHeight)
            let height = (CGFloat(event.duration) / 60 / 60 ) * hourlyHeight
            let conflicted = MRYEventDataStore.instance.conflictedEventsWith(event)
            frame = CGRectMake(0, CGFloat(top), containerWidth / CGFloat(conflicted.count) , height )
        }
    }
    
}
