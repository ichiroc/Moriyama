//
//  MRYButton.swift
//  Moriyama
//
//  Created by Ichiro on 2015/12/26.
//  Copyright © 2015年 Ichiro. All rights reserved.
//

import UIKit

class MRYKeyboardButton : UIButton{
    var _text: String?
    var customAction : (() -> Void)?
    let normalBackgroundColor: UIColor = UIColor.whiteColor()
    let normalTitleColor : UIColor = UIColor.blackColor()
    
   /** 
     Image Button
     */
    init(imageFileName: String,
        backgroundColor: UIColor? = nil,
        action: (() -> Void)? = nil,
        round : CGFloat = 3.0 ){
            super.init(frame: CGRectZero)
            self.translatesAutoresizingMaskIntoConstraints = false
            
            self.setImage(UIImage.init(named: imageFileName), forState: .Normal)
            self.imageView?.contentMode = .ScaleAspectFit
            self.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            customAction = action
            backgroundColor.map{ normalBackgroundColor = $0 }
            self.backgroundColor = normalBackgroundColor
            self.layer.cornerRadius = round
            self.addTarget(self, action: "touchUpInside", forControlEvents: .TouchUpInside)
            self.addTarget(self, action: "touchDown", forControlEvents: .TouchDown)
            self.addTarget(self, action: "touchUpOutside", forControlEvents: .TouchUpOutside)
    }
    
    /**
     Text Button
     */
    init( title: String,
        text: String? = nil,
        backgroundColor : UIColor? = nil,
        titleColor: UIColor? = nil,
        action: (() -> Void)? = nil,
        round: CGFloat = 3.0){
            customAction = action
            if let txt = text {
                _text = txt
            }else{
                _text = title
            }
            super.init(frame: CGRectZero)
            self.translatesAutoresizingMaskIntoConstraints = false
            titleColor.map{ normalTitleColor = $0 }
            self.setTitle(title, forState: .Normal)
            self.titleLabel?.font = UIFont.systemFontOfSize(16)
            self.setTitleColor(normalTitleColor, forState: .Normal)
            backgroundColor.map{ normalBackgroundColor = $0 }
            self.backgroundColor = normalBackgroundColor
            self.layer.cornerRadius = round
            self.addTarget(self, action: "touchUpInside", forControlEvents: .TouchUpInside)
            self.addTarget(self, action: "touchDown", forControlEvents: .TouchDown)
            self.addTarget(self, action: "touchUpOutside", forControlEvents: .TouchUpOutside)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func touchDown(){
        self.setTitleColor(normalBackgroundColor, forState: .Normal)
        self.backgroundColor = normalTitleColor
    }
    
    func touchUpOutside(){
        resetColor()
    }
    
    func resetColor(){
        self.setTitleColor(normalTitleColor, forState: .Normal)
        self.backgroundColor = normalBackgroundColor
    }
    
    func touchUpInside(){
        resetColor()
        
        if let action = customAction {
            action()
            return
        }
        if let text = _text{
            MRYTextDocumentProxy.proxy.insertText(text)
        }
    }
}

