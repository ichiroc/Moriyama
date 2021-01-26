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
    
    fileprivate let monthCalendarCollectionViewDataSource = MRYMonthCalendarCollectionViewDataSource()
    fileprivate var nextKeyboardButton: MRYKeyboardButton!
    fileprivate var keyButtonConstraints : [NSLayoutConstraint] = []
    fileprivate var views : Dictionary<String,UIView> = [:]
    fileprivate var initialized : Bool = false
    fileprivate var mainViewConstraints :[NSLayoutConstraint] = []
    fileprivate var constraintsInitialized = false
    fileprivate var deleteKeyButton : MRYKeyboardButton!
    fileprivate var currentOrientation = Orientation.portrait
    fileprivate var timer : Timer?
 
    enum Orientation{
        case landscape
        case portrait
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.inputView?.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        initLayout()
    }

    override func viewDidAppear(_ animated: Bool) {
        if let calendarCollectionViewController = self.mainViewController as? MRYMonthCalendarViewController {
            calendarCollectionViewController.moveToAtIndexPath(calendarCollectionViewController.calendarCollectionView.todayIndexPath)
        }
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        // Keyboard app detect orientation only in viewDidLayoutSubviews.
        let bounds = UIScreen.main.bounds
        let previousOrientation = currentOrientation
        currentOrientation = bounds.height > bounds.width  ? .portrait : .landscape
        
        if currentOrientation == previousOrientation{
            return
        }

        if constraintsInitialized {
            rebuildMainViewLayout()
        }
        mainViewController.viewDidChangeOrientation(currentOrientation)
    }
    
    @objc func longPressDeleteButton( _ recognizer: UILongPressGestureRecognizer){
        switch(recognizer.state){
        case .began:
            timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(KeyboardViewController.deleteText), userInfo: nil, repeats: true)
        case .ended:
            deleteKeyButton.resetColor()
            timer?.invalidate()
        default:
            break
        }
    }

    @objc func deleteText(){
       MRYTextDocumentProxy.proxy.deleteBackward()
    }
    fileprivate func initUIParts(){
        
        self.nextKeyboardButton = MRYKeyboardButton(imageFileName: "globe",
            backgroundColor: UIColor.lightGray,
            highlightedColor: UIColor.white)

        if #available(iOSApplicationExtension 10.0, *) {
            self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        } else {
            self.nextKeyboardButton.customAction = { () in self.advanceToNextInputMode() }
        }
        
        let returnKeyButton = MRYKeyboardButton(
            title: "↩︎",
            text: "\n",
            backgroundColor: UIColor.lightGray,
            highlightedColor: UIColor.white
            )
        self.deleteKeyButton = MRYKeyboardButton( title: "⌫",
            backgroundColor: UIColor.lightGray,
            highlightedColor: UIColor.white,
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
    
    
    fileprivate func initLayout(){
        mainViewController.willMove(toParent: self)
        self.addChild(mainViewController)
        self.inputView?.addSubview(mainViewController.view)
        
        views["main"] = mainViewController.view
        // Initial layouting.
        self.rebuildConstraints()
        mainViewController.didMove(toParent: self)
    }

    func transientToViewController(_ newMainVC : MRYAbstractMainViewController){
        let currentVC = mainViewController
        currentVC.willMove(toParent: nil)
        currentVC.view.removeFromSuperview()
        currentVC.removeFromParent()
        currentVC.didMove(toParent: nil)
        newMainVC.willMove(toParent: self)
        self.addChild(newMainVC)
        self.inputView?.addSubview(newMainVC.view)
        views["main"] = newMainVC.view
        
        mainViewController = newMainVC
        
        self.rebuildMainViewLayout()
        self.inputView?.layoutIfNeeded()
        newMainVC.didMove(toParent: self)
    }
    

    fileprivate func rebuildConstraints(){
        NSLayoutConstraint.deactivate(keyButtonConstraints)
        keyButtonConstraints = []
        
        keyButtonConstraints.append(
            contentsOf: NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-m_left-[next(35)]-[space]-[comma(==next)]-[hyphen(==next)]-[delete(==next)]-[return(==next)]-m_right-|",
                options: [.alignAllCenterY, .alignAllTop, .alignAllBottom] ,
                metrics: METRICS,
                views: views)
        )
        self.inputView?.addConstraints( keyButtonConstraints )

        rebuildMainViewLayout()
        constraintsInitialized = true
    }
    
    fileprivate func rebuildMainViewLayout(){
        
        NSLayoutConstraint.deactivate(mainViewConstraints)
        mainViewConstraints = []
        
        mainViewConstraints.append(
            contentsOf: NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-m_left-[main]-m_right-|",
                options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                metrics: METRICS,
                views: views)
        )

        mainViewConstraints.append(
            contentsOf: NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-m_top-[main]-3-[space(40)]-m_bottom-|",
                options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                metrics: METRICS,
                views: views)
        )
        
        let height = UIScreen.main.bounds.height * 0.45
        let heightConstraint = NSLayoutConstraint(item: self.inputView!,
                                                  attribute: NSLayoutConstraint.Attribute.height,
                                                  relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: nil,
            attribute: NSLayoutConstraint.Attribute.notAnAttribute,
            multiplier: 1.0,
            constant: height)
        heightConstraint.priority = UILayoutPriority(rawValue: 999.0)
        mainViewConstraints.append(heightConstraint)
        self.inputView?.addConstraints( mainViewConstraints )
        self.inputView?.layoutIfNeeded()
    }

}
