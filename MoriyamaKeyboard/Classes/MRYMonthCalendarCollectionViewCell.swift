//
//  MRYMonthCalendarCollectionViewCell.swift
//  Moriyama
//
//  Created by Ichiro on 2015/12/27.
//  Copyright © 2015年 Ichiro. All rights reserved.
//

import UIKit
import EventKit

class MRYMonthCalendarCollectionViewCell: UICollectionViewCell {
    
    enum ViewType : Int{
        case eventIndicator = 1
    }
    
    var date : Date?
    fileprivate let calendar  = Calendar.current
    fileprivate let fontSize : CGFloat = 13.0
    
    fileprivate lazy var dateLabel:UILabel = { [unowned self]  in
        var l = UILabel()
        l.font = UIFont.systemFont(ofSize: self.fontSize)
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .center
        l.text = "-" // default
        return l
    }()
    
    fileprivate lazy var eventIndicatorViewsMap : [String: UIView] = { [unowned self] in
        var m : [String:UIView] = [:]
        let l = UIView()
        l.translatesAutoresizingMaskIntoConstraints = false
        self.eventIndicator.addSubview(l)
        l.backgroundColor = l.superview?.backgroundColor
        m["leftSpacer"] = l
        
        let r = UIView()
        r.translatesAutoresizingMaskIntoConstraints = false
        self.eventIndicator.addSubview(r)
        r.backgroundColor = r.superview?.backgroundColor
        m["rightSpacer"] = r
        return m
    }()
    
    fileprivate lazy var circle : UIView = { [unowned self] in
        var c = UIView()
        c.translatesAutoresizingMaskIntoConstraints = false
        c.backgroundColor = UIColor.blue
        c.layer.cornerRadius = 11
        return c
    }()


    fileprivate lazy var views : [String:UIView] = { [unowned self] in
        return ["date": self.dateLabel,
                "eventIndicator": self.eventIndicator]
        }()
    
    fileprivate var events : [MRYEvent] {
        get {
            if let _date = date {
                return MRYEventDataStore.sharedStore.eventsOnDate(_date)
            }
            return []
        }
    }
    
    fileprivate lazy var eventIndicator = { () -> UIView in
        var v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return v
    }()
    
    
    override func prepareForReuse() {
        self.dateLabel.textColor = UIColor.black
        self.circle.removeFromSuperview()
        self.dateLabel.font = UIFont.systemFont(ofSize: fontSize)
        self.eventIndicator.subviews.forEach{
            if $0.tag == ViewType.eventIndicator.rawValue {
             $0.removeFromSuperview()
            }
        }
        super.prepareForReuse()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        let defaultMargin = self.contentView.layoutMargins
        self.contentView.layoutMargins = UIEdgeInsets(top: defaultMargin.top, left: 0, bottom: defaultMargin.bottom, right: 0)
        self.contentView.addSubview(eventIndicator)
        self.contentView.addSubview(dateLabel)
        self.backgroundColor = UIColor.white
        
        
        let eventIndicatorWidth = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[eventIndicator]-|",
            options: NSLayoutFormatOptions(rawValue: 0) ,
            metrics: nil, views: views
        )
        let dateWidth = NSLayoutConstraint.constraints(
            withVisualFormat: "H:[date]",
            options: NSLayoutFormatOptions(rawValue: 0) ,
            metrics: nil, views: views
        )
        let dateHeight = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-[date]-[eventIndicator(5)]-|",
            options: [.alignAllCenterX, ],
            metrics: nil, views: views
        )
        
        self.contentView.addConstraints(eventIndicatorWidth)
        self.contentView.addConstraints(dateWidth)
        self.contentView.addConstraints(dateHeight)

    }

    func isToday()->Bool{
        if let _date = date{
            let cellDateComp = (Calendar.current as NSCalendar).components([.year,.month,.day], from: _date)
            let today = (calendar as NSCalendar).components([.year,.month,.day], from: Date())
            return (cellDateComp.year == today.year &&
                cellDateComp.month == today.month &&
                cellDateComp.day == today.day)
        }
        return false
    }
    
    
    func setCellDate(_ cellDate: Date){
        date = cellDate
        let formatter = DateFormatter()
        let cellDateComp = (Calendar.current as NSCalendar).components([.year,.month,.day], from: cellDate)

        if cellDateComp.day == 1 {
            self.dateLabel.font = UIFont.boldSystemFont(ofSize: fontSize)
            self.dateLabel.text = Util.string(cellDate, format: "Md")
        }else{
            formatter.dateFormat = "d"
            self.dateLabel.text = formatter.string(from: cellDate)
        }
        
        let cellColor = monthlyColor(cellDate)
        self.contentView.backgroundColor = cellColor
        self.dateLabel.backgroundColor = cellColor
        
        let comp = (Calendar.current as NSCalendar).components(.weekday, from: self.date!)
        if comp.weekday == 1 {
            // Sunday
            self.dateLabel.textColor = UIColor.red
        }else if comp.weekday == 7{
            // Saturday
            self.dateLabel.textColor = UIColor.blue
        }
        buildEventIndicatorView(cellColor)
        
        dateLabel.backgroundColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0)
        if(isToday()){
            
            self.contentView.addSubview(circle)
            self.views["circle"] = circle
            self.contentView.addConstraints(
                NSLayoutConstraint.constraints(
                    withVisualFormat: "H:[circle(22)]",
                    options: NSLayoutFormatOptions.alignAllCenterY,
                    metrics: nil, views: views
                )
            )
            self.contentView.addConstraints(
                NSLayoutConstraint.constraints(
                    withVisualFormat: "V:[circle(22)]-[eventIndicator]",
                    options: NSLayoutFormatOptions.alignAllCenterX,
                    metrics: nil, views: views
                )
            )
            self.dateLabel.textColor = UIColor.white
            self.contentView.sendSubview(toBack: circle)
        }
    }
   
    fileprivate func buildEventIndicatorView(_ cellColor: UIColor) {
        eventIndicator.isOpaque = false
        eventIndicator.backgroundColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0)
        
        if events.count == 0 {
            return 
        }

        let max = events.count < 4 ? events.count : 4

        var vflArray:[String] = []
        var i : Int = 0
        
        events[0...(max - 1)].forEach({
            let v = UIView()
            v.tag = ViewType.eventIndicator.rawValue
            v.translatesAutoresizingMaskIntoConstraints = false
            v.backgroundColor = UIColor(cgColor: $0.calendar.cgColor )
            v.layer.cornerRadius = 2.5
            vflArray.append("[e\(i)(4)]")
            eventIndicatorViewsMap["e\(i)"] = v
            eventIndicator.addSubview(v)
            i += 1
        })

        self.eventIndicator.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-[e0]-|",
                options: NSLayoutFormatOptions(rawValue: 0),
                metrics: nil,
                views: eventIndicatorViewsMap ))
        
        let vfl = "|-[leftSpacer]-\(vflArray.joined(separator: "-2-"))-[rightSpacer(==leftSpacer)]-|"
        self.eventIndicator.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: vfl,
                options: [.alignAllTop, .alignAllBottom, ],
                metrics: nil,
                views: eventIndicatorViewsMap ))
    }

    fileprivate func monthlyColor(_ date: Date) -> UIColor{
        let thisMonth = (calendar as NSCalendar).component(.month, from: Date())
        var color = UIColor.white
        let cellMonth = (calendar as NSCalendar).component(.month, from: date)
        if ((cellMonth - thisMonth) % 2) != 0 {
            color = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        }
        return color
    }
    
    fileprivate func todayStyle(){
        self.dateLabel.backgroundColor = UIColor.lightGray
        self.dateLabel.layer.cornerRadius = 13
        self.dateLabel.layer.masksToBounds = true
    }
    
}
