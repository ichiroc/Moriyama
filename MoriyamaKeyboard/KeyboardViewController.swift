//
//  KeyboardviewController.swift
//  MoriyamaKeyboard
//
//  Created by Ichiro on 2015/12/25.
//  Copyright © 2015年 Ichiro. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {

    @IBOutlet var nextKeyboardButton: UIButton!
    var calendarView : MRYMonthCalendarCollectionView!
    let monthCalendarCollectionViewDataSource = MRYMonthCalendarCollectionViewDataSource()
    let margins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    
    var currentOrientation = Orientation.Portrait
    override func updateViewConstraints() {
        super.updateViewConstraints()
    
        // Add custom view sizing constraints here
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Perform custom UI setup here
        MRYTextDocumentProxy.proxy = self.textDocumentProxy
        self.layoutSubviews()
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
            calendarView.reloadData()
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
    
    private func layoutSubviews(){
        // Perform custom UI setup here
        self.nextKeyboardButton = MRYKeyboardButton(title: "🌐", backgroundColor: UIColor.lightGrayColor(),action: { self.advanceToNextInputMode() })
        let returnKey = MRYKeyboardButton(title: "↩︎", text: "\n", backgroundColor: UIColor.blueColor(), titleColor: UIColor.whiteColor())
        let deleteKey = MRYKeyboardButton( title: "⌫",
            backgroundColor: UIColor.lightGrayColor(),
            action: {() -> Void in MRYTextDocumentProxy.proxy.deleteBackward()} )

        let spaceKey = MRYKeyboardButton(title: "space", text: " ")
        let commaKey = MRYKeyboardButton(title: ",", text: ",")
        calendarView = MRYMonthCalendarCollectionView(viewController: self)
        calendarView.dataSource = monthCalendarCollectionViewDataSource
        let views = [ "next": nextKeyboardButton,
            "delete": deleteKey,
            "space": spaceKey,
            "return": returnKey ,
            "comma": commaKey,
            "calendar": calendarView]
        
        self.inputView?.addSubview(nextKeyboardButton)
        self.inputView?.addSubview(deleteKey)
        self.inputView?.addSubview(spaceKey)
        self.inputView?.addSubview(returnKey)
        self.inputView?.addSubview(commaKey)
        self.inputView?.addSubview(calendarView)
        
        let metrics = [ "left": margins.left, "right": margins.right, "margin": margins.left ]
        
        self.inputView?.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-margin-[next(35)]-[space]-[comma(==next)]-[delete(==next)]-[return(==next)]-margin-|",
                options: [.AlignAllCenterY, .AlignAllTop, .AlignAllBottom] ,
                metrics: metrics,
                views: views)
        )

        self.inputView?.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-margin-[calendar]-margin-|",
                options: NSLayoutFormatOptions(rawValue: 0),
                metrics: metrics,
                views: views)
        )
        
        self.inputView?.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-[calendar(>=250@200)]-5-[space(40)]-5-|",
                options: NSLayoutFormatOptions(rawValue: 0),
                metrics: metrics,
                views: views)
        )
        
    }
    
    enum Orientation{
        case Landscape
        case Portrait
    }
    
}