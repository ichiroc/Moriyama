//
//  MRYMonthCalendarViewController.swift
//  Moriyama
//
//  Created by Ichiro on 2016/01/18.
//  Copyright © 2016年 Ichiro. All rights reserved.
//

import UIKit

class MRYMonthCalendarViewController: UIViewController ,
    UICollectionViewDelegate{
    let collectionView :MRYMonthCalendarCollectionView
    let collectionViewDataSource = MRYMonthCalendarCollectionViewDataSource()
    var constraints : [NSLayoutConstraint]!
    
    init(){
        collectionView = MRYMonthCalendarCollectionView()
        super.init(nibName: nil, bundle: nil)
    }
   
    required init?(coder aDecoder: NSCoder) {
        collectionView = MRYMonthCalendarCollectionView()
        super.init(coder: aDecoder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(collectionView)
        self.view.translatesAutoresizingMaskIntoConstraints = false
        let views = ["col": collectionView]
        let noOption = NSLayoutFormatOptions(rawValue: 0)
        let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-[col]-|",
            options: noOption,
            metrics: nil,
            views: views)
        self.view.addConstraints(hConstraints)
        let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-[col]-|",
            options: noOption,
            metrics: nil,
            views: views)
        self.view.addConstraints(vConstraints)
        // Do any additional setup after loading the view.

        collectionView.dataSource = collectionViewDataSource
        collectionView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - UICollectionVieDelegate
    func collectionView(collectionView: UICollectionView,
        shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
            let dayViewController = MRYDayViewController()
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! MRYMonthCalendarCollectionViewCell
            dayViewController.currentDate = cell.date
            if let keyboard = self.parentViewController as? KeyboardViewController{
                keyboard.transientToViewController(dayViewController)
            }
            return true
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout methods
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            let margins = self.view.layoutMargins
            let screenRect = collectionView.bounds
            let screenWidth = screenRect.size.width - (margins.left + margins.right) //- (1 * 6)
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
