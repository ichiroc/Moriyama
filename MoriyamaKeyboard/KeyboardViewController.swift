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
    var calendarView : MRYMonthCalendarCollectionView!
    var prevViewController : UIViewController?
    var mainViewController : MRYAbstractMainViewController
    let monthCalendarCollectionViewDataSource = MRYMonthCalendarCollectionViewDataSource()
    private var views : Dictionary<String,UIView> = [:]
    private var initialized : Bool = false
    
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    override func viewWillAppear(animated: Bool) {
        initLayout()
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
    func transientToViewController3(newMainVC : MRYAbstractMainViewController){
        let currentVC = mainViewController
        currentVC.willMoveToParentViewController(nil)
        self.addChildViewController(newMainVC)
        self.inputView?.addSubview(newMainVC.view)
        // TODO: set initial layout constraints here
        
        let width = currentVC.view.bounds.size.width
        let height = currentVC.view.bounds.size.height
        newMainVC.view.frame = CGRectMake(MARGIN_LEFT,height+100,width,height)
        

        self.inputView?.layoutIfNeeded()
        UIView.animateWithDuration(0.25,
            delay: 0,
            options: UIViewAnimationOptions.TransitionNone ,
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
    
    func transientToViewController(newMainVC : MRYAbstractMainViewController, back: Bool = false){
        let currentVC = mainViewController
        currentVC.willMoveToParentViewController(nil)
        self.addChildViewController(newMainVC)
        self.inputView?.addSubview(newMainVC.view)
        
        // set initial layout constraints here
        let width = newMainVC.view.frame.width
        let height = newMainVC.view.frame.height
        if !back {
            newMainVC.view.frame = CGRectMake(MARGIN_LEFT , -height, width, height)
        }
        self.inputView?.layoutIfNeeded()
        self.transitionFromViewController(
            currentVC,
            toViewController: newMainVC,
            duration: 0,
            options: [ UIViewAnimationOptions.TransitionNone ],
            animations: {
                self.views["main"] = newMainVC.view
                self.mainViewController = newMainVC
                self.rebuildConstraints()
                if back{
                    currentVC.view.frame = CGRectMake( MARGIN_LEFT , -height ,width,height)
                }
                self.inputView?.layoutIfNeeded()
            },
            completion: { (success : Bool) in
                if success{
                    currentVC.view.removeFromSuperview()
                    currentVC.removeFromParentViewController()
                    self.prevViewController = currentVC
                }
        })
        
    }
    

    private func transientToViewControllerWithNoAnimation(newMainVC : MRYAbstractMainViewController){
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

        
        self.inputView?.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-m_left-[next(35)]-[space]-[comma(==next)]-[delete(==next)]-[return(==next)]-m_right-|",
                options: [.AlignAllCenterY, .AlignAllTop, .AlignAllBottom] ,
                metrics: METRICS,
                views: views)
        )

        self.inputView?.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-m_left-[main]-m_right-|",
                options: NSLayoutFormatOptions(rawValue: 0),
                metrics: METRICS,
                views: views)
        )
        
        self.inputView?.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-m_top-[main(>=250@999)]-3-[space(40)]-m_bottom-|",
                options: NSLayoutFormatOptions(rawValue: 0),
                metrics: METRICS,
                views: views)
        )
        
    }

    enum Orientation{
        case Landscape
        case Portrait
    }
    
}