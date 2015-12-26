//
//  KeyboardViewController.swift
//  MoriyamaKeyboard
//
//  Created by Ichiro on 2015/12/25.
//  Copyright © 2015年 Ichiro. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {

    @IBOutlet var nextKeyboardButton: UIButton!

    override func updateViewConstraints() {
        super.updateViewConstraints()
    
        // Add custom view sizing constraints here
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Perform custom UI setup here
        MRYTextDocumentPRoxy.proxy = self.textDocumentProxy
        self.layoutSubviews()
    }

//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Perform custom UI setup here
//        MRYTextDocumentPRoxy.proxy = self.textDocumentProxy
//        self.nextKeyboardButton = UIButton(type: .System)
//    
//        self.nextKeyboardButton.setTitle(NSLocalizedString("🌐", comment: "Title for 'Next Keyboard' button"), forState: .Normal)
//        self.nextKeyboardButton.sizeToFit()
//        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
//    
//        self.nextKeyboardButton.addTarget(self, action: "advanceToNextInputMode", forControlEvents: .TouchUpInside)
//        
//        self.view.addSubview(self.nextKeyboardButton)
//    
//        let nextKeyboardButtonLeftSideConstraint = NSLayoutConstraint(item: self.nextKeyboardButton, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1.0, constant: 0.0)
//        let nextKeyboardButtonBottomConstraint = NSLayoutConstraint(item: self.nextKeyboardButton, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
//        self.view.addConstraints([nextKeyboardButtonLeftSideConstraint, nextKeyboardButtonBottomConstraint])
//    }
//
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }

    override func textWillChange(textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
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
    
    func layoutSubviews(){
        // Perform custom UI setup here
        self.nextKeyboardButton = MRYKeyboardButton(title: "🌐", text: nil)
        self.nextKeyboardButton.addTarget(self, action: "advanceToNextInputMode", forControlEvents: .TouchUpInside)
        let deleteKey = MRYKeyboardButton( title: "⌫", text: nil)
        let spaceKey = MRYKeyboardButton(title: "Space", text: " ")
        let returnKey = MRYKeyboardButton(title: "↩︎", text: "\n")
        let commaKey = MRYKeyboardButton(title: ",", text: ",")
        let calendarView = UIView()
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.backgroundColor = UIColor.blueColor()
        let views = [ "next": nextKeyboardButton,
            "delete": deleteKey,
            "space": spaceKey,
            "return": returnKey ,
            "comma": commaKey,
            "calendar": calendarView]
        self.view.addSubview(nextKeyboardButton)
        self.view.addSubview(deleteKey)
        self.view.addSubview(spaceKey)
        self.view.addSubview(returnKey)
        self.view.addSubview(commaKey)
        self.view.addSubview(calendarView)
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-[next(45)]-[space]-[comma(45)]-[delete(45)]-[return(45)]-|", options: .AlignAllBottom , metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[calendar]-[next]-5-|", options: NSLayoutFormatOptions(rawValue: 0) , metrics: nil, views: views))
    }

}
