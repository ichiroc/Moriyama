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
    fileprivate let collectionViewDataSource = MRYMonthCalendarCollectionViewDataSource()
    fileprivate var constraints : [NSLayoutConstraint]!
    fileprivate var cellSize : CGSize?
    fileprivate var views : [String:UIView] = [:]
    fileprivate var defaultCellColor: UIColor?
    
    override init(fromViewController: MRYAbstractMainViewController?){
        calendarCollectionView = MRYMonthCalendarCollectionView()
        super.init(fromViewController: fromViewController)
    }
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        self.view.backgroundColor = UIColor.lightGray
        self.view.addSubview(calendarCollectionView)
        self.view.translatesAutoresizingMaskIntoConstraints = false
        let _numberPad = MRYMonthCalendarAccessoryView()
        self.view.addSubview(_numberPad)
        views = ["col": calendarCollectionView,
            "numberPad" : _numberPad]
        
        let noOption = NSLayoutConstraint.FormatOptions(rawValue: 0)
        let hConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-1-[col]-1-|",
            options: noOption,
            metrics: nil,
            views: views)
        self.view.addConstraints(hConstraints)
        let vConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-[numberPad(36)][col]-|",
            options: [.alignAllCenterX, .alignAllLeading, .alignAllLeading],
            metrics: nil,
            views: views)
        self.view.addConstraints(vConstraints)
        // Do any additional setup after loading the view.

        calendarCollectionView.dataSource = collectionViewDataSource
        calendarCollectionView.delegate = self
    }
    
    override func viewDidChangeOrientation(_ orientation: KeyboardViewController.Orientation) {
        cellSize = nil
        calendarCollectionView.performBatchUpdates(nil, completion: nil)
        calendarCollectionView.reloadData()
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    func moveToAtIndexPath( _ indexPath : IndexPath  ){
        calendarCollectionView.scrollToItem( at: indexPath, at: .top , animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // - MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MRYMonthCalendarCollectionViewCell

        defaultCellColor = cell.contentView.backgroundColor
        cell.contentView.backgroundColor = UIColor.lightGray

    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MRYMonthCalendarCollectionViewCell
        cell.contentView.backgroundColor = defaultCellColor
    }

    func collectionView(_ collectionView: UICollectionView,
        shouldSelectItemAt indexPath: IndexPath) -> Bool {
            let cell = collectionView.cellForItem(at: indexPath) as! MRYMonthCalendarCollectionViewCell
            let dayViewController = MRYDayViewController(date: cell.date!, fromViewController: self)
            self.pushViewController(dayViewController)
            return true
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout methods
    func collectionView(_ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
            if cellSize != nil {
                return cellSize!
            }
            let margins = calendarCollectionView.layoutMargins
            let screenRect = UIScreen.main.bounds //calendarCollectionView.bounds
            let screenWidth = screenRect.size.width - (margins.left + margins.right)
            let cellWidth = floor((screenWidth / 7.0))
            cellSize = CGSize(width: cellWidth, height: 50)
            return cellSize!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    
}
