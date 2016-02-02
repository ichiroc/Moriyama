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
    static var instance : KeyboardViewController!
    var mainViewController : MRYAbstractMainViewController
    let monthCalendarCollectionViewDataSource = MRYMonthCalendarCollectionViewDataSource()
    private var views : Dictionary<String,UIView> = [:]
    private var initialized : Bool = false
    private var mainViewConstraints :[NSLayoutConstraint] = []
    private var constraintsInitialized = false
    var currentOrientation = Orientation.Portrait
 
    enum Orientation{
        case Landscape
        case Portrait
    }
    
    init(){
        mainViewController  = MRYMonthCalendarViewController()
        super.init(nibName: nil, bundle: nil)
        KeyboardViewController.instance = self
    }
    required init?(coder aDecoder: NSCoder) {
        mainViewController  = MRYMonthCalendarViewController()
        super.init(coder : aDecoder)
        KeyboardViewController.instance = self
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

    override func viewDidLayoutSubviews() {
        let bounds = UIScreen.mainScreen().bounds
        let previousOrientation = currentOrientation
        if bounds.height > bounds.width {
            currentOrientation = Orientation.Portrait
        }else{
            currentOrientation = Orientation.Landscape
        }
        if currentOrientation != previousOrientation{
            // TODO: Add orientation changing.
            if constraintsInitialized {
                rebuildMainView()
            }
            mainViewController.viewDidChangeOrientation(currentOrientation)
        }
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
        let hyphenKey = MRYKeyboardButton(title: "-", text: "-")
        let commaKey = MRYKeyboardButton(title: ",", text: ",")
        
        views = [ "next": nextKeyboardButton,
            "delete": deleteKey,
            "space": spaceKey,
            "return": returnKey,
            "comma": commaKey,
            "hyphen": hyphenKey,
            "main": mainViewController.view]
        
        self.inputView?.addSubview(nextKeyboardButton)
        self.inputView?.addSubview(deleteKey)
        self.inputView?.addSubview(spaceKey)
        self.inputView?.addSubview(returnKey)
        self.inputView?.addSubview(commaKey)
        self.inputView?.addSubview(hyphenKey)
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
        self.addChildViewController(newMainVC)
        self.inputView?.addSubview(newMainVC.view)
        // TODO: set initial layout constraints here
        
        let width = currentVC.view.bounds.size.width
        let height = currentVC.view.bounds.size.height
        newMainVC.view.frame = CGRectMake(MARGIN_LEFT,-height,width,height)
        
        self.inputView?.layoutIfNeeded()
        UIView.animateWithDuration(0.25,
            delay: 0,
            options: UIViewAnimationOptions.TransitionNone ,
            animations: {() -> Void in
                // TODO: set final layout constraints here
                self.views["main"] = newMainVC.view
                self.mainViewController = newMainVC
                self.rebuildMainView()
                self.inputView?.layoutIfNeeded()
            }, completion: {(finished: Bool) -> Void in
                newMainVC.didMoveToParentViewController(self)
                currentVC.view.removeFromSuperview()
                currentVC.removeFromParentViewController()
        })
    }
    

    func transientToViewControllerWithNoAnimation(newMainVC : MRYAbstractMainViewController){
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
        
        self.rebuildMainView()
        self.inputView?.layoutIfNeeded()
        newMainVC.didMoveToParentViewController(self)
//        prevViewController = currentVC
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

        rebuildMainView()
        constraintsInitialized = true
    }
    
    private func rebuildMainView(){
        
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
        
        let height = UIScreen.mainScreen().bounds.height * 0.55
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