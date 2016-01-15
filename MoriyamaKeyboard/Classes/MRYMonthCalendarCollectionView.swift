//
//  MRYMonthCalendarCollectionView.swift
//  Moriyama
//
//  Created by Ichiro on 2015/12/27.
//  Copyright © 2015年 Ichiro. All rights reserved.
//

import UIKit

class MRYMonthCalendarCollectionView: UICollectionView,
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout{
   
    var keyboardViewController : UIViewController?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
   
    init(viewController vc: UIViewController){
        self.keyboardViewController = vc
        super.init(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
        self.registerClass(MRYMonthCalendarCollectionViewCell.self, forCellWithReuseIdentifier: "monthlyCell")
        self.translatesAutoresizingMaskIntoConstraints = false
        self.delegate = self
        self.backgroundColor = superview?.backgroundColor
        self.layer.cornerRadius = 3
    }
    
   
    // MARK: - UICollectionVieDelegate
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        let dayViewController = MRYDayViewController()
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! MRYMonthCalendarCollectionViewCell
        dayViewController.currentDate = cell.date
        keyboardViewController?.showViewController(dayViewController, sender: self)
        dayViewController.monthlyView = self
        return true
    }
    
    
    // MARK: - UICollectionViewDelegateFlowLayout methods
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            let margins = keyboardViewController?.inputView?.layoutMargins
            let screenRect = collectionView.bounds
            let screenWidth = screenRect.size.width - (margins!.left + margins!.right) - (1 * 6)
            let cellWidth = floor((screenWidth / 7.0))
            let cellSize = CGSizeMake(cellWidth, 50)
            return cellSize
    }
   
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
}
