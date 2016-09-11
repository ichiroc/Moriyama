//
//  MRYEventView.swift
//  Moriyama
//
//  Created by Ichiro on 2016/01/10.
//  Copyright © 2016年 Ichiro. All rights reserved.
//

import UIKit

class MRYEventView: UIControl {

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
    
    fileprivate let mainViewController : MRYDayViewController
    fileprivate var defaultColor : UIColor?
    fileprivate var _event : MRYEvent?
    fileprivate override init(frame: CGRect) {
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
        let backgroundColor = UIColor(cgColor: event.calendar.cgColor)
        self.backgroundColor = backgroundColor
        let titleLabel = UILabel()
        titleLabel.textColor = titleColorFromBackgroundColor(backgroundColor)
        titleLabel.text = event.title
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.numberOfLines = 1
        titleLabel.lineBreakMode = .byClipping
        titleLabel.minimumScaleFactor = 0.01
        
        self.addSubview(titleLabel)
        titleLabel.sizeToFit()
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 0.5

        // Highlight if tapped.
        defaultColor = self.backgroundColor
        let tappedGesture = UITapGestureRecognizer(target: self, action:  #selector(self.tapped(_:)))
        self.addGestureRecognizer(tappedGesture)

        self.addTarget(self, action: #selector(self.doHighlight), for: .touchDown)
        self.addTarget(self, action: #selector(self.doUnhighlight), for: .touchUpInside)
        self.addTarget(self, action: #selector(self.doUnhighlight), for: .touchUpOutside)

    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.doUnhighlight()
    }
    
    fileprivate func titleColorFromBackgroundColor( _ backgroundColor: UIColor) -> UIColor {
        var red, green, blue, alpha :CGFloat
        green = 0; red = 0; blue = 0; alpha = 0
          backgroundColor.getRed(&red, green: &green , blue: &blue , alpha: &alpha)
        let bgDelta = ((red * 255 * 299) + (green * 255 *  587) + (blue * 255 * 114)) / 1000
        if bgDelta < 125 {
            return UIColor.white
        }else{
            return UIColor.black
        }
    }
    
    func doHighlight(){
        self.backgroundColor = UIColor.lightGray
    }
    
    func doUnhighlight(){
        self.backgroundColor = defaultColor
    }
    
    func tapped(_ sender: UITapGestureRecognizer){
        self.doUnhighlight()
        mainViewController.tappedEventView(_event!)
    }

    fileprivate func appendIfNotContains( _ eventView: MRYEventView, views: inout [MRYEventView]){
        if !views.contains(where: { $0.eventIdentifier == eventView.eventIdentifier }){
            views.append(eventView)
        }
    }
    
    func detectConflictedViews( _ eventViews: [MRYEventView]) -> [MRYEventView]{
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
    
    func isConflicted(_ eventView: MRYEventView) -> Bool{
        return self.frame.intersects(eventView.frame)
    }
    
}
