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
    var _cellDate : NSDate?
    
    override func prepareForReuse() {
        self.dateLabel.backgroundColor = UIColor.whiteColor()
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
        let c1 = NSLayoutConstraint.constraintsWithVisualFormat("|-[date]-|", options: NSLayoutFormatOptions(rawValue: 0) , metrics: nil, views: views )
        let c2 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[date]-|", options:NSLayoutFormatOptions(rawValue: 0)  , metrics: nil, views: views )

        self.addConstraints(c1)
        self.addConstraints(c2)
        self.dateLabel.textAlignment = .Center
        self.dateLabel.text = "-"
    }

    func isToday()->Bool{
        if let _date = _cellDate{
            let cellDateComp = NSCalendar.currentCalendar().components([.Year,.Month,.Day], fromDate: _date)
            let today = cal.components([.Year,.Month,.Day], fromDate: NSDate())
            return(cellDateComp.year == today.year &&
                cellDateComp.month == today.month &&
                cellDateComp.day == today.day)
        }
        return false
    }
    
        
        
    func setDate(cellDate: NSDate){
        _cellDate = cellDate
        let formatter = NSDateFormatter()
        let cellDateComp = NSCalendar.currentCalendar().components([.Year,.Month,.Day], fromDate: cellDate)
        if cellDateComp.day == 1 {
            formatter.dateFormat = "M/d"
        }else{
            formatter.dateFormat = "d"
        }
        if(isToday()){
            self.dateLabel.backgroundColor = UIColor.lightGrayColor()
        }
        self.dateLabel.text = formatter.stringFromDate(cellDate)
    }
    
    
    
}
