//
//  MRYEventView.swift
//  Moriyama
//
//  Created by Ichiro on 2016/01/10.
//  Copyright © 2016年 Ichiro. All rights reserved.
//

import UIKit

class MRYEventView: UIControl {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    private let mainViewController : MRYDayViewController
    var defaultColor : UIColor?

    var _event : MRYEvent?
    var sourceEvent: MRYEvent{
        get{
            return _event!
        }
        set{
            _event = newValue
        }
    }
    
    var eventIdentifier : String {
        get{
            if let e = _event {
                return e.eventIdentifier
            }
            return ""
        }
    }
    private override init(frame: CGRect) {
        fatalError("init(frame:) is not implemented")
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }
    
    init(frame: CGRect, event: MRYEvent, viewController: MRYDayViewController){
        _event = event
        mainViewController = viewController
        super.init(frame: frame)
        
        // make color
        let backgroundColor = UIColor(CGColor: event.calendar.CGColor)
        self.backgroundColor = backgroundColor
        let titleLabel = UILabel()
        titleLabel.textColor = titleColorFromBackgroundColor(backgroundColor)
        titleLabel.text = event.title
        titleLabel.font = UIFont.systemFontOfSize(13)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.numberOfLines = 1
        titleLabel.lineBreakMode = .ByClipping
        titleLabel.minimumScaleFactor = 0.01
        
        self.addSubview(titleLabel)
        titleLabel.sizeToFit()
        self.layer.borderColor = UIColor.whiteColor().CGColor
        self.layer.borderWidth = 0.5

        // Highlight if tapped.
        defaultColor = self.backgroundColor
        let tappedGesture = UITapGestureRecognizer(target: self, action:  #selector(self.tapped(_:)))
        self.addGestureRecognizer(tappedGesture)

        self.addTarget(self, action: #selector(self.doHighlight), forControlEvents: .TouchDown)
        self.addTarget(self, action: #selector(self.doUnhighlight), forControlEvents: .TouchUpInside)
        self.addTarget(self, action: #selector(self.doUnhighlight), forControlEvents: .TouchUpOutside)

    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        self.doUnhighlight()
    }
    
    private func titleColorFromBackgroundColor( backgroundColor: UIColor) -> UIColor {
        var red, green, blue, alpha :CGFloat
        green = 0; red = 0; blue = 0; alpha = 0
          backgroundColor.getRed(&red, green: &green , blue: &blue , alpha: &alpha)
        let bgDelta = ((red * 255 * 299) + (green * 255 *  587) + (blue * 255 * 114)) / 1000
        if bgDelta < 125 {
            return UIColor.whiteColor()
        }else{
            return UIColor.blackColor()
        }
    }
    
    func doHighlight(){
        self.backgroundColor = UIColor.lightGrayColor()
    }
    
    func doUnhighlight(){
        self.backgroundColor = defaultColor
    }
    
    func tapped(sender: UITapGestureRecognizer){
        self.doUnhighlight()
        mainViewController.tappedEventView(_event!)
    }

    private func appendIfNotContains( eventView: MRYEventView, inout views: [MRYEventView]){
        if !views.contains({ $0.eventIdentifier == eventView.eventIdentifier }){
            views.append(eventView)
        }
    }
    
    func detectConflictedViews( eventViews: [MRYEventView]) -> [MRYEventView]{
        var allConflicted :[MRYEventView] = []
        eventViews.filter({
            if self.eventIdentifier == $0.eventIdentifier{ return false }
            return $0.isConflicted(self)
        }).forEach({ e1 in
            appendIfNotContains(e1, views: &allConflicted)
            eventViews.forEach({ e2 in
                if e1.isConflicted(e2) && self.eventIdentifier != e2.eventIdentifier{
                    appendIfNotContains(e2, views: &allConflicted)
                }
            })
        })
        return allConflicted
    }
    
    func isConflicted(eventView: MRYEventView) -> Bool{
        return CGRectIntersectsRect(self.frame, eventView.frame)
    }
    
}
