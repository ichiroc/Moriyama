//
//  MRYMonthCalendarCollectionViewDataSource.swift
//  Moriyama
//
//  Created by Ichiro on 2016/01/15.
//  Copyright © 2016年 Ichiro. All rights reserved.
//

import UIKit

class MRYMonthCalendarCollectionViewDataSource: NSObject,
    UICollectionViewDataSource{
    private var cal  = NSCalendar.currentCalendar()
    private var _firstCellDate : NSDate?
    
    // MARK: - UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
                "monthlyCell",
                forIndexPath: indexPath
                ) as! MRYMonthCalendarCollectionViewCell
            let cellDate = firstCellDate().dateByAddingTimeInterval(NSTimeInterval(indexPath.row * 86400))
            cell.setCellDate(cellDate)
            if cell.isToday() {
                (collectionView as! MRYMonthCalendarCollectionView ).todayIndexPath = indexPath
            }
            return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 120
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    

    // コレクションビューで最初に表示すべきセル（日曜日）の NSDate を返す
    private func firstCellDate() -> NSDate{
        if self._firstCellDate == nil{
            var currentDateComp = cal.components( [.Day, .Month ,.Year, .Weekday, .Hour, .Minute, .Second], fromDate: NSDate())
            currentDateComp.hour = 0 // 時間はリセット
            currentDateComp.minute = 0
            currentDateComp.second = 0
            currentDateComp.day = currentDateComp.day - 14 // TODO: Use calendarCollectionView.todayIndexPath.
            
            currentDateComp = cal.components([.Day, .Month ,.Year, .Weekday], fromDate: cal.dateFromComponents(currentDateComp)!)
            while(currentDateComp.weekday != 1) {
                currentDateComp.day = currentDateComp.day - 1
                currentDateComp = cal.components([.Year, .Month, .Day, .Weekday], fromDate: cal.dateFromComponents(currentDateComp)!)
            }
            let ccal = NSCalendar.currentCalendar().dateFromComponents(currentDateComp)
            _firstCellDate = ccal!.dateByAddingTimeInterval(0.0)
        }
        return _firstCellDate!
    }
}
