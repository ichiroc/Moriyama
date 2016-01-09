//
//  MRYMonthlyCalendarCollectionViewCell.swift
//  Moriyama
//
//  Created by Ichiro on 2015/12/27.
//  Copyright © 2015年 Ichiro. All rights reserved.
//

import UIKit
import EventKit

class MRYMonthlyCalendarCollectionViewCell: UICollectionViewCell {
    var dateLabel:UILabel
    let cal  = NSCalendar.currentCalendar()
    var date : NSDate?
    var events : [EKEvent] = []
    let eventIndicator = UIView()
    override func prepareForReuse() {
        self.dateLabel.backgroundColor = UIColor.whiteColor()
        self.dateLabel.layer.cornerRadius = 0
        self.dateLabel.textColor = UIColor.blackColor()
        dateLabel.font = UIFont.systemFontOfSize(12)
        super.prepareForReuse()
    }
    
    required init?(coder aDecoder: NSCoder) {
        dateLabel = UILabel()
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        dateLabel = UILabel()
        super.init(frame: frame)
        self.contentView.addSubview(dateLabel)
        self.contentView.addSubview(eventIndicator)
        eventIndicator.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont.systemFontOfSize(12)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false

       self.backgroundColor = UIColor.whiteColor()
        
        let views = ["date": dateLabel,
        "events": eventIndicator]
        let dateWidth = NSLayoutConstraint.constraintsWithVisualFormat(
            "|-[date]-|",
            options: NSLayoutFormatOptions(rawValue: 0) ,
            metrics: nil, views: views
        )
        let dateHeight = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-[date]-[events(5)]-|",
            options: [.AlignAllCenterX, .AlignAllLeading, .AlignAllTrailing],
            metrics: nil, views: views
        )
        
        self.addConstraints(dateWidth)
        self.addConstraints(dateHeight)
        self.dateLabel.textAlignment = .Center
        self.dateLabel.text = "-"
    }

    func isToday()->Bool{
        if let _date = date{
            let cellDateComp = NSCalendar.currentCalendar().components([.Year,.Month,.Day], fromDate: _date)
            let today = cal.components([.Year,.Month,.Day], fromDate: NSDate())
            return (cellDateComp.year == today.year &&
                cellDateComp.month == today.month &&
                cellDateComp.day == today.day)
        }
        return false
    }
    
    
    func setCellDate(cellDate: NSDate){
        date = cellDate
        let formatter = NSDateFormatter()
        let cellDateComp = NSCalendar.currentCalendar().components([.Year,.Month,.Day], fromDate: cellDate)

        if cellDateComp.day == 1 {
            formatter.dateFormat = "M/d"
            self.dateLabel.font = UIFont.boldSystemFontOfSize(12)
        }else{
            formatter.dateFormat = "d"
        }
        let cellColor = monthlyColor(cellDate)
        self.contentView.backgroundColor = cellColor
        self.dateLabel.backgroundColor = cellColor
        if(isToday()){
            self.dateLabel.backgroundColor = UIColor.lightGrayColor()
            self.dateLabel.layer.cornerRadius = 13
            self.dateLabel.layer.masksToBounds = true
        }
        
        let comp = NSCalendar.currentCalendar().components(.Weekday, fromDate: self.date!)
        if comp.weekday == 1 {
            self.dateLabel.textColor = UIColor.redColor()
        }else if comp.weekday == 7{
            self.dateLabel.textColor = UIColor.blueColor()
        }
        events = retriveEvent( cellDate )
        events.map{
            eventIndicator.backgroundColor = UIColor(CGColor: $0.calendar.CGColor )
        }
        
        self.dateLabel.text = formatter.stringFromDate(cellDate)
    }
    
    private func monthlyColor(date: NSDate) -> UIColor{
        let thisMonth = cal.component(.Month, fromDate: NSDate())
        var color = UIColor.whiteColor()
        let cellMonth = cal.component(.Month, fromDate: date)
        if ((cellMonth - thisMonth) % 2) != 0 {
            color = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        }
        return color
    }
    
    private func retriveEvent(date: NSDate) -> [EKEvent]{
        let store = MRYEventDataStore.singleton()
        return store.eventWithDate(date)
    }
    
    private func todayStyle(){
        self.dateLabel.backgroundColor = UIColor.lightGrayColor()
        self.dateLabel.layer.cornerRadius = 13
        self.dateLabel.layer.masksToBounds = true
    }
    
}
