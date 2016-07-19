//
//  MRYMonthCalendarCollectionView.swift
//  Moriyama
//
//  Created by Ichiro on 2015/12/27.
//  Copyright © 2015年 Ichiro. All rights reserved.
//

import UIKit

class MRYMonthCalendarCollectionView: UICollectionView,
    UICollectionViewDelegateFlowLayout{
   
    var todayIndexPath : NSIndexPath = NSIndexPath(forRow: 60, inSection: 0)
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
   
    init(){
        super.init(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
        self.registerClass(MRYMonthCalendarCollectionViewCell.self, forCellWithReuseIdentifier: "monthlyCell")
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = superview?.backgroundColor
        self.layer.cornerRadius = 3
    }
    
}
