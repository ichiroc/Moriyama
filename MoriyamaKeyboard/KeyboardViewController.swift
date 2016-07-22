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
    
    static var sharedInstance : KeyboardViewController!
    var mainViewController : MRYAbstractMainViewController
    
    private let monthCalendarCollectionViewDataSource = MRYMonthCalendarCollectionViewDataSource()
    private var nextKeyboardButton: UIButton!
    private var views : Dictionary<String,UIView> = [:]
    private var initialized : Bool = false
    private var mainViewConstraints :[NSLayoutConstraint] = []
    private var constraintsInitialized = false
    private var deleteKeyButton : MRYKeyboardButton!
    private var currentOrientation = Orientation.Portrait
    private var timer : NSTimer?
 
    enum Orientation{
        case Landscape
        case Portrait
    }
    
    init(){
        mainViewController  = MRYMonthCalendarViewController()
        super.init(nibName: nil, bundle: nil)
        KeyboardViewController.sharedInstance = self
    }
    required init?(coder aDecoder: NSCoder) {
        mainViewController  = MRYMonthCalendarViewController()
        super.init(coder : aDecoder)
        KeyboardViewController.sharedInstance = self
    }
    override func updateViewConstraints() {
        super.updateViewConstraints()
        // Add custom view sizing constraints here
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Perform custom UI setup here
        MRYTextDocumentProxy.proxy = self.textDocumentProxy
        initUIParts()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    override func viewWillAppear(animated: Bool) {
        self.inputView?.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        initLayout()
    }

    override func viewDidAppear(animated: Bool) {
        if let calendarCollectionViewController = self.mainViewController as? MRYMonthCalendarViewController {
            calendarCollectionViewController.moveToAtIndexPath(calendarCollectionViewController.calendarCollectionView.todayIndexPath)
        }
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        // Keyboard app detect orientation only in viewDidLayoutSubviews.
        let bounds = UIScreen.mainScreen().bounds
        let previousOrientation = currentOrientation
        currentOrientation = bounds.height > bounds.width  ? .Portrait : .Landscape
        
        if currentOrientation == previousOrientation{
            return
        }

        if constraintsInitialized {
            rebuildMainViewLayout()
        }
        mainViewController.viewDidChangeOrientation(currentOrientation)
    }
    
    func longPressDeleteButton( recognizer: UILongPressGestureRecognizer){
        switch(recognizer.state){
        case .Began:
            timer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(KeyboardViewController.deleteText), userInfo: nil, repeats: true)
        case .Ended:
            deleteKeyButton.resetColor()
            timer?.invalidate()
        default:
            break
        }
    }

    func deleteText(){
       MRYTextDocumentProxy.proxy.deleteBackward()
    }
    private func initUIParts(){
        
        self.nextKeyboardButton = MRYKeyboardButton(imageFileName: "globe",
            backgroundColor: UIColor.lightGrayColor(),
            highlightedColor: UIColor.whiteColor(),
            action: { [unowned self] in self.advanceToNextInputMode() })
        let returnKeyButton = MRYKeyboardButton(
            title: "↩︎",
            text: "\n",
            highlightedColor: UIColor.whiteColor(),
            backgroundColor: UIColor.lightGrayColor()
            )
        self.deleteKeyButton = MRYKeyboardButton( title: "⌫",
            backgroundColor: UIColor.lightGrayColor(),
            highlightedColor: UIColor.whiteColor(),
            action: {[unowned self] in self.deleteText() } )
        let longPressGesture = UILongPressGestureRecognizer(target: self,
                                                            action: #selector(KeyboardViewController.longPressDeleteButton(_:)))
        self.deleteKeyButton.addGestureRecognizer(longPressGesture)

        if let mainVC = mainViewController as? MRYMonthCalendarViewController{
            MRYEventDataStore.sharedStore.loadAllEvents()
            mainVC.calendarCollectionView.reloadData()
        }
        let spaceKeyButton = MRYKeyboardButton(title: NSLocalizedString("space", comment: "space key on keyboard"), text: " ")
        let splitterSymbol = NSLocalizedString("-", comment: "Splitter symbol between start date and end date")
        let hyphenKeyButton = MRYKeyboardButton(title: splitterSymbol, text: splitterSymbol)
        let punctuationSymbol = NSLocalizedString(",", comment: "Punctuation symbol")
        let commaKeyButton = MRYKeyboardButton(title: punctuationSymbol, text: punctuationSymbol)
        
        views = [ "next": nextKeyboardButton,
            "delete": deleteKeyButton,
            "space": spaceKeyButton,
            "return": returnKeyButton,
            "comma": commaKeyButton,
            "hyphen": hyphenKeyButton,
            "main": mainViewController.view]
        
        self.inputView?.addSubview(nextKeyboardButton)
        self.inputView?.addSubview(deleteKeyButton)
        self.inputView?.addSubview(spaceKeyButton)
        self.inputView?.addSubview(returnKeyButton)
        self.inputView?.addSubview(commaKeyButton)
        self.inputView?.addSubview(hyphenKeyButton)
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

    func transientToViewController(newMainVC : MRYAbstractMainViewController){
        let currentVC = mainViewController
        currentVC.willMoveToParentViewController(nil)
        currentVC.view.removeFromSuperview()
        currentVC.removeFromParentViewController()
        currentVC.didMoveToParentViewController(nil)
        newMainVC.willMoveToParentViewController(self)
        self.addChildViewController(newMainVC)
        self.inputView?.addSubview(newMainVC.view)
        views["main"] = newMainVC.view
        
        mainViewController = newMainVC
        
        self.rebuildMainViewLayout()
        self.inputView?.layoutIfNeeded()
        newMainVC.didMoveToParentViewController(self)
    }
    
    private var allConstraints : [NSLayoutConstraint] = []
    private func rebuildConstraints(){
        NSLayoutConstraint.deactivateConstraints(allConstraints)
        allConstraints = []
        
        allConstraints.appendContentsOf(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-m_left-[next(35)]-[space]-[comma(==next)]-[hyphen(==next)]-[delete(==next)]-[return(==next)]-m_right-|",
                options: [.AlignAllCenterY, .AlignAllTop, .AlignAllBottom] ,
                metrics: METRICS,
                views: views)
        )
        self.inputView?.addConstraints( allConstraints )

        rebuildMainViewLayout()
        constraintsInitialized = true
    }
    
    private func rebuildMainViewLayout(){
        
        NSLayoutConstraint.deactivateConstraints(mainViewConstraints)
        mainViewConstraints = []
        
        let c = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-m_left-[main]-m_right-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: METRICS,
            views: views)
        mainViewConstraints.appendContentsOf(c)        
        let c2 = NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-m_top-[main]-3-[space(40)]-m_bottom-|",
                options: NSLayoutFormatOptions(rawValue: 0),
                metrics: METRICS,
                views: views)
        mainViewConstraints.appendContentsOf(c2)
        
        let height = UIScreen.mainScreen().bounds.height * 0.45
        let heightConstraint = NSLayoutConstraint(item: self.inputView!,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: nil,
            attribute: NSLayoutAttribute.NotAnAttribute,
            multiplier: 1.0,
            constant: height)
        heightConstraint.priority = 999.0
        mainViewConstraints.append(heightConstraint)
        self.inputView?.addConstraints( mainViewConstraints )
        
        self.inputView?.layoutIfNeeded()
    }

}