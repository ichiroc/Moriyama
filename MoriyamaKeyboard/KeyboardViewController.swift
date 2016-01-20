//
//  KeyboardviewController.swift
//  MoriyamaKeyboard
//
//  Created by Ichiro on 2015/12/25.
//  Copyright © 2015年 Ichiro. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController ,
    UICollectionViewDelegate{

    @IBOutlet var nextKeyboardButton: UIButton!
    var calendarView : MRYMonthCalendarCollectionView!
    var prevViewController : UIViewController?
    var mainViewController : UIViewController = MRYMonthCalendarViewController()
    let monthCalendarCollectionViewDataSource = MRYMonthCalendarCollectionViewDataSource()
    let margins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    private var views : Dictionary<String,UIView> = [:]
    private var initialized : Bool = false
    
    var currentOrientation = Orientation.Portrait
    override func updateViewConstraints() {
        super.updateViewConstraints()
    
        // Add custom view sizing constraints here
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Perform custom UI setup here
        MRYTextDocumentProxy.proxy = self.textDocumentProxy
        initUIParts()
        initLayout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    override func viewWillAppear(animated: Bool) {
        if let _todayIndexPath = monthCalendarCollectionViewDataSource.todayIndexPath {
            calendarView.scrollToItemAtIndexPath( _todayIndexPath, atScrollPosition: .Top, animated: false)
        }
    }

    override func textWillChange(textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    override func viewDidLayoutSubviews() {
        let bounds = UIScreen.mainScreen().bounds
        let previousOrientation = currentOrientation
        if bounds.height > bounds.width {
            currentOrientation = Orientation.Portrait
        }else{
            currentOrientation = Orientation.Landscape
        }
        if currentOrientation != previousOrientation{
            calendarView.performBatchUpdates(nil, completion: nil)
        }
    }

    override func viewWillLayoutSubviews() {
        self.inputView?.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    override func textDidChange(textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
    
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.Dark {
            textColor = UIColor.whiteColor()
        } else {
            textColor = UIColor.blackColor()
        }
        self.nextKeyboardButton.setTitleColor(textColor, forState: .Normal)
    }

    private func initUIParts(){
        
        self.nextKeyboardButton = MRYKeyboardButton(
            title: "🌐",
            backgroundColor: UIColor.lightGrayColor(),
            action: { self.advanceToNextInputMode() })
        let returnKey = MRYKeyboardButton(
            title: "↩︎",
            text: "\n",
            backgroundColor: UIColor.blueColor(),
            titleColor: UIColor.whiteColor())
        let deleteKey = MRYKeyboardButton( title: "⌫",
            backgroundColor: UIColor.lightGrayColor(),
            action: {() -> Void in MRYTextDocumentProxy.proxy.deleteBackward()} )

        let spaceKey = MRYKeyboardButton(title: "space", text: " ")
        let commaKey = MRYKeyboardButton(title: ",", text: ",")
        
        views = [ "next": nextKeyboardButton,
            "delete": deleteKey,
            "space": spaceKey,
            "return": returnKey ,
            "comma": commaKey,
            "main": mainViewController.view]
        
        self.inputView?.addSubview(nextKeyboardButton)
        self.inputView?.addSubview(deleteKey)
        self.inputView?.addSubview(spaceKey)
        self.inputView?.addSubview(returnKey)
        self.inputView?.addSubview(commaKey)
    }
    
    private func initLayout(){
        mainViewController.willMoveToParentViewController(self)
        self.addChildViewController(mainViewController)
        self.inputView?.addSubview(mainViewController.view)
        
        views["main"] = mainViewController.view
        // Initial layouting.
        self.rebuildConstraints()
        mainViewController.didMoveToParentViewController(self)
    }
    
//    private func performTransitionFromViewController(toViewController newMainVC: UIViewController) {
    func transientToViewController3(newMainVC : UIViewController){
        let currentVC = mainViewController
        currentVC.willMoveToParentViewController(nil)
        self.addChildViewController(newMainVC)
        self.inputView?.addSubview(newMainVC.view)
        // TODO: set initial layout constraints here
        
        let width = currentVC.view.bounds.size.width
        let height = currentVC.view.bounds.size.height
        newMainVC.view.frame = CGRectMake(0,height,width,height)
        

        self.inputView?.layoutIfNeeded()
        UIView.animateWithDuration(0.25,
            delay: 0,
            options: UIViewAnimationOptions.TransitionCurlUp ,
            animations: {() -> Void in
                // TODO: set final layout constraints here
                self.views["main"] = newMainVC.view
                self.mainViewController = newMainVC
                self.rebuildConstraints()
                self.inputView?.layoutIfNeeded()
            }, completion: {(finished: Bool) -> Void in
                newMainVC.didMoveToParentViewController(self)
                currentVC.view.removeFromSuperview()
                currentVC.removeFromParentViewController()
                self.prevViewController = currentVC
        })
    }
    
    func transientToViewController(newMainVC : UIViewController){
//        let currentVC = mainViewController
//        currentVC.willMoveToParentViewController(nil)
//        views["main"] = newMainVC.view
//        newMainVC.willMoveToParentViewController(self)
//        self.addChildViewController(newMainVC)
//        let width = currentVC.view.bounds.size.width
//        let height = currentVC.view.bounds.size.height
//        self.inputView?.addSubview(newMainVC.view)
//        newMainVC.view.frame = CGRectMake(0,height,width,height)
        let currentVC = mainViewController
        currentVC.willMoveToParentViewController(nil)
        self.addChildViewController(newMainVC)
        self.inputView?.addSubview(newMainVC.view)
        // TODO: set initial layout constraints here
        
        let width = currentVC.view.bounds.size.width
        let height = currentVC.view.bounds.size.height
        newMainVC.view.frame = CGRectMake(0,height,width,height)
        self.transitionFromViewController(
            currentVC,
            toViewController: newMainVC,
            duration: 1.0,
            options: UIViewAnimationOptions(rawValue: 0) ,
            animations: {
                self.views["main"] = newMainVC.view
                self.mainViewController = newMainVC
                self.rebuildConstraints()
                self.inputView?.layoutIfNeeded()
//                self.rebuildConstraints()
            },
            completion: { (success : Bool) in
//                print("OK")
//                newMainVC.didMoveToParentViewController(self)
//                currentVC.view.removeFromSuperview()
//                currentVC.removeFromParentViewController()
//                currentVC.didMoveToParentViewController(nil)
                
                currentVC.view.removeFromSuperview()
                currentVC.removeFromParentViewController()
                self.prevViewController = currentVC
                
        })
        
    }
    

    func transientToViewController2(newMainVC : UIViewController){
        let currentVC = mainViewController
        currentVC.willMoveToParentViewController(nil)
        currentVC.view.removeFromSuperview()
        
        newMainVC.willMoveToParentViewController(self)
        self.addChildViewController(newMainVC)
        self.inputView?.addSubview(newMainVC.view)
        views["main"] = newMainVC.view
        
        mainViewController = newMainVC
        
        self.rebuildConstraints()
        newMainVC.didMoveToParentViewController(self)
        currentVC.removeFromParentViewController()
        currentVC.didMoveToParentViewController(nil)
        prevViewController = currentVC
    }

    private func rebuildConstraints(){
        
        let metrics = [ "left": margins.left, "right": margins.right, "margin": margins.left ]
//        self.inputView?.constraints.forEach({ $0.active = false })
        
        self.inputView?.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-margin-[next(35)]-[space]-[comma(==next)]-[delete(==next)]-[return(==next)]-margin-|",
                options: [.AlignAllCenterY, .AlignAllTop, .AlignAllBottom] ,
                metrics: metrics,
                views: views)
        )

        self.inputView?.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-margin-[main]-margin-|",
                options: NSLayoutFormatOptions(rawValue: 0),
                metrics: metrics,
                views: views)
        )
        
        self.inputView?.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-[main(>=250@200)]-5-[space(40)]-5-|",
                options: NSLayoutFormatOptions(rawValue: 0),
                metrics: metrics,
                views: views)
        )
//        self.inputView?.setNeedsLayout()
//        self.inputView?.layoutIfNeeded()
        
    }
    
//    private func layoutSubviews(){
//        // Perform custom UI setup here
//        self.nextKeyboardButton = MRYKeyboardButton(title: "🌐", backgroundColor: UIColor.lightGrayColor(),action: { self.advanceToNextInputMode() })
//        let returnKey = MRYKeyboardButton(title: "↩︎", text: "\n", backgroundColor: UIColor.blueColor(), titleColor: UIColor.whiteColor())
//        let deleteKey = MRYKeyboardButton( title: "⌫",
//            backgroundColor: UIColor.lightGrayColor(),
//            action: {() -> Void in MRYTextDocumentProxy.proxy.deleteBackward()} )
//
//        let spaceKey = MRYKeyboardButton(title: "space", text: " ")
//        let commaKey = MRYKeyboardButton(title: ",", text: ",")
//        calendarView = MRYMonthCalendarCollectionView()
//        calendarView.dataSource = monthCalendarCollectionViewDataSource
//        calendarView.delegate = self
//        let views = [ "next": nextKeyboardButton,
//            "delete": deleteKey,
//            "space": spaceKey,
//            "return": returnKey ,
//            "comma": commaKey,
//            "calendar": calendarView]
//        
//        self.inputView?.addSubview(nextKeyboardButton)
//        self.inputView?.addSubview(deleteKey)
//        self.inputView?.addSubview(spaceKey)
//        self.inputView?.addSubview(returnKey)
//        self.inputView?.addSubview(commaKey)
//        self.inputView?.addSubview(calendarView)
//        
//        let metrics = [ "left": margins.left, "right": margins.right, "margin": margins.left ]
//        
//        self.inputView?.addConstraints(
//            NSLayoutConstraint.constraintsWithVisualFormat(
//                "H:|-margin-[next(35)]-[space]-[comma(==next)]-[delete(==next)]-[return(==next)]-margin-|",
//                options: [.AlignAllCenterY, .AlignAllTop, .AlignAllBottom] ,
//                metrics: metrics,
//                views: views)
//        )
//
//        self.inputView?.addConstraints(
//            NSLayoutConstraint.constraintsWithVisualFormat(
//                "H:|-margin-[calendar]-margin-|",
//                options: NSLayoutFormatOptions(rawValue: 0),
//                metrics: metrics,
//                views: views)
//        )
//        
//        self.inputView?.addConstraints(
//            NSLayoutConstraint.constraintsWithVisualFormat(
//                "V:|-[calendar(>=250@200)]-5-[space(40)]-5-|",
//                options: NSLayoutFormatOptions(rawValue: 0),
//                metrics: metrics,
//                views: views)
//        )
//        
//    }
//    
//    // MARK: - UICollectionVieDelegate
//    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
//        let dayViewController = MRYDayViewController()
//        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! MRYMonthCalendarCollectionViewCell
//        dayViewController.currentDate = cell.date
//        self.showViewController(dayViewController, sender: self)
//        return true
//    }
//    
//    // MARK: - UICollectionViewDelegateFlowLayout methods
//    func collectionView(collectionView: UICollectionView,
//        layout collectionViewLayout: UICollectionViewLayout,
//        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//            let margins = self.inputView?.layoutMargins
//            let screenRect = collectionView.bounds
//            let screenWidth = screenRect.size.width - (margins!.left + margins!.right) - (1 * 6)
//            let cellWidth = floor((screenWidth / 7.0))
//            let cellSize = CGSizeMake(cellWidth, 50)
//            return cellSize
//    }
//
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
//        return 1
//    }
//    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
//        return 1
//    }
    enum Orientation{
        case Landscape
        case Portrait
    }
    
}