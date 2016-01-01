//
//  MRYMonthlyCalendarCollectionViewCell.swift
//  Moriyama
//
//  Created by Ichiro on 2015/12/27.
//  Copyright © 2015年 Ichiro. All rights reserved.
//

import UIKit

class MRYMonthlyCalendarCollectionViewCell: UICollectionViewCell {
    var dateLabel:UILabel
    let cal  = NSCalendar.currentCalendar()
    var date : NSDate?
    
    override func prepareForReuse() {
        self.dateLabel.backgroundColor = UIColor.whiteColor()
        self.dateLabel.layer.cornerRadius = 0
        self.dateLabel.textColor = UIColor.blackColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        dateLabel = UILabel()
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        dateLabel = UILabel()
        super.init(frame: frame)
        self.addSubview(dateLabel)
        dateLabel.font = UIFont.systemFontOfSize(12)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false

       self.backgroundColor = UIColor.whiteColor()
        
        let views = ["date": dateLabel]
        let dateWidth = NSLayoutConstraint.constraintsWithVisualFormat(
            "|-[date]-|",
            options: NSLayoutFormatOptions(rawValue: 0) ,
            metrics: nil, views: views
        )
        let dateHeight = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-[date]-|",
            options:NSLayoutFormatOptions(rawValue: 0)  ,
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
        }else{
            formatter.dateFormat = "d"
        }
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
        
        self.dateLabel.text = formatter.stringFromDate(cellDate)
    }
    
    
    private func todayStyle(){
        self.dateLabel.backgroundColor = UIColor.lightGrayColor()
        self.dateLabel.layer.cornerRadius = 13
        self.dateLabel.layer.masksToBounds = true
    }
    
}
