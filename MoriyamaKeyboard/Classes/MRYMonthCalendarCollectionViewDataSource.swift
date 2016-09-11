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
    fileprivate var cal  = Calendar.current
    // TODO: make firstCellDate to computed property.
    fileprivate var _firstCellDate : Date?
    
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "monthlyCell",
                for: indexPath
                ) as! MRYMonthCalendarCollectionViewCell
            let cellDate = firstCellDate().addingTimeInterval(TimeInterval((indexPath as NSIndexPath).row * 86400))
            cell.setCellDate(cellDate)
            if cell.isToday() {
                (collectionView as! MRYMonthCalendarCollectionView ).todayIndexPath = indexPath
            }
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 134 // 120 + 14 ( +7 ) days
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    

    // コレクションビューで最初に表示すべきセル（日曜日）の NSDate を返す
    fileprivate func firstCellDate() -> Date{
        if self._firstCellDate == nil{
            var currentDateComp = (cal as NSCalendar).components( [.day, .month ,.year, .weekday, .hour, .minute, .second], from: Date())
            currentDateComp.hour = 0 // 時間はリセット
            currentDateComp.minute = 0
            currentDateComp.second = 0
            currentDateComp.day = currentDateComp.day! - 14 // TODO: Use calendarCollectionView.todayIndexPath.
            
            currentDateComp = (cal as NSCalendar).components([.day, .month ,.year, .weekday], from: cal.date(from: currentDateComp)!)
            while(currentDateComp.weekday != 1) {
                currentDateComp.day = currentDateComp.day! - 1
                currentDateComp = (cal as NSCalendar).components([.year, .month, .day, .weekday], from: cal.date(from: currentDateComp)!)
            }
            let ccal = Calendar.current.date(from: currentDateComp)
            _firstCellDate = ccal!.addingTimeInterval(0.0)
        }
        return _firstCellDate!
    }
}
