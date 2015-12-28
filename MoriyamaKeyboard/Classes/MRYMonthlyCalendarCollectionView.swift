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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
   
    init(){
        super.init(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
        self.registerClass(MRYMonthlyCalendarCollectionViewCell.self, forCellWithReuseIdentifier: "monthlyCell")
        self.translatesAutoresizingMaskIntoConstraints = false
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = UIColor.whiteColor()
    }
    
//    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        //dummy
//        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("monthlyCell", forIndexPath: indexPath) as! MRYMonthlyCalendarCollectionViewCell
//        return cell
//    }

    
    
    private func firstCellDate() -> NSDate{
        if self._firstCellDate == nil{
            var comp = cal.components( [.Day, .Month ,.Year, .Weekday], fromDate: NSDate())
            comp.day = comp.day - 30
            while(comp.weekday != 1) {
                comp.day = comp.day - 1
                comp = cal.components([.Year, .Month, .Day, .Weekday], fromDate: cal.dateFromComponents(comp)!)
            }
            let ccal = NSCalendar.currentCalendar().dateFromComponents(comp)
            _firstCellDate = ccal!.dateByAddingTimeInterval(0.0)
        }
        return _firstCellDate!
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("monthlyCell", forIndexPath: indexPath) as! MRYMonthlyCalendarCollectionViewCell
        
        let cellDate = firstCellDate().dateByAddingTimeInterval(NSTimeInterval(indexPath.row * 86400))
        cell.setDate(cellDate)
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
                let screenWidth = screenRect.size.width
                let cellWidth = floor((screenWidth / 7.0))// - 2
                cellSize = CGSizeMake(cellWidth, cellWidth * 1.1)
            }
            return cellSize!
    }
    
}
