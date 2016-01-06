//
//  MRYMonthlyCalendarCollectionView.swift
//  Moriyama
//
//  Created by Ichiro on 2015/12/27.
//  Copyright © 2015年 Ichiro. All rights reserved.
//

import UIKit

class MRYMonthlyCalendarCollectionView: UICollectionView,
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout{
   
    private var _firstCellDate : NSDate?
    private var cal  = NSCalendar.currentCalendar()
    private var cellSize : CGSize?
    private let _isToday = false
    var todayIndexPath : NSIndexPath?
    var viewController : UIViewController?
    var dayViewController : MRYDayViewController?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
   
    init(viewController vc: UIViewController){
        self.viewController = vc
        super.init(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
        self.registerClass(MRYMonthlyCalendarCollectionViewCell.self, forCellWithReuseIdentifier: "monthlyCell")
        self.translatesAutoresizingMaskIntoConstraints = false
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = superview?.backgroundColor
        self.layer.cornerRadius = 3
    }
    
    func dismissDayViewController(){
        dayViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
   
    // コレクションビューで最初に表示すべきセル（日曜日）の NSDate を返す
    private func firstCellDate() -> NSDate{
        if self._firstCellDate == nil{
            var currentDateComp = cal.components( [.Day, .Month ,.Year, .Weekday, .Hour, .Minute, .Second], fromDate: NSDate())
            currentDateComp.hour = 0 // 時間はリセット
            currentDateComp.minute = 0
            currentDateComp.second = 0
            currentDateComp.day = currentDateComp.day - 30
            
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
    
    // MARK: - UICollectionVieDelegate
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        dayViewController = MRYDayViewController()
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! MRYMonthlyCalendarCollectionViewCell
        dayViewController?.currentDate = cell.date
        viewController?.showViewController(dayViewController!, sender: self)
        dayViewController?.monthlyView = self
        return true
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
                "monthlyCell",
                forIndexPath: indexPath
                ) as! MRYMonthlyCalendarCollectionViewCell
            
            let cellDate = firstCellDate().dateByAddingTimeInterval(NSTimeInterval(indexPath.row * 86400))
            cell.setCellDate(cellDate)
            if cell.isToday() {
                todayIndexPath = indexPath
            }
            return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    
    // MARK: - UICollectionViewDelegateFlowLayout methods
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            if( cellSize == nil){
                let screenRect = collectionView.bounds
                let screenWidth = screenRect.size.width - 16 - (1 * 6)
                let cellWidth = floor((screenWidth / 7.0))
                cellSize = CGSizeMake(cellWidth, cellWidth * 1.1)
            }
            return cellSize!
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
//    }
    
}
