//
//  MRYMonthCalendarViewController.swift
//  Moriyama
//
//  Created by Ichiro on 2016/01/18.
//  Copyright © 2016年 Ichiro. All rights reserved.
//

import UIKit

class MRYMonthCalendarViewController: MRYAbstractMainViewController ,
    UICollectionViewDelegate{
    let calendarCollectionView :MRYMonthCalendarCollectionView
    let collectionViewDataSource = MRYMonthCalendarCollectionViewDataSource()
    var constraints : [NSLayoutConstraint]!
    var cellSize : CGSize?
    var views : [String:UIView] = [:]
    
    override init(fromViewController: MRYAbstractMainViewController?){
        calendarCollectionView = MRYMonthCalendarCollectionView()
        super.init(fromViewController: fromViewController)
    }
   
    required init?(coder aDecoder: NSCoder) {
        calendarCollectionView = MRYMonthCalendarCollectionView()
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        self.view.backgroundColor = UIColor.lightGrayColor()
        self.view.addSubview(calendarCollectionView)
        self.view.translatesAutoresizingMaskIntoConstraints = false
        let _numberPad = MRYMonthCalendarAccessoryView()
        self.view.addSubview(_numberPad)
        views = ["col": calendarCollectionView,
            "numberPad" : _numberPad]
        
        let noOption = NSLayoutFormatOptions(rawValue: 0)
        let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-1-[col]-1-|",
            options: noOption,
            metrics: nil,
            views: views)
        self.view.addConstraints(hConstraints)
        let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-[numberPad(36)][col]-|",
            options: [.AlignAllCenterX, .AlignAllLeading, .AlignAllLeading],
            metrics: nil,
            views: views)
        self.view.addConstraints(vConstraints)
        // Do any additional setup after loading the view.

        calendarCollectionView.dataSource = collectionViewDataSource
        calendarCollectionView.delegate = self
    }
    
    override func viewDidChangeOrientation(orientation: KeyboardViewController.Orientation) {
        cellSize = nil
        calendarCollectionView.performBatchUpdates(nil, completion: nil)
        calendarCollectionView.reloadData()
    }
    

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    func moveToAtIndexPath( indexPath : NSIndexPath  ){
        calendarCollectionView.scrollToItemAtIndexPath( indexPath, atScrollPosition: .Top , animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var defaultCellColor: UIColor?
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! MRYMonthCalendarCollectionViewCell

        defaultCellColor = cell.contentView.backgroundColor
        cell.contentView.backgroundColor = UIColor.lightGrayColor()

    }
    
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! MRYMonthCalendarCollectionViewCell
        cell.contentView.backgroundColor = defaultCellColor
    }

    // MARK: - UICollectionVieDelegate
    func collectionView(collectionView: UICollectionView,
        shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! MRYMonthCalendarCollectionViewCell
            let dayViewController = MRYDayViewController(date: cell.date!, fromViewController: self)
            self.pushViewController(dayViewController)
            return true
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout methods
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            if cellSize != nil {
                return cellSize!
            }
            let margins = calendarCollectionView.layoutMargins
            let screenRect = UIScreen.mainScreen().bounds //calendarCollectionView.bounds
            let screenWidth = screenRect.size.width - (margins.left + margins.right)
            let cellWidth = floor((screenWidth / 7.0))
            cellSize = CGSizeMake(cellWidth, 50)
            return cellSize!
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    
}
