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
    var currentIndexPath: NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
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
        let _numberPad = numberPad()
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
            "V:|-[numberPad(40)][col]-|",
            options: [.AlignAllCenterX, .AlignAllLeading, .AlignAllLeading],
            metrics: nil,
            views: views)
        self.view.addConstraints(vConstraints)
        // Do any additional setup after loading the view.

        calendarCollectionView.dataSource = collectionViewDataSource
        calendarCollectionView.delegate = self
        currentIndexPath = calendarCollectionView.todayIndexPath
    }
    
    override func viewDidChangeOrientation(orientation: KeyboardViewController.Orientation) {
        print("Orientation changed")
        cellSize = nil
        calendarCollectionView.performBatchUpdates(nil, completion: nil)
    }
    
    private func numberPad() -> UIView {
        let numberPad = UIView()
        numberPad.backgroundColor = UIColor.lightGrayColor()
        numberPad.layoutMargins = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        numberPad.translatesAutoresizingMaskIntoConstraints = false
        var views : [String : UIView] = [:]
        for(var i = 0 ; i < 10; i++){
            let button = MRYKeyboardButton(title: "\(i)", round: 0)
            numberPad.addSubview(button)
            views["b\(i)"] = button
        }
        
        let colonButton = MRYKeyboardButton(title: ":", round: 0)
        numberPad.addSubview(colonButton)
        views["colon"] = colonButton
        
        let slashButton = MRYKeyboardButton(title: "/", round: 0)
        numberPad.addSubview(slashButton)
        views["slash"] = slashButton
        
        numberPad.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-1-[b0]-1-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: views ))
        numberPad.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "|[b0]-1-[b1(==b0)]-1-[b2(==b0)]-1-[b3(==b0)]-1-[b4(==b0)]-1-[b5(==b0)]-1-[b6(==b0)]-1-[b7(==b0)]-1-[b8(==b0)]-1-[b9(==b0)]-1-[colon(==b0)]-1-[slash(==b0)]|",
            options: [ NSLayoutFormatOptions.AlignAllCenterY, .AlignAllTop, .AlignAllBottom],
            metrics: nil,
            views: views ))
        return numberPad
    }

    override func viewDidAppear(animated: Bool) {
        self.moveToAtIndexPath(currentIndexPath)
        super.viewDidAppear(animated)
    }
    private func moveToAtIndexPath( indexPath : NSIndexPath  ){
        calendarCollectionView.scrollToItemAtIndexPath( indexPath, atScrollPosition: .CenteredVertically, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - UICollectionVieDelegate
    func collectionView(collectionView: UICollectionView,
        shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
            currentIndexPath = indexPath
            let dayViewController = MRYDayViewController(fromViewController: self)
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! MRYMonthCalendarCollectionViewCell
            dayViewController.currentDate = cell.date
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
            let screenRect = calendarCollectionView.bounds
            let screenWidth = screenRect.size.width - (margins.left + margins.right) // - (MARGIN_LEFT + MARGIN_RIGHT) // - (1 * 6)
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
